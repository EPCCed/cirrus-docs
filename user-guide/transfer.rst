Data Transfer Guide
===================

This section covers the different ways that you can transfer data 
to and from Cirrus. In particular, we cover SSH-based methods, 
e.g., scp, sftp, rsync.

In all cases of data transfer, users should use the Cirrus login nodes.

Before you start
----------------

Read Harry Mangalam's guide on `How to transfer large amounts of data via network <https://hjmangalam.wordpress.com/2009/09/14/how-to-transfer-large-amounts-of-data-via-network/>`_.  This tells you *all* you want to know about transferring data.

Data Transfer via SSH
---------------------

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

    scp [options] source user@cirrus.epcc.ed.ac.uk:[destination]

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

    scp [options] -c arcfour source user@cirrus.epcc.ed.ac.uk:[destination]

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

    rsync [options] -e ssh source user@cirrus.epcc.ed.ac.uk:[destination]

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

    rsync [options] -e "ssh -c arcfour" source user@cirrus.epcc.ed.ac.uk:[destination]

(Remember to replace ``user`` with your Cirrus username in the example
above.)