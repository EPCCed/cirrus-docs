
FLACS
=====

`FLACS <http://www.gexcon.com/index.php?/flacs-software/article/FLACS-Overview>`_
from `Gexcon <http://www.gexcon.com>`_
is the industry standard for CFD explosion modelling and one of the best validated tools
for modeling flammable and toxic releases in a technical safety context.

The Cirrus cluster is ideally suited to run multiple FLACS simulations
simultaneously, via its `batch system <../user-guide/batch.html>`_ PBS.
Short lasting simulations (of typically
up to a few hours computing time each) can be processed efficiently and you
could get a few hundred done in a day or two.
In contrast, the Cirrus cluster is not particularly
suited for running single big FLACS simulations with many threads:
each node on Cirrus has 2x4 memory channels, and for memory-bound applications
like FLACS multi-threaded execution will not scale linearly beyond eight cores.
On most systems, FLACS will not scale well to more than four cores (cf. the
FLACS User's Manual), and therefore multi-core hardware is normally best used
by increasing the number of simulations running in parallel rather than by
increasing the number of cores per simulation.

Gexcon has two different service offerings on Cirrus: FLACS-Cloud and FLACS-HPC.
From FLACS v10.7, FLACS-Cloud is the preferable way to exploit the HPC cluster,
directly from the FLACS graphical user interfaces. For users who are familiar
with accessing remote Linux HPC systems manually, FLACS-HPC may be an option.
Both services are presented below. 


FLACS-Cloud 
-----------

FLACS-Cloud is a high performance computing service available right from
the FLACS-Risk user interface, as well as from the FLACS RunManager. It
allows you to run FLACS simulations on the high performance cloud
computing infrastructure of Gexcon's partner EPCC straight from the
graphical user interfaces of FLACS -- no need to manually log in,
transfer data, or start jobs!

By using the FLACS-Cloud service, you can run a large number of
simulations very quickly, without having to invest into in-house
computing hardware. The FLACS-Cloud service scales to your your demand
and facilitates running projects with rapid development cycles.

The workflow for using FLACS-Cloud is described in the FLACS User's
Manual and in the FLACS-Risk documentation; you can also find basic
information in the knowledge base of the 
`FLACS User Portal <https://gexcon.freshdesk.com/solution/categories/14000072843>`_
(accessible for FLACS license holders).



FLACS-HPC
---------

Compared to FLACS-Cloud, the FLACS-HPC service is built on more
traditional ways of accessing and using a remote Linux cluster.
Therefore the user experience is more basic, and FLACS has to be run
manually. For an experienced user, however, this way of exploiting
the HPC system can be at least as efficient as FLACS-Cloud.

Follow the steps below to use the FLACS-HPC facilities on Cirrus.

*Note:* The instructions below assume you have a valid account on Cirrus. To
get an account please first get in touch with FLACS support at
flacs@gexcon.com and then see the instructions in the
`Tier-2 SAFE Documentation <https://tier2-safe.readthedocs.io>`__.

*Note:* In the instructions below you should substitute "username" by
your actual Cirrus username.

Log into Cirrus
~~~~~~~~~~~~~~~

Log into Cirrus following the instructions at :doc:`../user-guide/connecting`.

Upload your data to Cirrus
~~~~~~~~~~~~~~~~~~~~~~~~~~

Transfer your data to Cirrus by following the instructions at
:doc:`../user-guide/transfer`.

For example, to copy the scenario definition files from the current
directory to the folder ``project_folder`` in your home directory on
Cirrus run the following command on your local machine:

::

   rsync -avz c*.dat3 username@cirrus.epcc.ed.ac.uk:project_folder

Note that this will preserve soft links as such; the link targets
are not copied if they are outside the current directory.

Submit a FLACS job to the queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To run FLACS on Cirrus you must first change to the directory where
your FLACS jobs are located, use the ``cd`` (change directory) command for
Linux. For example

::

   cd projects/sim


Load the ``flacs`` module to make the application available:

::

   module load flacs

Submit your FLACS jobs using the ``qsub`` command.
For example:

::

   qsub -A xyz -l select=1:ncpus=1 -l walltime=6:00:00 -q flacs -- /lustre/sw/flacs/10.5.1/FLACS_v10.5/bin/run_runflacs -dir projects/sim 010101

The ``-A xyz`` option is obligatory and states the account ``xyz``
that the CPU consumption will be billed to. You can check your
account in SAFE.

The ``-l select=x:ncpus=y`` option specifies the resource allocation for
the job you are starting. The parameter ``x`` is the number of nodes
required and the parameter ``y`` is the number of cores required. For
a serial FLACS job you would use ``-l select=1:ncpus=1``

The maximum length of time (i.e. walltime) you want the job to run
is specified with the ``-l walltime=[hh:mm:ss]`` option. After this
time, your job will be stopped by the job scheduler. Setting a very
high walltime limit may lead to your job being given lower priority
and thus wait longer in the queue. The default walltime is 12 hours.

All Flacs jobs must be submitted to the flacs queue using the option
``-q flacs``; the flacs queue ensures FLACS licenses are provisioned
correctly for the jobs.

After the ``--`` which marks the beginning of the command to run, the
Flacs executable is given *with its absolute path*.
Having loaded the flacs module (see above) you can find the location
by 

::

   which run_runflacs

The ``run_runflacs`` command in turn needs two arguments: first, after
``-dir``, the directory where to run the job and create the output; if
it is the current directory then you can pass ``-dir `pwd```.
Second, the job number of the FLACS scenario.

Submit FLACS jobs from a script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In your script, change to the directory with the job files and load the flacs
module as explained above.

When submitting several jobs it is advisable to add the ``-N name``
option to the ``qsub`` command, with the FLACS job number being part
of the first ten characters of the name. In this way you can easily
identify the jobs in the queue (see below).

During testing it has been shown that job submission to the queue runs
more smoothly when there is a short delay of 5 seconds before subsequent
``qsub`` commands.

A script submitting the scenarios 000012, 000023 and 000117 to the queue
could look like this:

::

   module load flacs/10.5.1
   sleep 5; qsub -A xyz -l select=1:ncpus=1 -l walltime=24:00:00 -N f-000012 -q flacs -V -- `which run_runflacs` -dir `pwd` 000012
   sleep 5; qsub -A xyz -l select=1:ncpus=1 -l walltime=24:00:00 -N f-000023 -q flacs -V -- `which run_runflacs` -dir `pwd` 000023
   sleep 5; qsub -A xyz -l select=1:ncpus=1 -l walltime=24:00:00 -N f-000117 -q flacs -V -- `which run_runflacs` -dir `pwd` 000117

This is also easy to formulate as a loop. 


Monitor your jobs
~~~~~~~~~~~~~~~~~

You can monitor the progress of your jobs with the ``qstat`` command.
This will list all jobs that are running or queued on the system. To list 
only your jobs use:

::

   qstat -u username


Submitting many FLACS jobs as a job array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Running many related scenarios with the Flacs simulator is ideally suited for
using `job arrays <../user-guide/batch.html#job-arrays>`_, i.e. running the
simulations as part of a single job.

A job script for running a job array with 128 Flacs scenarios that are located in
the current directory could look like this:

::

    #!/bin/bash --login
    #PBS -l select=1:ncpus=1
    #PBS -N disp2
    #PBS -J 1-128
    #PBS -j oe
    #PBS -l walltime=48:00:00
    #PBS -q flacs
    #PBS -V

    cd ${PBS_O_WORKDIR}

    CS_FILES=(`ls -1 cs??????.dat3`)
    # NR_OF_JOBS=${#CS_FILES[@]}
    JOB_FIRST=1
    JOB_LAST=128
    for (( i=0; i<$(expr ${JOB_LAST} - ${JOB_FIRST}); i++ ));
    do
      JOB_IDS[${i}]=${CS_FILES[$(expr $i + ${JOB_FIRST})]:2:6}
    done

    module load flacs
    JOB_INDEX=$(( $PBS_ARRAY_INDEX - 1 ))

    `which run_runflacs` ${JOB_IDS[${JOB_INDEX}]}

Due to the way the job scheduler interprets this script, the number
of jobs has to be hard-coded in the first (non-bash) part of the job
script and cannot be determined based on the number of scenarios in
the current directory.


Transfer data from Cirrus to your local system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After your simulations are finished, transfer the data back from Cirrus
following the instructions at :doc:`../user-guide/transfer`.

For example, to copy the result files from the directory ``project_folder``
in your home directory on Cirrus to the folder ``/tmp`` on your local
machine use:

::

   rsync -rvz --include='r[13t]*.*' --exclude='*' username@cirrus.epcc.ed.ac.uk:project_folder/ /tmp


Billing for FLACS-HPC use on Cirrus
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CPU time on Cirrus is measured in CPUh for each job run on a compute node,
based on the number of physical cores employed.
Only jobs submitted to compute nodes via ``qsub`` are charged. Any
processing on a login node is not charged.
However, using login nodes for computations other than simple pre- or post-
processing is strongly discouraged.

Gexcon normally bills monthly for the use of FLACS-Cloud and FLACS-HPC,
based on the Cirrus CPU usage logging.


Getting help
------------
Get in touch with FLACS Support by email to flacs@gexcon.com if you
encounter any problems. For issues related to Cirrus rather than
FLACS contact the `Cirrus helpdesk <http://www.cirrus.ac.uk/support/>`__.
