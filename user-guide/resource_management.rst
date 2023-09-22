File and Resource Management
============================

This section covers some of the tools and technical knowledge that will
be key to maximising the usage of the Cirrus system, such as the online
administration tool SAFE and calculating the CPU-time available.

The default file permissions are then outlined, along with a description
of changing these permissions to the desired setting. This leads on to
the sharing of data between users and systems often a vital tool for
project groups and collaboration.

Finally we cover some guidelines for I/O and data archiving on Cirrus.

The Cirrus Administration Web Site (SAFE)
-----------------------------------------

All users have a login and password on the Cirrus Administration Web
Site (also know as the 'SAFE'):
`SAFE <https://safe.epcc.ed.ac.uk/>`__. Once logged into this
web site, users can find out much about their usage of the Cirrus
system, including:

-  Account details - password reset, change contact details
-  Project details - project code, start and end dates
-  CPUh balance - how much time is left in each project you are a member
   of
-  Filesystem details - current usage and quotas
-  Reports - generate reports on your usage over a specified period,
   including individual job records
-  Helpdesk - raise queries and track progress of open queries

Checking your CPU/GPU time allocations
--------------------------------------

You can view these details by logging into the SAFE
(https://safe.epcc.ed.ac.uk).

Use the *Login accounts* menu to select the user account that you wish
to query. The page for the login account will summarise the resources
available to account.

You can also generate reports on your usage over a particular period and
examine the details of how many CPUh or GPUh individual jobs on the system cost.
To do this use the *Service information* menu and selet *Report generator*.

Disk quotas
-----------

Disk quotas on Cirrus are managed via
`SAFE <https://safe.epcc.ed.ac.uk>`__

For live disk usage figures on the Lustre ``/work`` file system, use

::

    lfs quota -hu <username> /work

    lfs quota -hg <groupname> /work 

Backup policies
---------------

The ``/home`` file system is not backed up.

The ``/work`` file system is not backed up.

The solid-state storage ``/scratch/space1`` file system is not backed up.

We strongly advise that you keep copies of any critical data on on an
alternative system that is fully backed up.

Sharing data with other Cirrus users
------------------------------------

How you share data with other Cirrus users depends on whether or not they belong 
to the same project as you. Each project has two shared folders that can be used 
for sharing data.

Sharing data with Cirrus users in your project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each project has an inner shared folder on the ``/home`` and ``/work`` 
filesystems:

::

    /home/[project code]/[project code]/shared

    /work/[project code]/[project code]/shared

This folder has read/write permissions for all project members. You can place any 
data you wish to share with other project members in this directory. For example, 
if your project code is ``x01`` the inner shared folder on the ``/work`` file system 
would be located at ``/work/x01/x01/shared``.

Sharing data with all Cirrus users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each project also has an outer shared folder on the ``/home`` and ``/work`` 
filesystems:

::

    /home/[project code]/shared

    /work/[project code]/shared

It is writable by all project members and readable by any user on the system. You 
can place any data you wish to share with other Cirrus users who are not members 
of your project in this directory. For example, if your project code is ``x01`` the 
outer shared folder on the ``/work`` file system would be located at 
``/work/x01/shared``.


File permissions and security
-----------------------------

You should check the permissions of any files that you place in the shared area, 
especially if those files were created in your own Cirrus account. Files of the 
latter type are likely to be readable by you only.

The chmod command below shows how to make sure that a file placed in the outer shared 
folder is also readable by all Cirrus users.

::

    chmod a+r /work/x01/shared/your-shared-file.txt

Similarly, for the inner shared folder, chmod can be called such that read permission 
is granted to all users within the x01 project.

::

    chmod g+r /work/x01/x01/shared/your-shared-file.txt

If you're sharing a set of files stored within a folder hierarchy the chmod is slightly 
more complicated.

::

    chmod -R a+Xr /work/x01/shared/my-shared-folder
    chmod -R g+Xr /work/x01/x01/shared/my-shared-folder

The ``-R`` option ensures that the read permission is enabled recursively and the 
``+X`` guarantees that the user(s) you're sharing the folder with can access the 
subdirectories below my-shared-folder.

Default Unix file permissions can be specified by the ``umask`` command.
The default umask value on Cirrus is 22, which provides "group" and
"other" read permissions for all files created, and "group" and "other"
read and execute permissions for all directories created. This is highly
undesirable, as it allows everyone else on the system to access (but at
least not modify or delete) every file you create. Thus it is strongly
recommended that users change this default umask behaviour, by adding
the command ``umask 077`` to their ``$HOME/.profile`` file. This umask
setting only allows the user access to any file or directory created.
The user can then selectively enable "group" and/or "other" access to
particular files or directories if required.

File types
----------

ASCII (or formatted) files
~~~~~~~~~~~~~~~~~~~~~~~~~~

These are the most portable, but can be extremely inefficient to read
and write. There is also the problem that if the formatting is not done
correctly, the data may not be output to full precision (or to the
subsequently required precision), resulting in inaccurate results when
the data is used. Another common problem with formatted files is FORMAT
statements that fail to provide an adequate range to accommodate future
requirements, e.g. if we wish to output the total number of processors,
NPROC, used by the application, the statement:

::

    WRITE (*,'I3') NPROC

will not work correctly if NPROC is greater than 999.

Binary (or unformatted) files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These are much faster to read and write, especially if an entire array
is read or written with a single READ or WRITE statement. However the
files produced may not be readable on other systems.

GNU compiler ``-fconvert=swap`` compiler option.
    This compiler option often needs to be used together with a second
    option ``-frecord-marker``, which specifies the length of record
    marker (extra bytes inserted before or after the actual data in the
    binary file) for unformatted files generated on a particular system.
    To read a binary file generated by a big-endian system on Cirrus,
    use
    ``-fconvert=swap -frecord-marker=4``.
    Please note that due to the same 'length of record marker' reason,
    the unformatted files generated by GNU and other compilers on Cirrus
    are not compatible. In fact, the same WRITE statements would result
    in slightly larger files with GNU compiler. Therefore it is
    recommended to use the same compiler for your simulations and
    related pre- and post-processing jobs.

Other options for file formats include:

Direct access files
    Fortran unformatted files with specified record lengths. These may
    be more portable between different systems than ordinary (i.e.
    sequential IO) unformatted files, with significantly better
    performance than formatted (or ASCII) files. The "endian" issue
    will, however, still be a potential problem.
Portable data formats
    These machine-independent formats for representing scientific data
    are specifically designed to enable the same data files to be used
    on a wide variety of different hardware and operating systems. The
    most common formats are:

    -  netCDF: http://www.unidata.ucar.edu/software/netcdf/
    -  HDF: http://www.hdfgroup.org/HDF5/

    It is important to note that these portable data formats are
    evolving standards, so make sure you are aware of which version of
    the standard/software you are using, and keep up-to-date with any
    backward-compatibility implications of each new release.

File IO Performance Guidelines
------------------------------

Here are some general guidelines

-  Whichever data formats you choose, it is vital that you test that you
   can access your data correctly on all the different systems where it
   is required. This testing should be done as early as possible in the
   software development or porting process (i.e. before you generate
   lots of data from expensive production runs), and should be repeated
   with every major software upgrade.
-  Document the file formats and metadata of your important data files
   very carefully. The best documentation will include a copy of the
   relevant I/O subroutines from your code. Of course, this
   documentation must be kept up-to-date with any code modifications.
-  Use binary (or unformatted) format for files that will only be used
   on the Intel system, e.g. for checkpointing files. This will give the
   best performance. Binary files may also be suitable for larger output
   data files, if they can be read correctly on other systems.
-  Most codes will produce some human-readable (i.e. ASCII) files to
   provide some information on the progress and correctness of the
   calculation. Plan ahead when choosing format statements to allow for
   future code usage, e.g. larger problem sizes and processor counts.
-  If the data you generate is widely shared within a large community,
   or if it must be archived for future reference, invest the time and
   effort to standardise on a suitable portable data format, such as
   netCDF or HDF.

Common I/O patterns
-------------------

There is a number of I/O patterns that are frequently used in
applications:

Single file, single writer (Serial I/O)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A common approach is to funnel all the I/O through a single master
process. Although this has the advantage of producing a single file, the
fact that only a single client is doing all the I/O means that it gains
little benefit from the parallel file system.

File-per-process (FPP)
~~~~~~~~~~~~~~~~~~~~~~

One of the first parallel strategies people use for I/O is for each
parallel process to write to its own file. This is a simple scheme to
implement and understand but has the disadvantage that, at the end of
the calculation, the data is spread across many different files and may
therefore be difficult to use for further analysis without a data
reconstruction stage.

Single file, multiple writers without collective operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are a number of ways to achieve this. For example, many processes
can open the same file but access different parts by skipping some
initial offset; parallel I/O libraries such as MPI-IO, HDF5 and NetCDF
also enable this.

Shared-file I/O has the advantage that all the data is organised
correctly in a single file making analysis or restart more
straightforward.

The problem is that, with many clients all accessing the same file,
there can be a lot of contention for file system resources.

Single Shared File with collective writes (SSF)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem with having many clients performing I/O at the same time is
that, to prevent them clashing with each other, the I/O library may have
to take a conservative approach. For example, a file may be locked while
each client is accessing it which means that I/O is effectively
serialised and performance may be poor.

However, if I/O is done collectively where the library knows that all
clients are doing I/O at the same time, then reads and writes can be
explicitly coordinated to avoid clashes. It is only through collective
I/O that the full bandwidth of the file system can be realised while
accessing a single file.

Achieving efficient I/O
-----------------------

This section provides information on getting the best performance out of
the ``/work`` parallel file system on Cirrus when writing data,
particularly using parallel I/O patterns.

You may find that using the :doc:`/user-guide/solidstate` gives better
performance than ``/work`` for some applications and IO patterns.

Lustre
~~~~~~

The Cirrus ``/work`` file system use Lustre as a parallel file system
technology. The Lustre file system provides POSIX semantics (changes on
one node are immediately visible on other nodes) and can support very
high data rates for appropriate I/O patterns.

Striping
~~~~~~~~

One of the main factors leading to the high performance of ``/work`` Lustre file
systems is the ability to stripe data across multiple Object Storage
Targets (OSTs) in a round-robin fashion. Files are striped when the data
is split up in chunks that will then be stored on different OSTs across
the ``/work`` file system. Striping might improve the I/O performance because it
increases the available bandwidth since multiple processes can read and
write the same files simultaneously. However striping can also increase
the overhead. Choosing the right striping configuration is key to obtain
high performance results.

Users have control of a number of striping settings on Lustre file
systems. Although these parameters can be set on a per-file basis they
are usually set on directory where your output files will be written so
that all output files inherit the settings.

Default configuration
^^^^^^^^^^^^^^^^^^^^^

The file system on Cirrus has the following default stripe
settings:

-  A default stripe count of 1
-  A default stripe size of 1 MiB (1048576 bytes)

These settings have been chosen to provide a good compromise for the
wide variety of I/O patterns that are seen on the system but are
unlikely to be optimal for any one particular scenario. The Lustre
command to query the stripe settings for a directory (or file) is
``lfs getstripe``. For example, to query the stripe settings of an
already created directory ``res_dir``:

::

   $ lfs getstripe res_dir/
   res_dir
   stripe_count:   1 stripe_size:    1048576 stripe_offset:  -1 

Setting Custom Striping Configurations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users can set stripe settings for a directory (or file) using the
``lfs setstripe`` command. The options for ``lfs setstripe`` are:

-  ``[--stripe-count|-c]`` to set the stripe count; 0 means use the
   system default (usually 1) and -1 means stripe over all available
   OSTs.
-  ``[--stripe-size|-s]`` to set the stripe size; 0 means use the system
   default (usually 1 MB) otherwise use k, m or g for KB, MB or GB
   respectively
-  ``[--stripe-index|-i]`` to set the OST index (starting at 0) on which
   to start striping for this file. An index of -1 allows the MDS to
   choose the starting index and it is strongly recommended, as this
   allows space and load balancing to be done by the MDS as needed.

For example, to set a stripe size of 4 MiB for the existing directory
``res_dir``, along with maximum striping count you would use:

::

   $ lfs setstripe -s 4m -c -1 res_dir/
