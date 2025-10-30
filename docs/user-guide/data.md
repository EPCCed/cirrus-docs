# Data Management and Transfer

This section covers the storage and file systems available on the
system and the different ways that you can transfer data to and from
Cirrus.

In all cases of data transfer, users should use the Cirrus login nodes.

## Cirrus file systems and storage

There are two different data storage types available to users:

- Home file system (CephFS)
- Work file systems (Lustre)

Each type of storage has different characteristics and policies, and is
suitable for different types of use.

There are also two different types of node available to users:

- Login nodes
- Compute nodes

Each type of node sees a different combination of the storage types. The
following table shows which storage options are available on different
node types:

| Storage     | Login nodes | Compute nodes | Notes     |
|-------------|-------------|---------------|-----------|
| Home        | yes         | no            | No backup |
| Work        | yes         | yes           | No backup |


### Home file system

!!! Important
    There are no backups of any data on the home file system. You should
    ensure you have copies of any critical data in a secure location to
    protect against loss of data from hardware failures.

Every project has an allocation on the home file system and your
project's space can always be accessed via the path
`/home/[project-code]`. The home file system is approximately 1.5 PB in
size and is implemented using the Ceph technology. This means that this
storage is not particularly high performance but are well suited to
standard operations like compilation and file editing. This file systems
is visible from the Cirrus login nodes.

#### Quotas on home file system

All projects are assigned a quota on the home file system. The project
PI or manager can split this quota up between groups of users if they
wish.

You can view any home file system quotas that apply to your account by
logging into SAFE and navigating to the page for your Cirrus login
account.

1.  [Log into SAFE](https://safe.epcc.ed.ac.uk)
2.  Use the "Login accounts" menu and select your Cirrus login account
3.  The "Login account details" table lists any user or group quotas
    that are linked with your account. (If there is no quota shown for a
    row then you have an unlimited quota for that item, but you may
    still may be limited by another quota.)

Quota and usage data on SAFE is updated twice daily so may not be
exactly up to date with the situation on the system itself.

#### From the command line

Some useful information on the current contents of directories on the
`/home` file system is available from the command line by using the Ceph
command `getfattr`. This is to be preferred over standard Unix commands
such as `du` for reasons of efficiency.

For example, the number of entries (files plus directories) in a home
directory can be queried via

    $ cd
    $ getfattr -n ceph.dir.entries .
    # file: .
    ceph.dir.entries="33"

The corresponding attribute `rentries` gives the recursive total in all
subdirectories, that is, the total number of files and directories:

    $ getfattr -n ceph.dir.rentries .
    # file: .
    ceph.dir.rentries="1619179"

Other useful attributes (all prefixed with `ceph.dir.`) include `files`
which is the number of ordinary files, `subdirs` the number of
subdirectories, and `bytes` the total number of bytes used. All these
have a corresponding recursive version, respectively: `rfiles`,
`rsubdirs`, and `rbytes`.

A full path name can be specified if required.

### Work file system

!!! Important
    There are no backups of any data on the work file system. You should
    ensure you have copies of any critical data in a secure location to
    protect against loss of data from hardware failures.

Every project has an allocation on the work file system and your
project's space can always be accessed via the path
`/work/[project-code]`. The work file system is approximately 1 PB in
size and is implemented using the Lustre parallel file system
technology. They are designed to support data in large files. The
performance for data stored in large numbers of small files is probably
not going to be as good.

Ideally, the work file system should only contain data that is:

- actively in use;
- recently generated and in the process of being saved elsewhere; or
- being made ready for up-coming work.

In practice it may be convenient to keep copies of datasets on the work
file system that you know will be needed at a later date. However, make
sure that important data is always backed up elsewhere and that your
work would not be significantly impacted if the data on the work file
system was lost.

If you have data on the work file system that you are not going to need
in the future please delete it.

#### Quotas on the work file system

As for the home file system, all projects are assigned a quota on the
work file system. The project PI or manager can split this quota up
between groups of users if they wish.

You can view any work file system quotas that apply to your account by
logging into SAFE and navigating to the page for your Cirrus login
account.

1.  [Log into SAFE](https://safe.epcc.ed.ac.uk)
2.  Use the "Login accounts" menu and select your Cirrus login account
3.  The "Login account details" table lists any user or project quotas
    that are linked with your account. (If there is no quota shown for a
    row then you have an unlimited quota for that item, but you may
    still may be limited by another quota.)

Quota and usage data on SAFE is updated twice daily so may not be
exactly up to date with the situation on the system itself.

You can also examine up to date quotas and usage on the Cirrus system
itself using the `lfs quota` command. To do this:

Change directory to the work directory where you want to check the
quota. For example, if I wanted to check the quota for user `auser` in
project `t01` then I would:

    [auser@cirrus-login1 auser]$ cd /work/t01/t01/auser

    [auser@cirrus-login1 auser]$ lfs quota -hu auser .
    Disk quotas for usr auser (uid 68826):
         Filesystem    used   quota   limit   grace   files   quota   limit   grace
                  .  5.915G      0k      0k       -   51652       0       0       -
    uid 68826 is using default block quota setting
    uid 68826 is using default file quota setting

the quota and limit of 0k here indicate that no user quota is set for
this user.

To check your project quota, you would use the command:

    [auser@cirrus-login1 auser]$ lfs quota -hp $(id -g)'01' .
    Disk quotas for prj 3773301 (pid 3773301):
     Filesystem    used   quota   limit   grace   files   quota   limit   grace
              .   958.3G     0k  13.57T       - 9038326       0       0       -
    pid 3773301 is using default file quota setting

the limit of `13.57T` indicates the quota for the project.

## Archiving

If you have related data that consists of a large number of small files
it is strongly recommended to pack the files into a larger "archive"
file for ease of transfer and manipulation. A single large file makes
more efficient use of the file system and is easier to move and copy and
transfer because significantly fewer meta-data operations are required.
Archive files can be created using tools like `tar` and `zip`.

#### tar

The `tar` command packs files into a "tape archive" format. The command
has general form:

    tar [options] [file(s)]

Common options include:

   - `-c` create a new archive
   - `-v` verbosely list files processed
   - `-W` verify the archive after writing
   - `-l` confirm all file hard links are included in the archive
   - `-f` use an archive file (for historical reasons, tar writes its
     output to stdout by default rather than a file).

Putting these together:

    tar -cvWlf mydata.tar mydata

will create and verify an archive.

To extract files from a tar file, the option `-x` is used. For example:

    tar -xf mydata.tar

will recover the contents of `mydata.tar` to the current working
directory.

To verify an existing tar file against a set of data, the `-d` (diff)
option can be used. By default, no output will be given if a
verification succeeds and an example of a failed verification follows:

    $> tar -df mydata.tar mydata/*
    mydata/damaged_file: Mod time differs
    mydata/damaged_file: Size differs

!!! note
    tar files do not store checksums with their data, requiring
    the original data to be present during verification.

!!! tip
    Further information on using `tar` can be found in the `tar` manual
    (accessed via `man tar` or at [man
    tar](https://linux.die.net/man/1/tar)).

#### zip

The zip file format is widely used for archiving files and is supported
by most major operating systems. The utility to create zip files can be
run from the command line as:

    zip [options] mydata.zip [file(s)] 

Common options are:

   - `-r` used to zip up a directory
   - `-#` where "\#" represents a digit ranging from 0 to 9 to specify
     compression level, 0 being the least and 9 the most. Default
     compression is -6 but we recommend using -0 to speed up the
     archiving process.

Together:

    zip -0r mydata.zip mydata

will create an archive.

!!! note
    Unlike tar, zip files do not preserve hard links. File data will be
    copied on archive creation, *e.g.* an uncompressed zip archive of a
    100MB file and a hard link to that file will be approximately 200MB in
    size. This makes zip an unsuitable format if you wish to precisely
    reproduce the file system layout.

The corresponding `unzip` command is used to extract data from the
archive. The simplest use case is:

    unzip mydata.zip

which recovers the contents of the archive to the current working
directory.

Files in a zip archive are stored with a CRC checksum to help detect
data loss. `unzip` provides options for verifying this checksum against
the stored files. The relevant flag is `-t` and is used as follows:

    $> unzip -t mydata.zip
    Archive:  mydata.zip
        testing: mydata/                 OK
        testing: mydata/file             OK
    No errors detected in compressed data of mydata.zip.

!!! tip
    Further information on using `zip` can be found in the `zip` manual
    (accessed via `man zip` or at [man
    zip](https://linux.die.net/man/1/zip)).

## Data transfer

### Before you start

Read Harry Mangalam's guide on [How to transfer large amounts of data
via
network](https://hjmangalam.wordpress.com/2009/09/14/how-to-transfer-large-amounts-of-data-via-network/).
This tells you *all* you want to know about transferring data.

### Data Transfer via SSH

The easiest way of transferring data to/from Cirrus is to use one of the
standard programs based on the SSH protocol such as `scp`, `sftp` or
`rsync`. These all use the same underlying mechanism (ssh) as you
normally use to login to Cirrus. So, once the command has been executed
via the command line, you will be prompted for your password for the
specified account on the **remote machine**.

To avoid having to type in your password multiple times you can set up a
*ssh-key* as documented in the User Guide at `connecting`

### SSH Transfer Performance Considerations

The ssh protocol encrypts all traffic it sends. This means that
file-transfer using ssh consumes a relatively large amount of CPU time
at both ends of the transfer. The encryption algorithm used is
negotiated between the ssh-client and the ssh-server. There are command
line flags that allow you to specify a preference for which encryption
algorithm should be used. You may be able to improve transfer speeds by
requesting a different algorithm than the default. The *arcfour*
algorithm is usually quite fast assuming both hosts support it.

A single ssh based transfer will usually not be able to saturate the
available network bandwidth or the available disk bandwidth so you may
see an overall improvement by running several data transfer operations
in parallel. To reduce metadata interactions it is a good idea to
overlap transfers of files from different directories.

In addition, you should consider the following when transferring data.

- Only transfer those files that are required. Consider which data you
  really need to keep.
- Combine lots of small files into a single *tar* archive, to reduce the
  overheads associated in initiating many separate data transfers (over
  SSH each file counts as an individual transfer).
- Compress data before sending it, e.g. using gzip.

### scp command

The `scp` command creates a copy of a file, or if given the `-r` flag, a
directory, on a remote machine.

For example, to transfer files to Cirrus:

    scp [options] source user@login.cirrus.ac.uk:[destination]

(Remember to replace `user` with your Cirrus username in the example
above.)

In the above example, the `[destination]` is optional, as when left out
`scp` will simply copy the source into the user's home directory. Also
the `source` should be the absolute path of the file/directory being
copied or the command should be executed in the directory containing the
source file/directory.

!!! tip
    If your local version of OpenSSL (the library underlying `scp`) is 
    very new you may see errors transferring data to Cirrus using `scp` where the version
    of OpenSSL is older. The errors typically look like
    `scp: upload "mydata": path canonicalization failed`. You can get
    around this issue by adding the `-O` option to `scp`.

If you want to request a different encryption algorithm add the
`-c [algorithm-name]` flag to the `scp` options. For example, to use the
(usually faster) *aes128-ctr* encryption algorithm you would use:

    scp [options] -c aes128-ctr source user@login.cirrus.ac.uk:[destination]

(Remember to replace `user` with your Cirrus username in the example
above.)

### rsync command

The `rsync` command can also transfer data between hosts using a `ssh`
connection. It creates a copy of a file or, if given the `-r` flag, a
directory at the given destination, similar to `scp` above.

Given the `-a` option rsync can also make exact copies (including
permissions), this is referred to as *mirroring*. In this case the
`rsync` command is executed with ssh to create the copy on a remote
machine.

To transfer files to Cirrus using `rsync` the command should have the
form:

    rsync [options] -e ssh source user@login.cirrus.ac.uk:[destination]

(Remember to replace `user` with your Cirrus username in the example
above.)

In the above example, the `[destination]` is optional, as when left out
`rsync` will simply copy the source into the users home directory. Also
the `source` should be the absolute path of the file/directory being
copied or the command should be executed in the directory containing the
source file/directory.

Additional flags can be specified for the underlying `ssh` command by
using a quoted string as the argument of the `-e` flag. e.g.

    rsync [options] -e "ssh -c aes128-ctr" source user@login.cirrus.ac.uk:[destination]

(Remember to replace `user` with your Cirrus username in the example
above.)



### Data transfer using rclone

Rclone is a command-line program to manage files on cloud storage. You can transfer files directly to/from cloud storage services, such as MS OneDrive and Dropbox. The program preserves timestamps and verifies checksums at all times.

First of all, you must download and unzip rclone on Cirrus:

    wget https://downloads.rclone.org/v1.62.2/rclone-v1.62.2-linux-amd64.zip
    unzip rclone-v1.62.2-linux-amd64.zip
    cd rclone-v1.62.2-linux-amd64/

The previous code snippet uses rclone v1.62.2, which was the latest version when these instructions were written.

Configure rclone using `./rclone config`. This will guide you through an interactive setup process where you can make a new remote (called `remote`). See the following for detailed instructions for:

- [Microsoft OneDrive](https://rclone.org/onedrive/)
- [Dropbox](https://rclone.org/dropbox/)

Please note that a token is required to connect from Cirrus to the cloud service. You need a web browser to get the token. The recommendation is to run rclone in your laptop using `rclone authorize`, get the token, and then copy the token from your laptop to Cirrus. The rclone website contains further instructions on [configuring rclone on a remote machine without web browser](https://rclone.org/remote_setup/).

Once all the above is done, you’re ready to go. If you want to copy a directory, please use:

    rclone copy <cirrus_directory> remote:<cloud_directory>

Please note that “remote” is the name that you have chosen when running rclone config`. To copy files, please use:

    rclone copyto <cirrus_file> remote:<cloud_file>

!!! Note

    If the session times out while the data transfer takes place, adding the `-vv` flag to an rclone transfer forces rclone to output to the terminal and therefore avoids triggering the timeout process.

### Data transfer using Globus

The Cirrus `/work` filesystem, which is hosted on the e1000 fileserver, has a Globus Collection (formerly known as an endpoint) with the name `e1000-fs1 directories`   

[Full step-by-step guide for using Globus](../globus) to transfer files to/from Cirrus `/work`

