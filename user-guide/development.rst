Application Development Environment
===================================

The application development environment on Cirrus is primarily
controlled through the *modules* environment. By loading and switching
modules you control the compilers, libraries and software available.

This means that for compiling on Cirrus you typically load all the
required library modules (e.g. numerical libraries, IO format libraries)
and compile your code using the compiler wrapper script (described in
detail below). The combination of the modules environment and the
wrapper scripts ensures that all the correct headers and library files
are included for you.

By default, all users on Cirrus start with no environments loaded.

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

    user@system:~> module avail intel-compilers-16
    ...

If you want more info on any of the modules, you can use the
``module help`` command:

::

    user@system:~> module help mpt
    ...

The simple ``module list`` command will give the names of the modules
and their versions you have presently loaded

::

    user@system:~> module list           
    ...

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

Suppose you have loaded version 3.3.0.1, say, of FFTW, the following command will change to version 2.1.5.2:

::

    module swap fftw fftw/16.0.2.181

This swapping mechanism is often used to select a diffent compiler suite from the default on the system.


Compiling MPI codes
-------------------

To compile MPI code you must load the "mpt" and "intel-compilers-16"
modules

``module load mpt``

``module load intel-compilers-16/16.0.3.210``

Compilers are then available as mpif90, mpicc and mpiCC for Fortran with
MPI, C with MPI, and C++ with MPI, respectively

NB take care as there are a number of compilers available. If you load
the intel compilers module but not the mpt module then mpif90 and mpicc
will use the GNU compilers rather than the Intel compilers to build your
program.

You need to load both modules to get the Intel compilers when calling
mpif90 or mpicc. This works differently for C and Fortran: for Fortran,
mpif90 will automatically call ifort after you have loaded
intel-compilers-16; for C, you need to specify icc explicitly using the
syntax "mpicc -cc=icc ..." (but you still have to load
intel-compilers-16 so mpicc will find icc).

If in doubt use mpif90 -v or mpicc [-cc=icc] -v to see what compiler is
actually being called.

The manual pages for the different compiler suites are available once
the programming environment has been switched in and are:

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

When you have a code that you are happy is working correctly and has
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
executable file). cd This may be because static versions of
certain libraries are unavailable, or to reduce the amount of memory
executables take by sharing common sections of object codes between
applications which use the same library. 

This has the advantage
that once an executable is created, whenever it is run in the future, it
will always use the same object code and thus give the same results from
the same input. However, executables compiled with static libraries have
the potential disadvantage that when multiple instances are running
simultaneously multiple copies of the libraries used are held in memory.
This can lead to large amounts of memory being used to hold the
executable and not application data.

To create an application that uses static libraries you must
pass an extra flag during compilation, ``-static``, or set an 
environment variable. 



Use the UNIX command ``ldd exe_file`` to check whether you are using an
executable that depends on shared libraries. This utility will also
report the shared libraries this executable will use with the current
value of ``LD_LIBRARY_PATH``.
