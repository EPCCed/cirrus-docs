
FLACS
=====

`FLACS <http://www.gexcon.com/index.php?/flacs-software/article/FLACS-Overview>`_
from `Gexcon <http://www.gexcon.com>`_
is the industry standard for CFD explosion modelling and one of the best validated tools
for modeling flammable and toxic releases in a technical safety context.

The Cirrus cluster is ideally suited to run multiple FLACS simulations
simultaneously, via its `batch system <../user-guide/batch.html>`_.
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

Gexcon has two different service offerings on Cirrus: FLACS-Cloud
and FLACS-HPC.
FLACS-Cloud is the preferable way to exploit the HPC cluster,
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
:doc:`../user-guide/data`.

For example, to copy the scenario definition files from the current
directory to the folder ``project_folder`` in your home directory on
Cirrus run the following command on your local machine:

::

   rsync -avz c*.dat3 username@cirrus.epcc.ed.ac.uk:project_folder

Note that this will preserve soft links as such; the link targets
are not copied if they are outside the current directory.


FLACS license manager
~~~~~~~~~~~~~~~~~~~~~

In order to use FLACS a valid license is required. To check the availability
of a license, a license manager is used. To be able to connect to the
license manager from the batch system, users wishing to use FLACS should
add the following file as ``~/.hasplm/hasp_104628.ini`` (that is, in their
home directory)

::

  ; copy this file (vendor is gexcon) to ~/.hasplm/hasp_104628.ini
  aggressive = 0
  broadcastsearch = 0
  serveraddr = cirrus-services1
  disable_IPv6 = 1



Submit a FLACS job to the queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To run FLACS on Cirrus you must first change to the directory where
your FLACS jobs are located, use the ``cd`` (change directory) command for
Linux. For example

::

   cd projects/sim

The usual way to submit work to the queue system is to write a submission
script, which would be located in the working directory. This is a standard
bash shell script, a simple example of which is given here:

::
  
  #!/bin/bash --login
  
  #SBATCH --job-name=test_flacs_1
  #SBATCH --ntasks=1
  #SBATCH --cpus-per-task=1
  #SBATCH --time=02:00:00
  #SBATCH --partition=standard
  #SBATCH --qos=standard

  module load flacs-cfd/21.2

  run_runflacs 012345

The script has a series of special comments (introduced by `#SBATCH`) which
give information to the queue system to allow the system to allocate space
for the job and to execute the work. These are discussed in more detail
below.

The ``flacs`` module is loaded to make the application available. Note that
you should specify the specific version you require:

::

   module load flacs-cfd/21.2

(Use ``module avail flacs`` to see which versions are available.) The
appropriate FLACS commands can then be executed in  the usual way.

Submit your FLACS jobs using the ``sbatch`` command, e.g.:

::
   
   $ sbatch --account=i123 script.sh
   Submitted batch job 157875

The ``--account=i123`` option is obligatory and states that account ``i123``
will be used to record the CPU time consumed by the job, and result in
billing to the relevant customer. You will need your project account code
here to replace ``i123``. You can check your account details in SAFE.

The name of the submission script here is ``script.sh``. The queue system
returns a unique job id (here ``157875``) to identify the job. For example,
the standard output here will appear in a file named ``slurm-157875.out``
in the current working directory.

Options for FLACS jobs
~~~~~~~~~~~~~~~~~~~~~~

The ``#SBATCH`` lines in the script above set various parameters which
control execution of the job. The first is ``--job-name`` just provides
a label which will be associated with the job.

The parameter ``--ntasks=1`` is the number of tasks or processes involved
in the job. For a serial FLACS job you would use ``--ntasks=1``. The

The maximum length of time (i.e. wall clock time) you want the job to run
is specified with the ``--time=hh:mm:ss`` option. After this
time, your job will be terminated by the job scheduler. The default time
limit is 12 hours. It is useful to have an estimate of how long your
job will take to be able to specify the correct limit (which can take some
experience). Note that shorter jobs can sometimes be scheduled more quickly
by the system.

Multithreaded FLACS simulations can be run on Cirrus with the following job
submission, schematically:

::

  #SBATCH --ntasks=1
  #SBATCH --cpus-per-task=4
  ...

  run_runflacs -dir projects/sim 010101 NumThreads=4

When submitting multithreaded FLACS simulations the ``--cpus-per-task`` option
should be used in order for the queue system to
allocate the correct resources (here 4 threads running on 4 cores).
In addition, one must also specify the number of threads used by the
simulation with the ``NumThreads=4`` option to the run_runflacs.

One can also specify the OpenMP version of FLACS explicitly via, e.g.,

::

  export OMP_NUM_THREADS=20
  
  run_runflacs version _omp <run number> NumThreads=20

See the FLACS
`manual <https://www3.gexcon.com/files/manual/flacs/pdf/flacs-users-manual.pdf>`_ for further details.

Monitor your jobs
~~~~~~~~~~~~~~~~~

You can monitor the progress of your jobs with the ``squeue`` command.
This will list all jobs that are running or queued on the system. To list 
only your jobs use:

::

   squeue -u username


Submitting many FLACS jobs as a job array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Running many related scenarios with the FLACS simulator is ideally suited for
using `job arrays <../user-guide/batch.html#job-arrays>`_, i.e. running the
simulations as part of a single job.

Note you must determine ahead of time the number of scenarios involved.
This determines the number of array elements, which must be specified
at the point of job submission. The number of array elements is
specified by ``--array`` argument to ``sbatch``.

A job script for running a job array with 128 FLACS scenarios that are
located in the current directory could look like this:

::
  
  #!/bin/bash --login
  
  # Recall that the resource specification is per element of the array
  # so this would give four instances of one task (with one thread per
  # task --cpus-per-task=1).
  
  #SBATCH --array=1-128
  
  #SBATCH --ntasks=1
  #SBATCH --cpus-per-task=1
  #SBATCH --time=02:00:00
  #SBATCH --account=z04
  
  #SBATCH --partition=standard
  #SBATCH --qos=commercial
  
  # Abbreviate some SLURM variables for brevity/readability
  
  TASK_MIN=${SLURM_ARRAY_TASK_MIN}
  TASK_MAX=${SLURM_ARRAY_TASK_MAX}
  TASK_ID=${SLURM_ARRAY_TASK_ID}
  TASK_COUNT=${SLURM_ARRAY_TASK_COUNT}
  
  # Form a list of relevant files, and check the number of array elements
  # matches the number of cases with 6-digit identifiers.
  
  CS_FILES=(`ls -1 cs??????.dat3`)
  
  if test "${#CS_FILES[@]}" -ne "${TASK_COUNT}";
  then
    printf "Number of files is:       %s\n" "${#CS_FILES[@]}"
    printf "Number of array tasks is: %s\n" "${TASK_COUNT}"
    printf "Do not match!\n"
  fi
  
  # All tasks loop through the entire list to find their specific case.
  
  for (( jid = $((${TASK_MIN})); jid <= $((${TASK_MAX})); jid++ ));
  do
    if test "${TASK_ID}" -eq "${jid}";
    then
        # File list index with offset zero
	file_id=$((${jid} - ${TASK_MIN}))
	# Form the substring file_id (recall syntax is :offset:length)
	my_file=${CS_FILES[${file_id}]}
	my_file_id=${my_file:2:6}
    fi
  done

  printf "Task %d has file %s id %s\n" "${TASK_ID}" "${my_file}" "${my_file_id}"

  module load flacs-cfd/21.2
  `which run_runflacs` ${my_file_id}




Transfer data from Cirrus to your local system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After your simulations are finished, transfer the data back from Cirrus
following the instructions at :doc:`../user-guide/data`.

For example, to copy the result files from the directory ``project_folder``
in your home directory on Cirrus to the folder ``/tmp`` on your local
machine use:

::

   rsync -rvz --include='r[13t]*.*' --exclude='*' username@cirrus.epcc.ed.ac.uk:project_folder/ /tmp


Billing for FLACS-HPC use on Cirrus
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CPU time on Cirrus is measured in CPUh for each job run on a compute node,
based on the number of physical cores employed.
Only jobs submitted to compute nodes via ``sbatch`` are charged. Any
processing on a login node is not charged.
However, using login nodes for computations other than simple pre- or post-
processing is strongly discouraged.

Gexcon normally bills monthly for the use of FLACS-Cloud and FLACS-HPC,
based on the Cirrus CPU usage logging.


Getting help
------------
Get in touch with FLACS Support by email to flacs@gexcon.com if you
encounter any problems. For specific issues related to Cirrus rather than
FLACS contact the `Cirrus helpdesk <http://www.cirrus.ac.uk/support/>`__.
