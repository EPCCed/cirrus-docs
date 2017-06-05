NAMD
====

`NAMD <http://www.ks.uiuc.edu/Research/namd/>`_, recipient of a 2002 Gordon Bell Award and a
2012 Sidney Fernbach Award, is a parallel molecular dynamics code designed for
high-performance simulation of large biomolecular systems. Based on Charm++
parallel objects, NAMD scales to hundreds of cores for typical simulations
and beyond 500,000 cores for the largest simulations. NAMD uses the popular
molecular graphics program VMD for simulation setup and trajectory analysis,
but is also file-compatible with AMBER, CHARMM, and X-PLOR. 

Useful Links
------------

* `NAMD User Guide <http://www.ks.uiuc.edu/Research/namd/2.12/ug/>`__
* `NAMD Tutorials <http://www.ks.uiuc.edu/Training/Tutorials/index-all.html#namd>`__

Using NAMD on Cirrus
--------------------

NAMD is freely available to all Cirrus users.

Running parallel NAMD jobs
--------------------------

NAMD can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a NAMD MD job using 4 nodes
(144 cores) with pure MPI.

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N namd_test
   #PBS -l select=4:ncpus=72
   # Make sure you are not sharing nodes with other users
   #PBS -l place=excl
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load NAMD module
   module load namd

   # Run using input in input.namd
   # Note: '-ppn 36' is required to use all physical cores across
   # nodes as hyperthreading is enabled by default
   # Note: NAMD uses Intel MPI so mpirun should be used instead of
   # mpiexec_mpt (which is SGI MPI)
   mpirun -n 144 -ppn 36 namd2 input.namd

