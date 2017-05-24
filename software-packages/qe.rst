Quantum Espresso (QE)
=====================

`Quantum Espresso <http://www.quantum-espresso.org/>`__ is an integrated suite of
Open-Source computer codes for electronic-structure calculations and materials
modeling at the nanoscale. It is based on density-functional theory, plane waves,
and pseudopotentials.

Useful Links
------------

* `QE User Guides <http://www.quantum-espresso.org/users-manual/>`__
* `QE Tutorials <http://www.quantum-espresso.org/tutorials/>`__

Using QE on Cirrus
------------------

QE is Open Source software and is freely available to all Cirrus users.

Running parallel QE jobs
------------------------

QE can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a QE pw.x job using 4 nodes
(144 cores).

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N pw_test
   #PBS -l select=4:ncpus=72
   # Make sure you are not sharing nodes with other users
   #PBS -l place=excl
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load QE and MPI modules
   module load qe
   module load mpt

   # Run using input in test_calc.in
   # Note: '-ppn 36' is required to use all physical cores across
   # nodes as hyperthreading is enabled by default
   mpiexec_mpt -n 144 -ppn 36 pw.x test_calc.in

