Intel VTune
===========

Profiling using VTune
---------------------

Intel VTune allows profiling of compiled codes, and is particularly
suited to analysing high performance applications involving threads
(OpenMP), and MPI (or some combination thereof).

Using VTune is a two-stage process. First, an application is
compiled using an appropriate Intel compiler and run in a "collection"
phase. The results are stored to file, and may then be inspected
interactively via the VTune GUI.



Collection
----------

Compile the application in the normal way, and run a batch job in
exclusive mode to ensure the node is not shared with other jobs.
An example is given below.

Collection of performance data is based on a ``collect`` option,
which defines which set of hardware counters are monitered in a
given run. As not all counters are available at the same time, a
number of different collections are available. A different one
may be relevant if interested in different aspects of performance.
Some standard options are:

``vtune -collect=performance-snapshot`` may be used to product a
text summary of performance (typically to standard output),
which can be used as a basis for further investigation.

``vtune -collect=hotspots`` produces a more detailed analysis which
can be used to inspect time taken per function and per line of code.

``vtune -collect=hpc-performance`` may be useful for HPC codes.

``vtune --collect=meory-access`` will provide figures for memory-related
measures including application memory bandwidth.

Use ``vtune --help collect`` for a full summary of collection options.
Note that not all options are available (e.g., prefer NVIDIA profiling
for GPU codes).


Example SLURM script
^^^^^^^^^^^^^^^^^^^^

Here we give an example of profiling an application which has been
compiled with Intel 20.4 and requests the ``memory-access`` collection.
We assume the application involves OpenMP threads, but no MPI.

::

   #!/bin/bash 
   
   #SBATCH --time=00:10:00
   #SBATCH --nodes=1
   #SBATCH --exclusive

   #SBATCH --partition=standard
   #SBATCH --qos=standard

   export OMP_NUM_THREADS=18

   # Load relevant (cf. compile-time) Intel options 
   module load intel-20.4/compilers
   module load intel-20.4/vtune

   vtune -collect=memory-access -r results-memory ./my_application

Profiling will generate a certain amount of additional text information;
this appears on standard output. Detailed profiling data will be stored in
various files in a sub-directory, the name of which can be specified
using the ``-r`` option.

Notes

* Older Intel compilers use ``amplxe-cl`` instead of ``vtune`` as the
  command for collection. Some existing features still reflect this
  older name. Older versions do not offer the "performance-snapshot"
  collection option.

* Extra time should be allowed in the wall clock time limit to allow
  for processing of the profiling data by ``vtune`` at the end of the
  run. In general, a short run of the application (a few minutes at
  most) should be tried first.

* A warning may be issued:

    amplxe: Warning: Access to /proc/kallsyms file is limited.
    Consider changing /proc/sys/kernel/kptr_restrict to 0 to
    enable resolution of OS kernel and kernel modules symbols.

  This may be safely ignored.

* A warning may be issued:

    amplxe: Warning: The specified data limit of 500 MB is reached. Data
    collection is stopped. amplxe: Collection detached.

  This can be safely ignored, as
  a working result will still be obtained. It is possible to increase the limit
  via the ``-data-limit`` option (500 MB is the default). However, larger
  data files can take an extremely long time to process in the report stage
  at the end of the run, and so the option is not recommended.

* For Intel 20.4, the ``--collect=hostspots`` option has been observed to
  be problematic. We suggest it is not used.


Profiling an MPI code
^^^^^^^^^^^^^^^^^^^^^

Intel VTune can also be used to profile MPI codes. It is recommended that
the relavant Intel MPI module is used for compilation. The following
example uses Intel 18 with the older ``amplxe-cl`` command:

::

   #!/bin/bash 
   
   #SBATCH --time=00:10:00
   #SBATCH --nodes=2
   #SBATCH --exclusive

   #SBATCH --partition=standard
   #SBATCH --qos=standard

   export OMP_NUM_THREADS=18

   module load intel-mpi-18
   module load intel-compilers-18
   module load intel-vtune-18

   mpirun -np 4 -ppn 2 amplxe-cl -collect hotspots -r vtune-hotspots \
          ./my_application


Note that the Intel MPI launcher ``mpirun`` is used, and this precedes
the VTune command. The example runs a total of 4 MPI tasks (``-np 4``)
with two tasks per node (``-ppn 2``). Each task runs 18 OpenMP threads.


Viewing the results
-------------------

We recommend that the latest version of the VTune GUI is used to view
results; this can be run interactively with an appropriate X connection.
The latest version is available via

::

    $ module load oneapi
    $ module load vtune/latest
    $ vtune-gui

From the GUI, navigate to the appropriate results file to load the
analysis. Note that the latest version of VTune will be able to read
results generated with previous versions of the Intel compilers.

