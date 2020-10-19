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
   
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=NAMD_Example
   #SBATCH --time=1:0:0
   #SBATCH --exclusive
   #SBATCH --nodes=4
   #SBATCH --tasks-per-node=36
   #SBATCH --cpus-per-task=1

   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu-skylake)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]


   # Load NAMD module
   module load namd

   # Run using input in input.namd
   srun namd2 input.namd
   


