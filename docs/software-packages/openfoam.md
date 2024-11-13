# OpenFOAM

OpenFOAM is an open-source toolbox for computational fluid dynamics.
OpenFOAM consists of generic tools to simulate complex physics for a
variety of fields of interest, from fluid flows involving chemical
reactions, turbulence and heat transfer, to solid dynamics,
electromagnetism and the pricing of financial options.

The core technology of OpenFOAM is a flexible set of modules written in
C++. These are used to build solvers and utilities to perform pre- and
post-processing tasks ranging from simple data manipulation to
visualisation and mesh processing.

## Available Versions

OpenFOAM comes in a number of different flavours. The two main releases
are from <https://openfoam.org/> and from <https://www.openfoam.com/>.

You can query the versions of OpenFOAM are currently available on Cirrus
from the command line with `module avail openfoam`.

Versions from <https://openfoam.org/> are typically `v8` etc, while
versions from <https://www.openfoam.com/> are typically `v2006`
(released June 2020).

## Useful Links

- [OpenFOAM Documentation](https://www.openfoam.com/documentation/)

## Using OpenFOAM on Cirrus

Any batch script which intends to use OpenFOAM should first load the
appropriate `openfoam` module. You then need to source the `etc/bashrc`
file provided by OpenFOAM to set all the relevant environment variables.
The relevant command is printed to screen when the module is loaded. For
example, for OpenFOAM v8:

    module add openfoam/v8.0
    source ${FOAM_INSTALL_PATH}/etc/bashrc

You should then be able to use OpenFOAM in the usual way.

### Extensions to OpenFOAM

Many packages extend the central OpenFOAM functionality in some way. However,
there is no completely standardised way in which this works. Some packages
assume they have write access to the main OpenFOAM installation. If this is
the case, you must install your own version before continuing. This
can be done on an individual basis, or a per-project basis using the
[project shared directories](https://docs.cirrus.ac.uk/user-guide/resource_management/#sharing-data-with-cirrus-users-in-your-project).

Some packages are installed in the OpenFOAM user directory, by default this is
set to `$HOME/OpenFOAM/$USER-[openfoam-version]`. This can be changed (e.g. to
the work filesystem) by adding `WM_PROJECT_USER_DIR=/work/a01/a01/auser/OpenFOAM/auser-[openfoam-version]`
as an argument to `source ${FOAM_INSTALL_DIR}/etc/bashrc`. For example:

```bash
source ${FOAM_INSTALL_DIR}/etc/bashrc WM_PROJECT_USER_DIR=/work/a01/a01/auser/OpenFOAM/auser-v2106
```

### Compiling OpenFOAM

If you want to compile your own version of OpenFOAM, instructions are
available for Cirrus at:

 - [Build instructions for OpenFOAM on GitHub](https://github.com/hpc-uk/build-instructions/tree/main/apps/OpenFOAM)

## Example Batch Submisison

The following example batch submission script would run OpenFOAM on two
nodes, with 36 MPI tasks per node.

    #!/bin/bash

    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=36
    #SBATCH --exclusive
    #SBATCH --time=00:10:00

    #SBATCH --partition=standard
    #SBATCH --qos=standard

    # Load the openfoam module and source the bashrc file

    module load openfoam/v8.0
    source ${FOAM_INSTALL_PATH}/etc/bashrc

    # Compose OpenFOAM work in the usual way, except that parallel
    # executables are launched via srun. For example:

    srun interFoam -parallel

A SLURM submission script would usually also contain an account token of
the form

    #SBATCH --account=your_account_here

where the <span class="title-ref">your_account_here</span> should be
replaced by the relevant token for your account. This is available from
SAFE with your budget details.
