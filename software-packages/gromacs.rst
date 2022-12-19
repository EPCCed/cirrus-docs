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

For example, the following script will run a GROMACS MD job using 2 nodes
(72 cores) with pure MPI.

::

   #!/bin/bash --login
   
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=gmx_test
   #SBATCH --nodes=2
   #SBATCH --tasks-per-node=36
   #SBATCH --time=0:25:0
   # Make sure you are not sharing nodes with other users
   #SBATCH --exclusive
   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]
   
   # Load GROMACS module
   module load gromacs

   # Run using input in test_calc.tpr
   export OMP_NUM_THREADS=1 
   srun gmx_mpi mdrun -s test_calc.tpr

Running parallel GROMACS jobs: hybrid MPI/OpenMP
------------------------------------------------

The following script will run a GROMACS MD job using 2 nodes
(72 cores) with 6 MPI processes per node (12 MPI processes in
total) and 6 OpenMP threads per MPI process.

::

   #!/bin/bash --login
   
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=gmx_test
   #SBATCH --nodes=2
   #SBATCH --tasks-per-node=6
   #SBATCH --cpus-per-task=6
   #SBATCH --time=0:25:0
   # Make sure you are not sharing nodes with other users
   #SBATCH --exclusive
   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]
   
   # Load GROMACS and MPI modules
   module load gromacs

   # Run using input in test_calc.tpr
   export OMP_NUM_THREADS=6
   srun gmx_mpi mdrun -s test_calc.tpr

GROMACS GPU jobs
----------------
The following script will run a GROMACS GPU MD job using 1 node
(40 cores and 4 GPUs). The job is set up to run on `<MPI task count>`
MPI processes, and `<OMP thread count>` OMP threads -- you will need
to change these variables when running your script.

.. note::
   Unlike the base version of GROMACS, the GPU version comes with 
   only MDRUN installed. For any pre- and post-processing, you will 
   need to use the non-GPU version of GROMACS.

::

   #!/bin/bash --login
   
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=gmx_test
   #SBATCH --nodes=1
   #SBATCH --time=0:25:0
   #SBATCH --exclusive
   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]
   #SBATCH --gres=gpu:4
   
   # Load GROMACS and MPI modules
   module load gromacs/2022.1-gpu

   # Run using input in test_calc.tpr
   export OMP_NUM_THREADS=<OMP thread count>
   srun --ntasks=<MPI task count> --cpus-per-task=<OMP thread count> \
        gmx_mpi mdrun -ntomp <OMP thread count> -s test_calc.tpr

Information on how to assign different types of calculation to the
CPU or GPU appears in the GROMACS documentation under
`Getting good performance from mdrun
<http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html>`__

