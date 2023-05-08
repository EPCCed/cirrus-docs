ANSYS Fluent
============

`ANSYS Fluent <http://www.ansys.com/Products/Fluids/ANSYS-Fluent>`__
is a computational fluid dynamics (CFD) tool. Fluent includes
well-validated physical modelling capabilities to deliver fast,
accurate results across the widest range of CFD and multi-physics
applications.

Useful Links
------------

 * `ANSYS Fluent User Guides <http://www.ansys.com/Products/Fluids/ANSYS-Fluent>`__

Using ANSYS Fluent on Cirrus
----------------------------

**ANSYS Fluent on Cirrus is only available to researchers who bring
their own licence. Other users cannot access the version
centrally-installed on Cirrus.**

If you have any questions regarding ANSYS Fluent on Cirrus please contact the
`Cirrus Helpdesk <http://www.cirrus.ac.uk/support/>`__.


Running parallel ANSYS Fluent jobs
-----------------------------------

The following batch file starts Fluent in a command line mode (no GUI)
and starts the Fluent batch file "inputfile". One parameter that
requires particular attention is "-t504". In this example 14 Cirrus
nodes (14 * 72 = 1008 cores) are allocated; where half of the 1008
cores are physical and the other half are virtual.  To run fluent
optimally on Cirrus, only the physical cores should be employed.  As
such, fluent's -t flag should reflect the number of physical cores: in
this example, "-t504" is employed.

::

    #!/bin/bash

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=ANSYS_test
    #SBATCH --time=0:20:0
    #SBATCH --exclusive
    #SBATCH --nodes=4
    #SBATCH --tasks-per-node=36
    #SBATCH --cpus-per-task=1

    # Replace [budget code] below with your budget code (e.g. t01)
    #SBATCH --account=[budget code]
    # Replace [partition name] below with your partition name (e.g. standard,gpu)
    #SBATCH --partition=[partition name]
    # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
    #SBATCH --qos=[qos name]

    # Set the number of threads to 1
    #   This prevents any threaded system libraries from automatically
    #   using threading.
    export OMP_NUM_THREADS=1

    export HOME=${HOME/home/work}

    scontrol show hostnames $SLURM_NODELIST > ~/fluent.launcher.host.txt

    # Launch the parallel job
    ./fluent 3ddp -g -i inputfile.fl \
      -pinfiniband -alnamd64 -t504 -pib    \
      -cnf=~/fluent.launcher.host.txt      \
      -ssh  >& outputfile.txt

Below is the Fluent "inputfile.fl" batch script. Anything that starts
with a ";" is a comment. This script does the following:

 * Starts a transcript (i.e. Fluent output is redirected to a file [transcript_output_01.txt])
 * Reads a case file [a case file in Fluent is a model]
 * Reads a data file [a data file in Fluent is the current state of a simulation (i.e. after X iterations)]
 * Prints latency and bandwidth statistics
 * Prints and resets timers
 * Run 50 iterations of the simulation
 * Prints and resets timers
 * Save the data file (so that you can continue the simulation)
 * Stops the transcript
 * Exits Fluent

Actual Fluent script ("inputfile.fl"):
--------------------------------------

Replace [Your Path To ] before running

::

  ; Start transcript
  /file/start-transcript [Your Path To ]/transcript_output_01.txt
  ; Read case file
  rc [Your Path To ]/200M-CFD-Benchmark.cas
  ; Read data file
  /file/read-data [Your Path To ]/200M-CFD-Benchmark-500.dat
  ; Print statistics
  /parallel/bandwidth
  /parallel/latency
  /parallel/timer/usage
  /parallel/timer/reset
  ; Calculate 50 iterations
  it 50
  ; Print statistics
  /parallel/timer/usage
  /parallel/timer/reset
  ; Write data file
  wd [Your Path To ]/200M-CFD-Benchmark-500-new.dat
  ; Stop transcript
  /file/stop-transcript
  ; Exit Fluent
  exit
  yes
