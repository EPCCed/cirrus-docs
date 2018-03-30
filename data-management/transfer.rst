Transferring data from INDY to Cirrus
=====================================

This document outlines methods and tips for transferring data from
INDY to Cirrus for users who are migrating from the old INDY-linux
system to the new Cirrus system.

**Note:** This guide is not intended for users of the INDY-windows 
service. Different arrangements will be made for INDY Windows HPC 
users.

If you have any questions about transferring data from INDY-linux to
Cirrus then please `contact the helpdesk <mailto:support@cirrus.ac.uk>`_

Introduction
------------

As INDY-linux and Cirrus are both colocated at EPCC's ACF data
centre the most efficient way to transfer data between them is
directly using SSH. This will use the high-bandwidth data links
between the two systems at the ACF.

A two stange transfer process via your home site will generally
see worse performance than direct transfer. However, this
approach may be useful if you want to take a local, backup 
copy of your data during the move.

**Note:** Unlike INDY-linux, the Cirrus file systems are currently
not backed-up in any way so we strongly recommend that you take 
a copy of any critical data to a local resource before the end
of the INDY-linux service.

Minimum Requirements
--------------------

In order to transfer data from INDY-linux to Cirrus using a direct
copy over SSH you will need the following:

* Access to your account on INDY-linux
* An account on Cirrus with enough disk quota to hold the 
  data you are transferring
* A SSH client application that you can use to log into Cirrus or
  INDY-linux

Data Transfer via SSH
---------------------

The easiest way of transferring data to Cirrus from INDY-linux is to use one of
the standard programs based on the SSH protocol such as ``scp``,
``sftp`` or ``rsync``. These all use the same underlying mechanism (ssh)
as you normally use to log-in to Cirrus/INDY-linux. So, once the the command has
been executed via the command line, you will be prompted for your
password for the specified account on the **remote machine**.

To avoid having to type in your password multiple times you can set up a
*ssh-key* as documented in the User Guide at :doc:`../user-guide/connecting`

SSH Transfer Performance Considerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ssh command encrypts all traffic it sends. This means that
file-transfer using ssh consumes a relatively large amount of cpu time
at both ends of the transfer. The login nodes for Cirrus and INDY-linux have
fairly fast processors that can sustain about 100 MB/s transfer.
The encryption algorithm used is
negotiated between the ssh-client and the ssh-server. There are command
line flags that allow you to specify a preference for which encryption
algorithm should be used. You may be able to improve transfer speeds by
reqeusting a different algorithm than the default. The *arcfour*
algorithm is usually quite fast if both hosts support it.

A single ssh based transfer will usually not be able to saturate the
available network bandwidth or the available disk bandwidth so you may
see an overall improvement by running several data transfer operations
in parallel. To reduce metadata interactions it is a good idea to
overlap transfers of files from different directories.

In addition, you should consider the following when transferring data:

* Only transfer those files that are required. Consider which data you
  really need to keep.
* Combine lots of small files into a single tar file, to reduce the
  overheads associated in initiating many separate data transfers (over
  SSH each file counts as an individual transfer).
* Compress data before sending it, e.g. using gzip.

scp command
~~~~~~~~~~~

The ``scp`` command creates a copy of a file, or if given the ``-r``
flag a directory, on a remote machine.

 
For example, to transfer files from INDY-linux to Cirrus (assuming you are
logged into INDY-linux):

::

    scp [options] source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)

In the above example, the ``[destination]`` is optional, as when left
out scp will simply copy the source into the user's home directory. Also
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
flag, a directory at the given destination, similar to scp above.

Given the ``-a`` option rsync can also make exact copies (including
permissions), this is referred to as *mirroring*. In this case the
``rsync`` command is executed with ssh to create the copy on a remote
machine.

To transfer files to Cirrus from INDY-linux using ``rsync`` (assuming you are 
logged into INDY-linx) the command should have the form:

::

    rsync [options] -e ssh source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)

In the above example, the ``[destination]`` is optional, as when left
out rsync will simply copy the source into the users home directory.
Also the ``source`` should be the absolute path of the file/directory
being copied or the command should be executed in the directory
containing the source file/directory.

Additional flags can be specified for the underlying ``ssh`` command by
using a quoted string as the argument of the ``-e`` flag. e.g.

::

    rsync [options] -e "ssh -c arcfour" source user@login.cirrus.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)
