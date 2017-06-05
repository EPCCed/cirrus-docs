LAMMPS
=======

`LAMMPS <http://lammps.sandia.gov/>`_, is a classical molecular dynamics code, and an
acronym for Large-scale Atomic/Molecular Massively Parallel Simulator. LAMMPS has
potentials for solid-state materials (metals, semiconductors) and soft matter
(biomolecules, polymers) and coarse-grained or mesoscopic systems. It can be used
to model atoms or, more generically, as a parallel particle simulator at the atomic,
meso, or continuum scale.

Useful Links
------------

* `LAMMPS User Guide <http://www.ks.uiuc.edu/Research/namd/2.12/ug/>`__
* `LAMMPS Tutorials <http://www.ks.uiuc.edu/Training/Tutorials/index-all.html#namd>`__

Using LAMMPS on Cirrus
----------------------

LAMMPS is freely available to all Cirrus users.

Running parallel LAMMPS jobs
----------------------------

LAMMPS can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a LAMMPS MD job using 4 nodes
(144 cores) with pure MPI.

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N lammps_test
   #PBS -l select=4:ncpus=72
   # Make sure you are not sharing nodes with other users
   #PBS -l place=excl
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load LAMMPS module
   module load lammps

   # Run using input in in.test
   # Note: '-ppn 36' is required to use all physical cores across
   # nodes as hyperthreading is enabled by default
   mpiexec_mpt -n 144 -ppn 36 lmp_mpi < in.test

Compiling LAMMPS on Cirrus
--------------------------

Compile instructions for LAMMPS on Cirrus can be found on GitHub:

* `Cirrus LAMMPS compile instructions <https://github.com/EPCCed/cirrus-packages/tree/master/LAMMPS>`_
