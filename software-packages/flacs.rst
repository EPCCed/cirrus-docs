
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
In contrast, the Cirrus cluster is not
suited for running single big FLACS simulations with many threads:
each node on Cirrus has 2x4 memory channels, and for memory-bound applications
like FLACS multi-threaded execution will not scale linearly beyond eight cores.
On most systems, FLACS will not scale well to more than four cores (cf. the
FLACS User's Manual), and therefore multi-core hardware is normally best used
by increasing the number of simulations running in parallel rather than by
increasing the number of cores per simulation.

CPU time on Cirrus is measured in CPUh for each job run on a compute node,
based on the number of physical cores employed.
Only jobs submitted to compute nodes via ``qsub`` are charged. Any
processing on a login node is not charged.
However, using login nodes for computations other than simple pre- or post-
processing is strongly discouraged.

Running FLACS on Cirrus
-----------------------

Follow the steps below to run FLACS on Cirrus.

*Note:* The instructions below assume you have a valid account on Cirrus. To
get an account please see the instructions in the SAFE Guide: :doc:`../safe-guide/safe-guide-users`

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

   qsub -A xyz -l select=2 -q flacs -- /lustre/sw/flacs/10.5.1/FLACS_v10.5/bin/run_runflacs -dir projects/sim 010101

The ``-A xyz`` option is obligatory and states the account ``xyz``
that the CPU consumption will be billed to. You can check your
account in SAFE (SAFE Guide: :doc:`../safe-guide/safe-guide-users`).

The ``-l select=n`` option specifies the resource allocation for
the job you are starting. The parameter ``n`` must be *twice the
number of physical cores* you wish to employ, which means it is 2
when running a serial FLACS job.

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
   sleep 5; qsub -A xyz -l select=2 -N f-000012 -q flacs -V -- `which run_runflacs` -dir `pwd` 000012
   sleep 5; qsub -A xyz -l select=2 -N f-000023 -q flacs -V -- `which run_runflacs` -dir `pwd` 000023
   sleep 5; qsub -A xyz -l select=2 -N f-000117 -q flacs -V -- `which run_runflacs` -dir `pwd` 000117

This is also easy to formulate as a loop. 


Monitor your jobs
~~~~~~~~~~~~~~~~~

You can monitor the progress of your jobs with the ``qstat`` command.
This will list all jobs that are running or queued on the system. To list 
only your jobs use:

::

   qstat -u username


Transfer data from Cirrus to your local system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After your simulations are finished, transfer the data back from Cirrus
following the instructions at :doc:`../user-guide/transfer`.

For example, to copy the result files from the directory ``project_folder``
in your home directory on Cirrus to the folder ``/tmp`` on your local
machine use:

::

   rsync -rvz --include='r[13t]*.*' --exclude='*' username@cirrus.epcc.ed.ac.uk:project_folder/ /tmp




Getting help
~~~~~~~~~~~~
Get in touch with FLACS Support by email to flacs@gexcon.com if you
encounter any problems. For issues related to Cirrus rather than
FLACS contact the `EPCC helpdesk <../user-guide/support.html>`_.
