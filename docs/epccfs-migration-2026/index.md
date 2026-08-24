# Migration to EPCCfs storage

!!! important
    This information was last updated on 20 Aug 2026.

This section of the documentation covers the process of moving from the current
storage for compute jobs (`/work` file system) to new storage (`epccfs` file 
system).

The current `/work` storage is coming to its end of life so on **Wed 16 Sep 2026** we
are moving to new storage mounted on Cirrus login and compute nodes as `/epccfs`.

## Migration process

There will be a full maintenance session (Wed 16 Sep 2026) with no jobs running on compute
nodes for this switch. During this maintenance session, the following high level
steps will be followed:

1. All jobs Pending in the queue will be deleted
   - This step is necessary as jobs in the Pending queue before the switch will 
     expect to be able to write to `/work`. As this will not be possible after the
     switch, any pending jobs would fail.
2. Current `/work` storage will be changed to read-only mode
3. `/epccfs` storage will be made available in read/write-mode
4. Final testing of `/epccfs`
5. Service returned to users

The current `/work` storage will remain available in read-only mode until at least 
21 Nov 2026 for users to copy over any data they wish to access/keep on the 
new `/epccfs` storage.

## Impacts for users

- Any jobs in Pending state at the start of the maintenance session for the switch
  will be deleted. You must resubmit them (using the new `/epccfs` storage) once the
  system returns from maintenance.
- Any jobs submitted after the maintenance session must write to locations in 
  `/epccfs`. Any jobs that attempt to write to locations in `/work` will fail.
- Following the maintenance session, you will no longer be able to write data to 
  any locations in `/work`. This data will remain available in read-only mode 
  until at least 21 Nov 2026.
  - Users should copy any data they wish to keep off `/work` before 21 Nov 2026.

## EPCCfs storage

!!! note 
    This is a copy of the documentation in the [Data section](../user-guide/data.md) of the
    Cirrus User Guide. 

Every project has an allocation on the EPCCfs storage and your
project's space can always be accessed via the path
`/epccfs/[project-code]`. The EPCCfs storage provides a large 
capacity (more than 30 PB) and is currently implemented using
the VAST technology.

!!! warning
    EPCCfs is not backed up at all.


You can find your directory on the EPCCfs at:

```
/epccfs/<project code>/<project code>/<username>
```

For example, if your username is `auser` and you are in the `e05` project, then
your EPCCfs directory will be at:

```
/epccfs/e05/e05/auser
```

#### Copying data to `/epccfs` from `/work` file systems

You can use the standard Linux `cp` command to copy data from other Cirrus file
systems to EPCCfs or vice versa. For example, to
transfer the file `important-data.tar.gz` from the `/work` file system to
`/epccfs` you would use the following command (assuming you are user `auser`
in project `e05`):

```
cp /work/e05/e05/auser/important-data.tar.gz /epccfs/e05/e05/auser/
```

(remember to replace the project code and username with your own username
and project code).

!!! tip "Use rclone parallel local data transfers for large datasets"
    If you are transferring a large amount of data to EPCCfs, you should consider
    using [rclone local data transfer](#local-file-transfer) (perhaps in a 
    serial job submission script) rather than using the basic `cp` command.

#### Quotas on EPCCfs

As for the other Cirrus storage systems, all projects are assigned a quota on
EPCCfs. The project PI or manager can split this quota up
between users or groups of users if they wish.

You can view any EPCCfs quotas that apply to your account by
logging into SAFE and navigating to the page for your Cirrus login
account.

1. [Log into SAFE](https://safe.epcc.ed.ac.uk)
2. Use the "Login accounts" menu and select your Cirrus login account
3. The "Login account details" table lists any user or group quotas that
   are linked with your account. (If there is no quota shown for a row
   then you have an unlimited quota for that item, but you may still may
   be limited by another quota.)

!!! tip
    Quota and usage data on SAFE is updated twice daily so may not be
    exactly up to date with the situation on the systems themselves.

You can also query quotas that apply to your current EPCCfs directory from the
the command line using the `df -h $PWD` command, for example:

```
auser@uan01:/epccfs/e05/e05/auser> df -h $PWD
Filesystem                          Size  Used Avail Use% Mounted on
fs02.naidin.epcc.ed.ac.uk:/cirrus  8.8T  1.8G  8.8T   1% /mnt/nfs/epccfs
```
