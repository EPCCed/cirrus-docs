Data Management and Transfer
============================

This section covers the storage and file systems available on the system; the
different ways that you can transfer data to and from Cirrus; and how to
transfer backed up data from prior to the March 2022 Cirrus upgrade.

In all cases of data transfer, users should use the Cirrus login nodes.

Cirrus file systems and storage
-------------------------------

The Cirrus service, like many HPC systems, has a complex structure. There are
a number of different data storage types available to users:

- Home file system
- Work file systems
- Solid state storage

Each type of storage has different characteristics and policies, and is suitable for different types of use.

There are also two different types of node available to users:

- Login nodes
- Compute nodes

Each type of node sees a different combination of the storage types. The following table shows which storage
options are available on different node types:

+-------------+-------------+---------------+-------------+
| Storage     | Login nodes | Compute nodes | Notes       |
+-------------+-------------+---------------+-------------+
| Home        | yes         | no            | No backup   |
+-------------+-------------+---------------+-------------+
| Work        | yes         | yes           | No backup   |
+-------------+-------------+---------------+-------------+
| Solid state | yes         | yes           | No backup   |
+-------------+-------------+---------------+-------------+

Home file system
~~~~~~~~~~~~~~~~

Every project has an allocation on the home file system and your project's space can always be accessed via the
path ``/home/[project-code]``. The home file system is approximately 1.5 PB in size and is implemented using the
Ceph technology. This means that this storage is not particularly high performance but are well suited to standard
operations like compilation and file editing. This file systems is visible from the Cirrus login nodes.

There are currently no backups of any data on the home file system.

Quotas on home file system
^^^^^^^^^^^^^^^^^^^^^^^^^^

All projects are assigned a quota on the home file system. The project PI or manager can split this quota up between
groups of users if they wish.

You can view any home file system quotas that apply to your account by logging into SAFE and navigating to the page
for your Cirrus login account.

1. `Log into SAFE <https://safe.epcc.ed.ac.uk>`_
2. Use the "Login accounts" menu and select your Cirrus login account
3. The "Login account details" table lists any user or group quotas that are linked with your account. (If there is no
   quota shown for a row then you have an unlimited quota for that item, but you may still may be limited by another
   quota.)

Quota and usage data on SAFE is updated twice daily so may not be exactly up to date with the situation on the
system itself.

From the command line
"""""""""""""""""""""

Some useful information on the current contents of directories on
the ``/home`` file system
is available from the command line by using the Ceph command ``getfattr``.
This is to be preferred over standard Unix commands such as ``du`` for
reasons of efficiency.

For example, the number of entries (files plus directories) in a home
directory can be queried via

::

   $ cd
   $ getfattr -n ceph.dir.entries .
   # file: .
   ceph.dir.entries="33"

The corresponding attribute ``rentries`` gives the recursive total in
all subdirectories, that is, the total number of files and directories:

::

   $ getfattr -n ceph.dir.rentries .
   # file: .
   ceph.dir.rentries="1619179"

Other useful attributes (all prefixed with ``ceph.dir.``) include ``files``
which is the number of ordinary files, ``subdirs`` the number of
subdirectories, and ``bytes`` the total number of bytes used. All these
have a corresponding recursive version, respectively: ``rfiles``,
``rsubdirs``, and ``rbytes``.

A full path name can be specified if required.



Work file system
~~~~~~~~~~~~~~~~

Every project has an allocation on the work file system and your project's space can always be accessed via the
path ``/work/[project-code]``. The work file system is approximately 400 TB in size and is implemented using the
Lustre parallel file system technology. They are designed to support data in large files. The performance for data
stored in large numbers of small files is probably not going to be as good.

There are currently no backups of any data on the work file system.

Ideally, the work file system should only contain data that is:

- actively in use;
- recently generated and in the process of being saved elsewhere; or
- being made ready for up-coming work.

In practice it may be convenient to keep copies of datasets on the work file system that you know will be needed at a
later date. However, make sure that important data is always backed up elsewhere and that your work would not be
significantly impacted if the data on the work file system was lost.

If you have data on the work file system that you are not going to need in the future please delete it.

Quotas on the work file system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tip::

   The capacity of the home file system is much larger than the work file system
   so you should store most data on home and only move data to work that you need
   for current running work.

As for the home file system, all projects are assigned a quota on the work file system. The project PI or manager
can split this quota up between groups of users if they wish.

You can view any work file system quotas that apply to your account by logging into SAFE and navigating to the page
for your Cirrus login account.

1. `Log into SAFE <https://safe.epcc.ed.ac.uk>`_
2. Use the "Login accounts" menu and select your Cirrus login account
3. The "Login account details" table lists any user or group quotas that are linked with your account. (If there is no
   quota shown for a row then you have an unlimited quota for that item, but you may still may be limited by another
   quota.)
  

Quota and usage data on SAFE is updated twice daily so may not be exactly up to date with the situation on the system
itself.

You can also examine up to date quotas and usage on the Cirrus system itself using the ``lfs quota`` command. To do this:

Change directory to the work directory where you want to check the quota. For example, if I wanted to check the quota
for user ``auser`` in project ``t01`` then I would:

:: 

  [auser@cirrus-login1 auser]$ cd /work/t01/t01/auser

  [auser@cirrus-login1 auser]$ lfs quota -hu auser .
  Disk quotas for usr auser (uid 68826):
       Filesystem    used   quota   limit   grace   files   quota   limit   grace
                .  5.915G      0k      0k       -   51652       0       0       -
  uid 68826 is using default block quota setting
  uid 68826 is using default file quota setting

the quota and limit of 0k here indicate that no user quota is set for this user.

To check your project (group) quota, you would use the command:

::

   [auser@cirrus-login1 auser]$ lfs quota -hg t01 .
   Disk quotas for grp t01 (gid 37733):
        Filesystem    used   quota   limit   grace   files   quota   limit   grace
              .  958.3G      0k  13.57T       - 1427052       0       0       -
   gid 37733 is using default file quota setting
   
the limit of ``13.57T`` indicates the quota for the group.

Solid state storage
~~~~~~~~~~~~~~~~~~~

More information on using the solid state storage can be found in the
:doc:`/user-guide/solidstate` section of the user guide.

The solid state storage is not backed up.

Accessing Cirrus data from before March 2022
--------------------------------------------

Prior to the March 2022 Cirrus upgrade,all user date on the ``/lustre/sw``
filesystem was archived. Users can access their archived data from the 
Cirrus login nodes in the ``/home-archive`` directory. Assuming you are 
user ``auser`` from project ``x01``, your pre-rebuild archived data can be
found in:

::

    /home-archive/x01/auser

The data in the ``/home-archive`` file system is **read only** meaning that 
you will not be able to create, edit, or copy new information to this file 
system.

To make archived data visible from the compute nodes, you will need to 
copy the data from the ``/home-archive`` file system to the ``/home``
file system. Assuming again that you are user ``auser`` from project ``x01``
and that you were wanting to copy data from ``/home-archive/x01/auser/directory_to_copy``
to ``/home/x01/x01/auser/destination_directory``, you would do this by running:

::

    cp -r /home-archive/x01/auser/directory_to_copy \
       /home/x01/x01/auser/destination_directory

Note that the project code appears once in the path for the old home archive and 
twice in the path on the new /home file system.

.. note::

   The capacity of the home file system is much larger than the work file system
   so you should move data to home rather than work.

Data transfer
-------------

Before you start
~~~~~~~~~~~~~~~~

Read Harry Mangalam's guide on `How to transfer large amounts of data via network <https://hjmangalam.wordpress.com/2009/09/14/how-to-transfer-large-amounts-of-data-via-network/>`_.  This tells you *all* you want to know about transferring data.

Data Transfer via SSH
~~~~~~~~~~~~~~~~~~~~~

The easiest way of transferring data to/from Cirrus is to use one of
the standard programs based on the SSH protocol such as ``scp``,
``sftp`` or ``rsync``. These all use the same underlying mechanism (ssh)
as you normally use to login to Cirrus. So, once the command has
been executed via the command line, you will be prompted for your
password for the specified account on the **remote machine**.

To avoid having to type in your password multiple times you can set up a
*ssh-key* as documented in the User Guide at :doc:`connecting`

SSH Transfer Performance Considerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ssh protocol encrypts all traffic it sends. This means that
file-transfer using ssh consumes a relatively large amount of CPU time
at both ends of the transfer. The encryption algorithm used is negotiated
between the ssh-client and the ssh-server. There are command
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

* Only transfer those files that are required. Consider which data you
  really need to keep.
* Combine lots of small files into a single *tar* archive, to reduce the
  overheads associated in initiating many separate data transfers (over
  SSH each file counts as an individual transfer).
* Compress data before sending it, e.g. using gzip.

scp command
~~~~~~~~~~~

The ``scp`` command creates a copy of a file, or if given the ``-r``
flag, a directory, on a remote machine.

 
For example, to transfer files to Cirrus:

::

    scp [options] source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)

In the above example, the ``[destination]`` is optional, as when left
out ``scp`` will simply copy the source into the user's home directory. Also
the ``source`` should be the absolute path of the file/directory being
copied or the command should be executed in the directory containing the
source file/directory.

If you want to request a different encryption algorithm add the ``-c
[algorithm-name]`` flag to the ``scp`` options. For example, to use the
(usually faster) *arcfour* encryption algorithm you would use:

::

    scp [options] -c arcfour source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)

rsync command
~~~~~~~~~~~~~

The ``rsync`` command can also transfer data between hosts using a
``ssh`` connection. It creates a copy of a file or, if given the ``-r``
flag, a directory at the given destination, similar to ``scp`` above.

Given the ``-a`` option rsync can also make exact copies (including
permissions), this is referred to as *mirroring*. In this case the
``rsync`` command is executed with ssh to create the copy on a remote
machine.

To transfer files to Cirrus using ``rsync`` the command should have the form:

::

    rsync [options] -e ssh source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)

In the above example, the ``[destination]`` is optional, as when left
out ``rsync`` will simply copy the source into the users home directory.
Also the ``source`` should be the absolute path of the file/directory
being copied or the command should be executed in the directory
containing the source file/directory.

Additional flags can be specified for the underlying ``ssh`` command by
using a quoted string as the argument of the ``-e`` flag. e.g.

::

    rsync [options] -e "ssh -c arcfour" source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)
