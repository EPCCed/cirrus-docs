# Data migration to Cirrus EX4000

## /home and /work file systems

The same file systems that provided /home and /work on the old Cirrus system
will be mounted on Cirrus EX4000 in the same locations. This means that when you
log onto Cirrus EX4000, you will find all the data that you had on Cirrus available
in the same locations.

!!! important
    The data available will include any compiled applications and libraries that you
    built or installed on the old Cirrus system. These binaries will almost certainly
    not work on Cirrus EX4000 and you should expect and plan to rebuild, re-install and
    test your applications on Cirrus EX4000.

## Solid state /scratch (RPOOL) file system

The solid state /scratch file system on old Cirrus **will not** be available on 
Cirrus EX4000 and there will be no way to retrieve data from it once old Cirrus 
has ended. You should move any data you wish to keep on this file system to an
alternative location before the end of the current Cirrus system.

