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

   #!/bin/bash
   #
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=pw_test
   #SBATCH --nodes=4
   #SBATCH --tasks-per-node=36
   #SBATCH --time=0:20:0
   # Make sure you are not sharing nodes with other users
   #SBATCH --exclusive

   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]
   
   # Load QE and MPI modules
   module load quantum-espresso

   # Run using input in test_calc.in
   srun pw.x -i test_cals.in
