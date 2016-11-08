Application Development Environment
===================================

The application development environment on Cirrus is primarily
controlled through the *modules* environment. By loading and switching
modules you control the compilers, libraries and software available.

This means that for compiling on Cirrus you typically set the compiler
you wish to use using the appropriate modules, then load all the
required library modules (e.g. numerical libraries, IO format libraries).

Additionally, if you are compiling parallel applications using MPI 
(or SHMEM, etc.) then you will need to load the ``mpt`` module and
use the appropriate compiler wrapper scripts.

By default, all users on Cirrus start with no modules loaded.

Basic usage of the ``module`` command on Cirrus is covered below. For
full documentation please see:

-  `Linux manual page on modules <http://linux.die.net/man/1/module>`__

Information on the available modules
------------------------------------

Finding out which modules (and hence which compilers, libraries and
software) are available on the system is performed using the
``module avail`` command:

::

    user@system:~> module avail
    ...

This will list all the names and versions of the modules available on
the service. Not all of them will work in your account though due to,
for example, licencing restrictions. You will notice that for many
modules we have more than one version, each of which is identified by a
version number. One of these versions is the default. As the
service develops the default version will change.

You can list all the modules of a particular type by providing an
argument to the ``module avail`` command. For example, to list all
available versions of the Intel Compiler type:

::

    [user@cirrus-login0 ~]$ module avail intel-compilers
 
    --------------------------------------- /lustre/sw/modulefiles ---------------------------------------
    intel-compilers-16/16.0.2.181 intel-compilers-16/16.0.3.210

If you want more info on any of the modules, you can use the
``module help`` command:

::

    [user@cirrus-login0 ~]$ module help mpt

    ----------- Module Specific Help for 'mpt/2.14' -------------------

    The SGI Message Passing Toolkit (MPT) is an optimized MPI
    implementation for SGI systems and clusters.  See the
    MPI(1) man page and the MPT User's Guide for more
    information.

The simple ``module list`` command will give the names of the modules
and their versions you have presently loaded

::

    [user@cirrus-login0 ~]$ module list
    Currently Loaded Modulefiles:
    1) mpt/2.14                        3) intel-fc-16/16.0.3.210
    2) intel-cc-16/16.0.3.210          4) intel-compilers-16/16.0.3.210

Loading, unloading and swapping modules
---------------------------------------

To load a module to use ``module add`` or ``module load``. For example,
to load the intel-compilers-16 into the development environment:

::

    module load intel-compilers-16

This will load the default version of the intel commpilers Library. If
you need a specfic version of the module, you can add more information:

::

    module load intel-compilers-16/16.0.3.210

will load version 16.0.3.210 for you, regardless of the default. If you
want to clean up, ``module remove`` will remove a loaded module:

::

    module remove intel-compilers-16

(or ``module rm intel-compilers-16`` or
``module unload intel-compilers-16``) will unload what ever version of
intel-compilers-16 (even if it is not the default) you might have
loaded. There are many situations in which you might want to change the
presently loaded version to a different one, such as trying the latest
version which is not yet the default or using a legacy version to keep
compatibility with old data. This can be achieved most easily by using 
"module swap oldmodule newmodule". 

Suppose you have loaded version 16.0.2.181, say, of intel-compilers-16, the following command will change to version 16.0.3.210:

::

    module swap intel-compilers-16 intel-compilers-16/16.0.2.181


Compiling MPI codes
-------------------

To compile MPI code, using any compiler, you must first load the "mpt" module.

::

   module load mpt

This makes the compiler wrapper scripts ``mpicc`` and ``mpif90`` available
to you.

What you do next depends on which compiler (Intel or GCC) you wish to use to
compile your code.

**Note:** We recommend that you use the Intel compiler wherever possible to 
compile MPI applications as this is the method officially supported and
tested by SGI.

**Note:** You can always check which compiler the MPI compiler wrapper scripts
are using with ``mpicc -v`` or ``mpif90 -v``.

-  :download:`SGI MPT documentation </sgidocs/SGI_MPI_SHMEM_Guide_007-3773-029.pdf>`

Using Intel Compilers and MPI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once you have loaded the MPT module you should next load the appropriate 
``intel-compilers`` module (e.g. ``intel-compilers-16``):

::

    module load intel-compilers-16/16.0.3.210

Compilers are then available as mpif90, mpicc and mpiCC for Fortran with
MPI, C with MPI, and C++ with MPI, respectively.

**Note:** When compiling C/C++ applications you must also specify that 
``mpicc`` should use the ``icc`` compiler with ``mpicc -cc=icc``. (This
is not required for Fortran as the ``mpif90`` compiler automatically 
uses ``ifort``.  If in doubt use ``mpicc -cc=icc -v`` to see
which compiler is actually being called.

Using GCC Compilers and MPI
~~~~~~~~~~~~~~~~~~~~~~~~~~~

To use the GCC compilers with MPT you do not need to load any additional
modules.

**Note:** SGI MPT does not support the syntax ``use mpi`` in Fortran 
applications with the GCC compiler ``gfortran``. You should use the
older ``include "mpif.h"`` syntax when using GCC compilers with 
``mpif90``.

Compiler Information and Options
--------------------------------

The manual pages for the different compiler suites are available:

GCC
    Fortran ``man gfortran`` ,
    C/C++ ``man gcc``
Intel
    Fortran ``man ifort`` ,
    C/C++ ``man icc``

Useful compiler options
~~~~~~~~~~~~~~~~~~~~~~~

Whilst difference codes will benefit from compiler optimisations in
different ways, for reasonable performance on Cirrus, at least
initially, we suggest the following compiler options:

Intel
    ``-O2``
GNU
    ``-O2 -ftree-vectorize -funroll-loops -ffast-math``

When you have a application that you are happy is working correctly and has
reasonable performance you may wish to investigate some more aggressive
compiler optimisations. Below is a list of some further optimisations
that you can try on your application (Note: these optimisations may
result in incorrect output for programs that depend on an exact
implementation of IEEE or ISO rules/specifications for math functions):

Intel
    ``-fast``
GNU
    ``-Ofast -funroll-loops``

Vectorisation, which is one of the important compiler optimisations for
Cirrus, is enabled by default as follows:

Intel
    At ``-O2`` and above
GNU
    At ``-O3`` and above or when using ``-ftree-vectorize``

To promote integer and real variables from four to eight byte precision
for FORTRAN codes the following compiler flags can be used:

Intel
    ``-real-size 64 -integer-size 64 -xAVX``
    (Sometimes the Intel compiler incorrectly generates AVX2
    instructions if the ``-real-size 64`` or ``-r8`` options are set.
    Using the ``-xAVX`` option prevents this.)
GNU
    ``-freal-4-real-8 -finteger-4-integer-8``

Using static linking/libraries
-------------------------------

By default, executables on Cirrus are built using shared/dynamic libraries 
(that is, libraries which are loaded at run-time as and when
needed by the application) when using the wrapper scripts. 

An application compiled this way to use shared/dynamic libraries will
use the default version of the library installed on the system (just
like any other Linux executable), even if the system modules were set
differently at compile time. This means that the application may
potentially be using slightly different object code each time the
application runs as the defaults may change. This is usually the desired
behaviour for many applications as any fixes or improvements to the
default linked libraries are used without having to recompile the
application, however some users may feel this is not the desired
behaviour for their applications.

Alternatively, applications can be compiled to use static
libraries (i.e. all of the object code of referenced libraries are contained in the
executable file).  This has the advantage
that once an executable is created, whenever it is run in the future, it
will always use the same object code (within the limit of changing runtime 
environemnt). However, executables compiled with static libraries have
the potential disadvantage that when multiple instances are running
simultaneously multiple copies of the libraries used are held in memory.
This can lead to large amounts of memory being used to hold the
executable and not application data.

To create an application that uses static libraries you must
pass an extra flag during compilation, ``-Bstatic``.

Use the UNIX command ``ldd exe_file`` to check whether you are using an
executable that depends on shared libraries. This utility will also
report the shared libraries this executable will use if it has been
dynamically linked.
