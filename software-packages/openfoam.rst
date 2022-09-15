OpenFOAM
========

OpenFOAM is an open-source toolbox for computational fluid dynamics. OpenFOAM consists of generic tools to simulate complex physics for a variety of fields of interest, from fluid flows involving chemical reactions, turbulence and heat transfer, to solid dynamics, electromagnetism and the pricing of financial options.

The core technology of OpenFOAM is a flexible set of modules written in C++. These are used to build solvers and utilities to perform pre- and post-processing tasks ranging from simple data manipulation to visualisation and mesh processing.

Available Versions
------------------

OpenFOAM comes in a number of different flavours. The two main releases are
from https://openfoam.org/ and from https://www.openfoam.com/.

You can query the versions of OpenFOAM are currently available on Cirrus
from the command line with ``module avail openfoam``.

Versions from https://openfoam.org/ are typically ``v8`` etc, while
versions from  https://www.openfoam.com/ are typically ``v2006`` (released
June 2020).

Useful Links
------------

* `OpenFOAM Documentation <https://www.openfoam.com/documentation/>`_

Using OpenFOAM on Cirrus
------------------------

Any batch script which intends to use OpenFOAM should first load the
appropriate ``openfoam`` module. You then need to source the
``etc/bashrc`` file provided by OpenFOAM to set all the relevant
environment variables. The relevant command is printed to screen when
the module is loaded. For example, for OpenFOAM v8:

::

   module add openfoam/v8.0
   source ${FOAM_INSTALL_PATH}/etc/bashrc

You should then be able to use OpenFOAM in the usual way.

Example Batch Submisison
------------------------

The following example batch submission script would run OpenFOAM
on two nodes, with 36 MPI tasks per node.

::

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


A SLURM submission script would usually also contain an account token
of the form

::

  #SBATCH --account=your_account_here

where the `your_account_here` should be replaced by the relevant token
for your account. This is available from SAFE with your budget details.
