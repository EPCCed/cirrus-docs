Gaussian
========

`Gaussian <http://www.gaussian.com/>`__ is a general-purpose computational
chemistry package.

Useful Links
------------

 * `Gaussian User Guides <http://gaussian.com/techsupport/>`__

Using Gaussian on Cirrus
------------------------

**Gaussian on Cirrus is only available to University of Edinburgh researchers
through the University's site licence. Users from other institutions cannot
access the version centrally-installed on Cirrus.**

If you wish to have access to Gaussian on Cirrus please contact the
`Cirrus Helpdesk <http://www.cirrus.ac.uk/support/>`__.

Gaussian cannot run across multiple nodes. This means that the maximum number
of cores you can use for Gaussian jobs is 36 (the number of cores on a compute
node). In reality, even large Gaussian jobs will not be able to make effective
use of more than 8 cores. You should explore the scaling and performance of your
calculations on the system before running production jobs.

Scratch Directories
-------------------

Before using Gaussian for the first time, you should create a directory in your
home directories to hold temporary files used by Gaussian, e.g.

::

   mkdir ~/g09tmp

Running serial Gaussian jobs
----------------------------

In many cases you will use Gaussian in serial mode. The following example script
will run a serial Gaussian job on Cirrus (before using, ensure you have created
a Gaussian scratch directory as outlined above).

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N G09_test
   #PBS -l select=1:ncpus=1
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load Gaussian module
   module load gaussian

   # Setup the Gaussian environment
   source $g09root/g09/bsd/g09.profile

   # Location of the scratch directory
   export GAUSS_SCRDIR=$HOME/g09tmp

   # Run using input in "test0027.com"
   g09 test0027
   
Running parallel Gaussian jobs
------------------------------

Gaussian on Cirrus can use shared memory parallelism through OpenMP by setting
the `OMP_NUM_THREADS` environment variable. The number of cores requested in the
job should also be modified to match.

For example, the following script will run a Gaussian job using 4 cores.

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N G09_test
   #PBS -l select=1:ncpus=4
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load Gaussian module
   module load gaussian

   # Setup the Gaussian environment
   source $g09root/g09/bsd/g09.profile

   # Location of the scratch directory
   export GAUSS_SCRDIR=$HOME/g09tmp

   # Run using input in "test0027.com"
   export OMP_NUM_THREADS=4
   g09 test0027

