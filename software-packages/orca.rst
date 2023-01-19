ORCA
====

ORCA is an ab initio quantum chemistry program package that contains modern electronic structure methods including density functional theory, many-body perturbation, coupled cluster, multireference methods, and semi-empirical quantum chemistry methods. Its main field of application is larger molecules, transition metal complexes, and their spectroscopic properties. ORCA is developed in the research group of Frank Neese. The free version is available only for academic use at academic institutions.

Useful Links
------------

* `ORCA Forum <https://orcaforum.kofo.mpg.de/app.php/portal>`__

Using ORCA on Cirrus
--------------------

ORCA is available for academic use on ARCHER2 only. If you wish to use ORCA for commercial
applications, you must contact the ORCA developers.

ORCA cannot use GPUs.

Running parallel ORCA jobs
--------------------------

The following script will run an ORCA job on the Cirrus using 4 MPI processes on a single node,
each MPI process will be placed on a separate physical core. It assumes that the input file
is ``my_calc.inp``

::

   #!/bin/bash
   
   # job options (name, compute nodes, job time)
   #SBATCH --job-name=ORCA_test
   #SBATCH --nodes=1
   #SBATCH --tasks-per-node=4

   #SBATCH --time=0:20:0
   
   #SBATCH --account=[budget code]
   #SBATCH --partition=standard
   #SBATCH --qos=standard
   
   # Load ORCA module
   module load orca

   # Launch the ORCA calculation
   #   * You must use "$ORCADIR/orca" so the application has the full executable path
   #   * Do not use "srun" to launch parallel ORCA jobs as they use interal ORCA routines to launch in parallel
   #   * Remember to change the name of the input file to match your file name
   $ORCADIR/orca my_calc.inp

