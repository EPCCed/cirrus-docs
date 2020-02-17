GROMACS
=======

`GROMACS <http://www.gromacs.org/>`__ GROMACS is a versatile package to
perform molecular dynamics, i.e. simulate the Newtonian equations of
motion for systems with hundreds to millions of particles.  It is
primarily designed for biochemical molecules like proteins, lipids
and nucleic acids that have a lot of complicated bonded interactions,
but since GROMACS is extremely fast at calculating the nonbonded
interactions (that usually dominate simulations) many groups are
also using it for research on non-biological systems, e.g. polymers.

Useful Links
------------

* `GROMACS User Guides <http://manual.gromacs.org/documentation/>`__
* `GROMACS Tutorials <http://www.gromacs.org/Documentation/Tutorials>`__

Using GROMACS on Cirrus
-----------------------

GROMACS is Open Source software and is freely available to all Cirrus users.
A number of versions are available:

* Serial/shared memory, single precision: gmx
* Parallel MPI/OpenMP, single precision: gmx_mpi
* GPU version, single precision: gmx

Running parallel GROMACS jobs: pure MPI
---------------------------------------

GROMACS can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a GROMACS MD job using 4 nodes
(144 cores) with pure MPI.

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N mdrun_test
   #PBS -l select=4:ncpus=36
   # Make sure you are not sharing nodes with other users
   #PBS -l place=scatter:excl
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load GROMACS and MPI modules
   module load gromacs
   module load mpt

   # Run using input in test_calc.tpr
   # Note: '-ppn 36' is required to use all physical cores across
   # nodes as hyperthreading is enabled by default
   OMP_NUM_THREADS=1 
   mpiexec_mpt -ppn 36 -n 144 gmx_mpi mdrun -s test_calc.tpr

Running parallel GROMACS jobs: hybrid MPI/OpenMP
------------------------------------------------

The following script will run a GROMACS MD job using 4 nodes
(144 cores) with 6 MPI processes per node (24 MPI processes in
total) and 6 OpenMP threads per MPI process.

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N mdrun_test
   #PBS -l select=4:ncpus=36
   # Make sure you are not sharing nodes with other users
   #PBS -l place=scatter:excl
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load GROMACS and MPI modules
   module load gromacs
   module load mpt

   # Run using input in test_calc.tpr
   export OMP_NUM_THREADS=6
   mpiexec_mpt -ppn 6 -n 24 omplace -nt 6 gmx_mpi mdrun -s test_calc.tpr


GROMACS GPU jobs
----------------

A separate build of GROMACS is provided to run on the NVIDIA GPU nodes
on Cirrus (for details see :doc:`../user-guide/gpu`). Note also that
the GPU version targets the GPU host nodes, which are Intel Skylake;
this version will not run on the front end or the other non-GPU back-end nodes.

The GPU version is accessed via, e.g.,

::

   module load gromacs-gpu/2020



As there are currently a limited number of GPU nodes available, a
distributed memory MPI version is not available: only the 'thread MPI'
version is available (that is, 'gmx' is available, but not 'gmx_mpi').

Further, we recommend exclusive node usage to prevent possible contention
with other user jobs. An example of the form of the PBS submission script is:


::

   #!/bin/bash --login

   #PBS -q gpu   
   #PBS -N job-name
   #PBS -l select=1:ncpus=40:ngpus=4
   #PBS -l place=scatter:excl
   #PBS -l walltime=00:20:00
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load GROMACS GPU module

   module load gromacs-gpu/2020

   # Invocation will depend on problem type ...

   export OMP_NUM_THREADS=10
   gmx mdrun -ntmpi 4 -nb gpu -pme cpu ...


Information on how to assign different types of calculation to the
CPU or GPU appears in the GROMACS documentation under
`Getting good performance from mdrun
<http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html>`__

