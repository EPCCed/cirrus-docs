Data Transfer Guide
===================

-  `Using scp <#Cirrus_scp>`__
-  `Using rsync <#Cirrus_rsync>`__



scp command
-----------

The ``scp`` command creates a copy of a file, or if given the ``-r``
flag a directory, on a remote machine. Below shows an example of the
command to transfer files to Cirrus:

::

    scp [options] source user@cirrus.epcc.ed.ac.uk:[destination]

In the above example, the ``[destination]`` is optional, as when left
out rsync will simply copy the source into the users home directory.
Also the 'source' should be the absolute path of the file/directory
being copied or the command should be executed in the directory
containing the source file/directory.

rsync command
-------------

The ``rsync`` command creates a copy of a file, or if given the ``-r``
flag a directory, at the given destination, similar to scp above.
However, given the -a option rsync can also make exact copies (including
permissions), this is referred to as 'mirroring'. In this case the
``rsync`` command is executed with ssh to create the copy of a remote
machine. To transfer files to Cirrus the command should have the form:

::

    rsync [options] -e ssh source user@cirrus.epcc.ed.ac.uk:[destination]

In the above example, the ``[destination]`` is optional, as when left
out rsync will simply copy the source into the users home directory.
Also the 'source' should be the absolute path of the file/directory
being copied or the command should be executed in the directory
containing the source file/directory.
