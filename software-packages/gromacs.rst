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
Four versions are available:

* Serial/shared memory, single precision: gmx
* Serial/shared memory, double precision: gmx_d
* Parallel MPI/OpenMP, single precision: gmx_mpi
* Parallel MPI/OpenMP, double precision: gmx_mpi_d

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
   #PBS -l select=4:ncpus=72
   # Make sure you are not sharing nodes with other users
   #PBS -l place=excl
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
   mpiexec_mpt -n 144 -ppn 36 gmx_mpi mdrun -s test_calc.tpr

Running parallel GROMACS jobs: hybrid MPI/OpenMP
------------------------------------------------

The following script will run a GROMACS MD job using 4 nodes
(144 cores) with 6 MPI processes per node (24 MPI processes in
total) and 6 OpenMP threads per MPI process.

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N mdrun_test
   #PBS -l select=4:ncpus=72
   # Make sure you are not sharing nodes with other users
   #PBS -l place=excl
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
   mpiexec_mpt -n 24 -ppn 6 omplace -nt 6 gmx_mpi mdrun -s test_calc.tpr
