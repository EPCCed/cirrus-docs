Running Jobs on Cirrus
======================

The Cirrus facility uses PBS (Portable Batch System) to schedule jobs.
Writing a submission script is typically the most convenient way to
submit your job to the job submission system. Example submission scripts
(with explanations) for the most common job types are provided below.

Interactive jobs are also available and can be particularly useful for
developing and debugging applications. More details are available below.

If you have any questions on how to run jobs on Cirrus do not hesitate
to contact the EPCC Helpdesk.

Using PBS Pro
-------------

You typically interact with PBS by (1) specifying PBS directives in job
submission scripts (see examples below) and (2) issuing PBS commands
from the login nodes.

There are three key commands used to interact with the PBS on the
command line:

-  ``             qsub         ``
-  ``             qstat         ``
-  ``             qdel         ``

Check the PBS ``man`` page for more advanced commands:

::

    man pbs

The qsub command
~~~~~~~~~~~~~~~~

The qsub command submits a job to PBS:

::

    qsub job_script.pbs

This will submit your job script "job\_script.pbs" to the job-queues.
See the sections below for details on how to write job scripts.

Note: To ensure the minimum wait time for your job, you should specify a
walltime as short as possible for your job (i.e. if your job is going to
run for 3 hours, do not specify 12 hours). On average, the longer the
walltime you specify, the longer you will queue for.

The qstat command
~~~~~~~~~~~~~~~~~

Use the command qstat to view the job queue. For example:

::

    qstat -q

will list all available queues on the Cirrus facility.

You can view just your jobs by using:

::

    qstat -u $USER

The " ``-a`` " option to qstat provides the output in a more useful
format.

To see more information about a queued job, use:

::

    qstat -f $JOBID

This option may be useful when your job fails to enter a running state.
The output contains a PBS comment field which may explain why the job
failed to run.

If the batch system has calculated an estimated start time for a job, it
is possible to view this by adding the ``-T`` flag as follows:

::

    qstat -T $JOBID

The qdel command
~~~~~~~~~~~~~~~~

Use this command to delete a job from Cirrus's job queue. For example:

::

    qdel $JOBID

will remove the job with ID ``$JOBID`` from the queue.

Output from PBS jobs
--------------------

PBS produces standard output and standard error for each batch job can
be found in files ``<jobname>.o<Job ID>`` and ``<jobname>.e<Job ID>``
respectively. These files appear in the job's working directory once
your job has completed or its maximum allocated time to run (i.e. wall
time, see later sections) has ran out.

Running Parallel Jobs
---------------------

This section describes how to write job submission scripts specifically
for different kinds of parallel jobs on Cirrus.

All parallel job submission scripts require (as a minimum) you to
specify three things:

-  The number of virtual cores you require via the
   "``-l             select=[cores]``" option. Each node has 36 physical
   cores (2x 18-core sockets) but hyperthreads are enabled (2 per core).
   Thus, to request 2 nodes, for instance, you must select 144 "cores"
   (36 cores \* 2 hyperthreads \* 2 nodes.
-  The maximum length of time (i.e. walltime) you want the job to run
   for via the "``-l walltime=[hh:mm:ss]``" option. To ensure the
   minimum wait time for your job, you should specify a walltime as
   short as possible for your job (i.e. if your job is going to run for
   3 hours, do not specify 12 hours). On average, the longer the
   walltime you specify, the longer you will queue for.
-  The project code that you want to charge the job to via the
   "``-A             [project code]``" option
-  By default compute nodes are shared, meaning other jobs may be placed
   alongside yours if your resource request (with -l select) leaves some
   cores free. To guarantee exclusive node usage, use the option
   ``-l place=excl``.
-  The project code that you want to charge the job to via the
   "``-A             [project code]``" option
-  ``-N My_job``
   Name for your job is set using ``-N My_job``. In the examples below
   the name will be "My\_job", but uou can replace "My\_job" with any
   name you want. The name will be used in various places. In particular
   it will be used in the queue listing and to generate the name of your
   output and/or error file(s). Note there is a limit on the size of the
   name.

In addition to these mandatory specifications, there are many other
options you can provide to PBS.

PBS Submission Options
~~~~~~~~~~~~~~~~~~~~~~

This section provides more information on various options used when
submitting jobs to PBS on Cirrus. We also list a number of options that
**should not** be used on the system.

When specified in a job submission script, all PBS options start with a
"#PBS"-string. All options can also be specified directly on the command
line.

Parallel job launcher ``mpiexec_mpt``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The job launcher for parallel jobs on Cirrus is ``mpiexec_mpt`` .

A sample MPI job launch line using ``mpiexec_mpt`` looks like:

::

    mpiexec_mpt -n 72 -ppn 36 ./my_mpi_executable.x arg1 arg2

This will start the parallel executable "my\_mpi\_executable.x" with
arguments "arg1" and "arg2". The job will be started using 36 MPI
processes, by default 36 MPI processes are placed on each compute node
using all of the virtual cores available.

The most important ``mpiexec_mpt`` flags are:

 ``-n [total number of MPI processes]``
    Specifies the total number of distributed memory parallel processes
    (not including shared-memory threads). For jobs that use all
    physical cores this will usually be a multiple of 18. The default on
    Cirrus is 1.
 ``-ppn [parallel processes per node]``
    Specifies the number of distributed memory parallel processes per
    node. There is a choice of 1-18 for physical cores on Cirrus compute
    nodes (1-36 if you are using HyperThreading) If you are running with
    exclusive node usage, the most economic choice is always to run with
    "fully-packed" nodes on all physical cores if possible, i.e.
    ``-N 18`` . Running "unpacked" or "underpopulated" (i.e. not using
    all the physical cores on a node) is useful if you need large
    amounts of memory per parallel process or you are using more than
    one shared-memory thread per parallel process.
 ``-nt [threads per parallel process]``
    Specifies the number of cores for each parallel process to use for
    shared-memory threading. (This is in addition to the
    ``OMP_NUM_THREADS`` environment variable if you are using OpenMP for
    your shared memory programming.) The default on Cirrus is 1.
 ``-j [hyperthreads]``
    Specifies the number of Intel HyperThreads to use for each physical
    core. Valid values for this are 0, 1 or 2. 0 indicates that all
    available HyperThreads should be used and hence is equivalent to 2
    on Cirrus. The default is currently 2, but experience suggests -j 1
    should give the best performance for most codes on Cirrus.

Please use ``         man         mpiexec_mpt`` and
``         mpiexec_mpt`` -h to query further options.

Example: job submission script for MPI parallel job
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A simple MPI job submission script to submit a job using 64 compute
nodes (maximum of 1536 physical cores) for 20 minutes would look like:

::

    #!/bin/bash --login

    # PBS job options (name, compute nodes, job time)
    #PBS -N Example_MPI_Job
    #PBS -l select=144
    #PBS -l walltime=00:20:00

    #To get exclusive node usage
    #PBS -l excl

    # Replace [budget code] below with your project code (e.g. t01)
    #PBS -A [budget code]             

    # Change to the directory that the job was submitted from
    cd $PBS_O_WORKDIR

    # Set the number of threads to 1
    #   This prevents any system libraries from automatically 
    #   using threading.
    export OMP_NUM_THREADS=1

    # Launch the parallel job
    #   Using 1536 MPI processes and 24 MPI processes per node
    mpiexec_mpt -n 36 -ppn 18 -j 1 ./my_mpi_executable.x arg1 arg2 > my_stdout.txt 2> my_stderr.txt

This will run your executable "my\_mpi\_executable.x" in parallel on 36
MPI processes using 2 nodes with hyperthreading switched off. PBS will
allocate 2 nodes to your job and place 18 MPI processes on each node
(one per physical core).

See above for a detailed discussion of the different PBS options

Example: job submission script for MPI+OpenMP (mixed mode) parallel job
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Mixed mode codes that use both MPI (or another distributed memory
parallel model) and OpenMP should take care to ensure that the shared
memory portion of the process/thread placement does not span more than
one node. This means that the number of shared memory threads should be
a factor of 18.

In the example below, we are using 2 nodes for 6 hours. There are 4 MPI
processes in total and 16 OpenMP threads per MPI process. NB this
example employs hyperthreads

::

    #!/bin/bash --login

    # PBS job options (name, compute nodes, job time)
    #PBS -N Example_MixedMode_Job
    #PBS -l select=144
    #PBS -l walltime=6:0:0

    # Replace [budget code] below with your project code (e.g. t01)
    #PBS -A [budget code]

    # Change to the direcotry that the job was submitted from
    cd $PBS_O_WORKDIR

    # Set the number of threads to 4
    #   There are 4 OpenMP threads per MPI process
    export OMP_NUM_THREADS=16

    # Launch the parallel job
    #   Using 128*6 = 768 MPI processes
    #   6 MPI processes per node
    #   3 MPI processes per NUMA region
    #   4 OpenMP threads per MPI process
    mpiexec_mpt -n 4 -ppn 2 omplace -nt 16 ./my_mixed_executable.x arg1 arg2 > my_stdout.txt 2> my_stderr.txt

Interactive jobs
~~~~~~~~~~~~~~~~

The nature of the job submission system on Cirrus does not lend itself
to developing or debugging code as the queues are primarily set up for
production jobs.

When you are developing or debugging code you often want to run many
short jobs with a small amount of editing the code between runs. One of
the best ways to achieve this on Cirrus is to use the login nodes. An
interactive job allows you to issue the ' ``mpirun`` ' commands directly
from the command line witout using a job submission script.

For instance, to run a short 4-way MPI job on the login node, issue the
following command ``mpirun -n 4 ./hello_mpi.x``
