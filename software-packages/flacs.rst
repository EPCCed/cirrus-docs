FLACS
=====

`FLACS from GexCon <http://www.gexcon.com/index.php?/flacs-software/article/FLACS-Overview>`_
is the industry standard for CFD explosion modelling and one of the best validated tools
for modeling flammable and toxic releases in a technical safety context.

The Cirrus cluster is best suited to run multiple FLACS simulations
simultaneously (using a batch queue). Short lasting simulations (a few
minutes up to a few hours each) can be processed efficiently and you
could get a few hundred done in a day or two. The Cirrus cluster is not
suited for running single big FLACS simulations each with many threads.
You are not guaranteed to have exclusive access to a given compute node
for your multi-thread simulation because at times there might be other
heavy jobs running on the same compute node.

CPU time is measured for each job run on a compute node in CPUh.
Only jobs submitted to compute nodes via qsub are charged. Any
processing on a login node is not charged.
However, using login nodes for processing other than pre- or post-
processing is not recommended.

Please also note that any licence limitations do not apply on the HPC
Service.

Running FLACS on Cirrus
-----------------------

Follow the steps below to run FLACS on Cirrus.

*Note:* The instructions below assume you have a valid account on Cirrus. To
get an account please see the instructions in the SAFE Guide: :doc:`../safe-guide/safe-guide-users`

*Note:* In the instructions below you should substitute "username" for
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

Submit your FLACS jobs to Cirrus queues using the ``qsub`` command.
For example:

::

   qsub -P project001 run runflacs 010101

For monitoring reasons you need to add a flag to the simulations when
you run FLACS jobs on Cirrus. You need to add the option and label
after qsub "-P Label" in the run file. The label can for example
contain project name and simulation type.

You can monitor the progress of your job with the ``qstat`` command.
This will list all jobs running and queued on the system. To list 
only your jobs, you would use:

::

   qstat -u username

Transfer data from Cirrus to your local system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After your simulations are finished, transfer the data back from Cirrus
following the instructions at :doc:`../user-guide/transfer`.

