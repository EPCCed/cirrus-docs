# Software environment

The software environment on Cirrus is managed using the 
[Lmod](https://lmod.readthedocs.io/) software. Selecting which software
is available in your environment is primarily controlled through the
`module` command. By loading and switching software modules you control
which software and versions are available to you.

!!! information
    A module is a self-contained description of a software package -- it
    contains the settings required to run a software package and, usually,
    encodes required dependencies on other software packages.

All users on Cirrus start with the default software
environment loaded.

Software modules on Cirrus are provided by both HPE (usually known
as the *HPE Cray Programming Environment, CPE*) and by EPCC, who provide the
Service Provision, and Computational Science and Engineering services.

In this section, we provide:

   - A brief overview of the `module` command
   - A brief description of how the `module` command manipulates your
     environment

## Using the `module` command

We only cover basic usage of the Lmod `module` command here. For full
documentation please see the [Lmod documentation](https://lmod.readthedocs.io/en/latest/010_user.html)

The `module` command takes a subcommand to indicate what operation you
wish to perform. Common subcommands are:

   - `module restore` - Restore the default module setup (i.e. as if you had logged
     out and back in again)
   - `module list [name]` - List modules currently loaded in your
     environment, optionally filtered by `[name]`
   - `module avail [name]` - List modules available, optionally
     filtered by `[name]`
   - `module spider [name][/version]` - Search available modules (including hidden
      modules) and provide information on modules
   - `module load name` - Load the module called `name` into your
     environment
   - `module remove name` - Remove the module called `name` from your
     environment
   - `module help name` - Show help information on module `name`
   - `module show name` - List what module `name` actually does to your
     environment

These are described in more detail below.

!!! tip
    Lmod allows you to use the `ml` shortcut command. Without any arguments, `ml`
    behaves like `module list`; when a module name is specified to `ml`,
    `ml` behaves like `module load`.

!!! note
    You will often have to include `module` commands in any job submission
    scripts to setup the software to use in your jobs. Generally, if you
    load modules in interactive sessions, these loaded modules do not
    carry over into any job submission scripts.

!!! important
    You should not use the `module purge` command on Cirrus as this will
    cause issues for the HPE Cray programming environment. If you wish to 
    reset your modules, you should use the `module restore` command
    instead.

### Information on the available modules

The key commands for getting information on modules are covered in more
detail below. They are:

 - `module list`
 - `module avail`
 - `module spider`
 - `module help`
 - `module show`

#### `module list`

The `module list` command will give the names of the modules and their
versions you have presently loaded in your environment:

```
auser@login03:~> module list

Currently Loaded Modules:
  1) craype-x86-turin                  6) cce/19.0.0         11) cray-libsci/25.03.0
  2) libfabric/1.22.0                  7) cse_env/0.2        12) PrgEnv-cray/8.6.0
  3) craype-network-ofi                8) craype/2.7.34      13) epcc-setup-env
  4) perftools-base/25.03.0            9) cray-dsmml/0.3.1   14) load-epcc-module
  5) xpmem/0.2.119-1.3_gef379be13330  10) cray-mpich/8.1.32

```

All users start with a default set of modules loaded corresponding to:

 - The HPE Cray Compiling Environment (CCE): includes the HPE Cray clang and Fortran compilers
 - HPE Cray MPICH: The HPE Cray MPI library
 - HPE Cray LibSci: The HPE Cray numerical libraries (including BLAS/LAPACK and ScaLAPACK)


#### `module avail`

Finding out which software modules are currently available to load on the system is
performed using the `module avail` command. To list all software modules
currently available to load, use:

```
auser@login01:~> module avail

---- /work/y07/shared/cirrus-ex/cirrus-ex-lmod/apps/mpi/crayclang/16.0/ofi/1.0/x86-turin/1.0/cray-mpich/8.0 ----
   xthi/1.0

---- /work/y07/shared/cirrus-ex/cirrus-ex-software/spack-cirrus-ex/0.2/cirrus-ex-cse/modules/cce/19.0.0 ----
   eigen/3.4.0    lammps/20250612    metis/5.1.0    parmetis/4.0.3    petsc/3.23.4

---------------- /opt/cray/pe/lmod/modulefiles/mpi/crayclang/16.0/ofi/1.0/cray-mpich/8.0 ----------------
   cray-hdf5-parallel/1.14.3.5    cray-mpixlate/1.0.7    cray-parallel-netcdf/1.12.3.17

----- /work/y07/shared/cirrus-ex/cirrus-ex-software/spack-cirrus-ex/0.2/cirrus-ex-cse/modules/Core ------
   castep/24.1    likwid/5.4.1       openfoam/2412     python-venv/1.0
   cp2k/2025.1    openfoam-org/12    py-torch/2.7.1    python/3.11.7

-------------------------- /work/y07/shared/cirrus-ex/cirrus-ex-lmod/apps/core --------------------------
   vasp/6/6.5.1

------------------------- /work/y07/shared/cirrus-ex/cirrus-ex-lmod/utils/core --------------------------
   cmake/4.1.2    cse_env/0.2      (L,D)    epcc-setup-env (L)    spack/1.0.2/0.1
   cse_env/0.1    epcc-reframe/0.5          reframe/4.8.4         spack/1.0.2/0.2 (D)

---------------------- /opt/cray/pe/lmod/modulefiles/comnet/crayclang/16.0/ofi/1.0 ----------------------
   cray-mpich-abi/8.1.32    cray-mpich-abi/9.0.0 (D)    cray-mpich/8.1.32 (L)    cray-mpich/9.0.0 (D)

------------------------- /opt/cray/pe/lmod/modulefiles/compiler/crayclang/16.0 -------------------------
   cray-hdf5/1.14.3.5    cray-libsci/25.03.0 (L)

------------------------------ /opt/cray/pe/lmod/modulefiles/mix_compilers ------------------------------
   aocc-mixed/5.0.0    gcc-native-mixed/12.2    gcc-native-mixed/14.2 (D)    intel-oneapi-mixed/2025.0
   cce-mixed/19.0.0    gcc-native-mixed/13.3    intel-mixed/2025.0

---------------------------- /opt/cray/pe/lmod/modulefiles/perftools/25.03.0 ----------------------------
   perftools-lite-events    perftools-lite-hbm      perftools-lite       perftools
   perftools-lite-gpu       perftools-lite-loops    perftools-preload

------------------------------- /opt/cray/pe/lmod/modulefiles/net/ofi/1.0 -------------------------------
   cray-openshmemx/11.7.4

---------------------------- /opt/cray/pe/lmod/modulefiles/cpu/x86-turin/1.0 ----------------------------
   cray-fftw/3.3.10.10



...output trimmed...

```

This will list all the names and versions of the modules that you can currently
load. Note that other modules may be defined but not available to you as they depend
on modules you do not have loaded. Lmod only shows modules that you can currently
load, not all those that are defined. You can search for modules
that are not currently visble to you using the `module spider` command - we 
cover this in more detail below.

Note also, that not all modules may work in your account though due to, for
example, licencing restrictions. You will notice that for many modules
we have more than one version, each of which is identified by a version
number. One of these versions is the default. As the service develops
the default version will change and old versions of software may be
deleted.

You can list all the modules of a particular type by providing an
argument to the `module avail` command. For example, to list all
available versions of the HPE Cray FFTW library, use:

```
auser@login03:~>  module avail cray-fftw

------------------------------- /opt/cray/pe/lmod/modulefiles/cpu/x86-turin/1.0 --------------------------------
   cray-fftw/3.3.10.10

Module defaults are chosen based on Find First Rules due to Name/Version/Version modules found in the module tree.
See https://lmod.readthedocs.io/en/latest/060_locating.html for details.

If the avail list is too long consider trying:

"module --default avail" or "ml -d av" to just list the default modules.
"module overview" or "ml ov" to display the number of modules for each name.

Use "module spider" to find all possible modules and extensions.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".

```

#### `module spider`

The `module spider` command is used to find out which modules are defined on
the system. Unlike `module avail`, this includes modules that are not currently
able to be loaded due to the fact you have not yet loaded dependencies to make
them directly available.

`module spider` takes 3 forms:

 - `module spider` without any arguments lists all modules defined on the system
 - `module spider <module>` shows information on which versions of `<module>` are
   defined on the system
 - `module spider <module>/<version>` shows information on the specific version of 
   the module defined on the system, including dependencies that must be loaded 
   before this module can be loaded (if any)

If you cannot find a module that you expect to be on the system using `module avail`
then you can use `module spider` to find out which dependencies you need to load
to make the module available.

For example, the module `cray-netcdf-hdf5parallel` is installed on Cirrus but it
will not be found by `module avail`:

```
auser@login03:~> module avail cray-netcdf-hdf5parallel
No module(s) or extension(s) found!
Use "module spider" to find all possible modules and extensions.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".
```

We can use `module spider` without any arguments to verify it exists and list
the versions available:

```
auser@login03:~> module spider

-------------------------------------------------------------------------------------------------------------
The following is a list of the modules and extensions currently available:
-------------------------------------------------------------------------------------------------------------
  PrgEnv-aocc: PrgEnv-aocc/8.6.0

  PrgEnv-cray: PrgEnv-cray/8.6.0

  PrgEnv-gnu: PrgEnv-gnu/8.6.0

  PrgEnv-intel: PrgEnv-intel/8.6.0

  aocc: aocc/5.0.0

  aocc-mixed: aocc-mixed/5.0.0

  atp: atp/3.15.6

  castep: castep/24.1

  cce: cce/19.0.0

  cce-mixed: cce-mixed/19.0.0

  cmake: cmake/4.1.2


...output trimmed...

```

Now we know which versions are available, we can use
`module spider cray-netcdf-hdf5parallel/4.9.0.1` to find out how we can make
it available:

```
auser@login03:~> module spider libxc/7.0.0

-------------------------------------------------------------------------------------------------------------
  libxc: libxc/7.0.0
-------------------------------------------------------------------------------------------------------------

    You will need to load all module(s) on any one of the lines below before the "libxc/7.0.0" module is available to load.

      gcc-native/12.2
      gcc-native/13.3
      gcc-native/14.2
      load-epcc-module  cse_env/0.2  gcc-spack/14.2-db4a2iu
 
    Help:
      Libxc is a library of exchange-correlation functionals for density-
      functional theory.




```

There is a lot of information here, but what the output is essentailly telling
us is that in order to have `libxc/7.0.0` available to 
load we need to have loaded a compiler (any version of GCC) and some utility
modules that are already loaded for all users.
We can satisfy all of the
dependencies by loading `PrgEnv-gnu` (to load a `gcc-native` module), and then we can use
`module avail libxc` again to show that the module is now
available to load:

```
[auser@login03:~] module load PrgEnv-gnu

Lmod is automatically replacing "cce/19.0.0" with "gcc-native/14.2".


Lmod is automatically replacing "PrgEnv-cray/8.6.0" with "PrgEnv-gnu/8.6.0".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-libsci/25.03.0     2) cray-mpich/8.1.32

[auser@login03 ~]$ module avail libxc

------- /work/y07/shared/cirrus-ex/cirrus-ex-software/spack-cirrus-ex/0.2/cirrus-ex-cse/modules/gcc/14.2 -------
   libxc/7.0.0

Module defaults are chosen based on Find First Rules due to Name/Version/Version modules found in the module tree.
See https://lmod.readthedocs.io/en/latest/060_locating.html for details.

If the avail list is too long consider trying:

"module --default avail" or "ml -d av" to just list the default modules.
"module overview" or "ml ov" to display the number of modules for each name.

Use "module spider" to find all possible modules and extensions.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys"

```

#### `module help`

If you want more info on any of the modules, you can use the `module
help` command:

```
[auser@login03:~] module help gromacs


```

#### `module show`

The `module show` command reveals what operations the module actually
performs to change your environment when it is loaded. For example, for
the default FFTW module:

```
[auser@login03:~] module show gromacs

  [...]
```

### Loading, removing and swapping modules

To change your environment and make different software available you use the
following commands which we cover in more detail below.

 - `module load`
 - `module remove`

#### `module load`

To load a module to use the `module load` command. For example, to load
the default version of GROMACS into your environment, use:

```
[auser@login03:~] module load gromacs
```

Once you have done this, your environment will be setup to use GROMACS.
The above command will load the default version of GROMACS. If you need
a specific version of the software, you can add more information:

```
[auser@login01:~] module load gromacs/2022.4 
```

will load GROMACS version 2022.4 into your environment,
regardless of the default.

In Lmod, the `module load` command will swap a current loaded module for
the one specified in the command if there is a conflict.

#### `module remove`

If you want to remove software from your environment, `module remove`
will remove a loaded module:

```
[auser@uan01:~] module remove gromacs
```

will unload what ever version of `gromacs` you might have loaded (even
if it is not the default).


## Shell environment overview

When you log in to Cirrus, you are using the *bash* shell by default.
As with any software, the *bash* shell has loaded a set of environment
variables that can be listed by executing `printenv` or `export`.

The environment variables listed before are useful to define the
behaviour of the software you run. For instance, `OMP_NUM_THREADS`
define the number of threads.

To define an environment variable, you need to execute:

```
export OMP_NUM_THREADS=4
```

Please note there are no blanks between the variable name, the
assignation symbol, and the value. If the value is a string, enclose the
string in double quotation marks.

You can show the value of a specific environment variable if you print
it:

```
echo $OMP_NUM_THREADS
```

Do not forget the dollar symbol. To remove an environment variable, just
execute:

```
unset OMP_NUM_THREADS
```

Note that the dollar symbol is not included when you use the `unset` command.

## cgroup control of login resources

Note that it not possible for a single user to  monopolise the resources on
a login node as this is controlled by cgroups. This means that a user cannot
usually slow down the response time for other users.
