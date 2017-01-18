FLACS
=====

`FLACS <http://www.gexcon.com/index.php?/flacs-software/article/FLACS-Overview>`_
from `Gexcon <http://www.gexcon.com>`_
is the industry standard for CFD explosion modelling and one of the best validated tools
for modeling flammable and toxic releases in a technical safety context.

The Cirrus cluster is best suited to run multiple FLACS simulations
simultaneously, via its `batch system <../user-guide/batch.html>`_ PBS.
Short lasting simulations (of typically
up to a few hours computing time each) can be processed efficiently and you
could get a few hundred done in a day or two.
In contrast, the Cirrus cluster is not
suited for running single big FLACS simulations with many threads:
each node on Cirrus has 2x4 memory channels, and for memory-bound applications
like FLACS multi-threaded execution will not scale linearly beyond 8 cores.

CPU time is measured for each job run on a compute node in CPUh,
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

Submit your FLACS job to the queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

   qsub -P project001 -q flacs run runflacs 010101

For monitoring reasons you need to add a flag to the simulations when
you run FLACS jobs on Cirrus. You need to add the option and label
as ``-P Label`` to ``qsub``. The label can for example
contain the project name and simulation type.

All Flacs jobs must be submitted to the flacs queue using the option
``-q flacs``; the flacs queue ensures FLACS licenses are provisioned
correctly for the jobs.

You can monitor the progress of your job with the ``qstat`` command.
This will list all jobs that are running or queued on the system. To list 
only your jobs use:

::

   qstat -u username

When submitting many jobs, for example by a script, ``qsub`` may
react slowly or with a delay.


Transfer data from Cirrus to your local system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After your simulations are finished, transfer the data back from Cirrus
following the instructions at :doc:`../user-guide/transfer`.

