Using the Cirrus GPU Nodes
==========================

Cirrus has 38 GPU compute nodes each equipped with 4 NVIDIA V100 (Volta)
GPU cards. This section of the user guide gives some details of the
hardware; it also covers how to compile and run standard GPU applications.

.. Those interested specifically in machine learning applications
.. (particularly using packages such as PyTorch) may be interested
.. in THIS PENDING PAGE.

The GPU cards on Cirrus do not support graphics rendering tasks; they
are set to `compute cluster` mode and so only support computational tasks.


Hardware details
----------------

All of the Cirrus GPU nodes contain four Tesla V100-SXM2-16GB (Volta) cards.
Each card has 16 GB of high-bandwidth memory, ``HBM``, often referred to as
device memory. Maximum device memory bandwidth is in the region of 900 GB per second.
Each card has 5,120 CUDA cores and 640 Tensor cores.

There is one GPU Slurm partition installed on Cirrus called simply ``gpu``.
The 36 nodes in this partition have the Intel Cascade Lake architecture.
Users concerned with host performance should add the specific compilation options
appropriate for the processor.

The Cascade Lake nodes have two 20-core sockets (2.5 GHz) and a total of 384 GB
host memory (192 GB per socket). Each core supports two threads in hardware.

For further details of the V100 architecture see,
https://www.nvidia.com/en-gb/data-center/tesla-v100/ .


Compiling software for the GPU nodes
------------------------------------

NVIDIA HPC SDK
~~~~~~~~~~~~~~

NVIDIA now make regular releases of a unified HPC SDK which provides the
relevant compilers and libraries needed to build and run GPU programs.
Versions of the SDK are available via the module system.

::

  $ module avail nvidia/nvhpc

NVIDIA encourage the use of the latest available version, unless there are
particular reasons to use earlier versions. The default version is therefore
the latest module version present on the system.

Each release of the NVIDIA HPC SDK may include several different versions of
the CUDA toolchain. For example, the ``nvidia/nvhpc/21.2`` module comes
with CUDA 10.2, 11.0 and 11.2. Only one of these CUDA toolchains can be
active at any one time and for ``nvhpc/22.11`` this is CUDA 11.8.

Here is a list of available HPC SDK versions, and the corresponding
version of CUDA:

.. list-table::
   :header-rows: 1

   * - Module
     - Supported CUDA Version
   * - ``nvidia/nvhpc/22.11``
     - CUDA 11.8
   * - ``nvidia/nvhpc/22.2``
     - CUDA 11.6

To load the latest NVIDIA HPC SDK use

::

  $ module load nvidia/nvhpc

The following sections provide some details of compilation for different
programming models.


CUDA
~~~~

`CUDA <https://developer.nvidia.com/cuda-zone>`_ is a parallel computing
platform and programming model developed by NVIDIA for general computing
on graphical processing units (GPUs).

Programs, typically written in C or C++, are compiled with ``nvcc``.
As well as ``nvcc``, a host compiler is required. By default, a ``gcc``
module is added when ``nvidia/nvhpc`` is loaded.

Compile your source code in the usual way.

::

   nvcc -arch=sm_70 -o cuda_test.x cuda_test.cu


.. note::

   The ``-arch=sm_70`` compile option ensures that the binary produced is compatible
   with the NVIDIA Volta architecture.

Using CUDA with Intel compilers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can load either the Intel 18 or Intel 19 compilers to use with ``nvcc``.

::

   module unload gcc
   module load intel-compilers-19

You can now use ``nvcc -ccbin icpc`` to compile your source code with
the Intel C++ compiler ``icpc``.

::

   nvcc -arch=sm_70 -ccbin icpc -o cuda_test.x cuda_test.cu


Compiling OpenACC code
~~~~~~~~~~~~~~~~~~~~~~

OpenACC is a directive-based approach to introducing parallelism into
either C/C++ or Fortran codes. A code with OpenACC directives may be
compiled like so.

::

  $ module load nvidia/nvhpc
  $ nvc program.c

::

  $ nvc++ program.cpp

Note that ``nvc`` and ``nvc++`` are distinct from the NVIDIA CUDA compiler
``nvcc``. They provide a way to compile standard C or C++ programs without
explicit CUDA content. See ``man nvc`` or ``man nvc++`` for further details.


CUDA Fortran
~~~~~~~~~~~~

CUDA Fortran provides extensions to standard Fortran which allow GPU
functionality. CUDA Fortran files (with file extension ``.cuf``)
may be compiled with the NVIDIA Fortran compiler.

::

  $ module load nvidia/nvhpc
  $ nvfortran program.cuf

See ``man nvfortran`` for further details.

OpenMP for GPUs
~~~~~~~~~~~~~~~

The OpenMP API supports multi-platform shared-memory parallel programming in C/C++ and Fortran and can offload computation from the host (i.e. CPU) to one or more target devices (such as the GPUs on Cirrus). 
OpenMP code can be compiled with the NVIDIA compilers in a similar manner to OpenACC. To enable this functionality, you must add ``-mp=gpu`` to your compile command.

::

  $ module load nvidia/nvhpc
  $ nvc++ -mp=gpu program.cpp

You can specify exactly which GPU to target with the ``-gpu`` flag. For example, the Volta cards on Cirrus use the flag ``-gpu=cc70``.

During development it can be useful to have the compiler report information about how it is processing OpenMP pragmas. This can be enabled by the use of ``-Minfo=mp``, see below.

::

  nvc -mp=gpu -Minfo=mp testprogram.c
  main:
  24, #omp target teams distribute parallel for thread_limit(128)
  24, Generating Tesla and Multicore code
  Generating "nvkernel_main_F1L88_2" GPU kernel
  26, Loop parallelized across teams and threads(128), schedule(static)

Submitting jobs to the GPU nodes
--------------------------------

To run a GPU job, a SLURM submission must specify a GPU partition and
a quality of service (QoS) as well as the number of GPUs required.
You specify the number of GPU cards you want using the ``--gres=gpu:N`` option,
where ``N`` is typically 1, 2 or 4.

.. note::

   As there are 4 GPUs per node, each GPU is associated with 1/4 of the
   resources of the node, i.e., 10/40 physical cores and roughly 91/384 GB in
   host memory.

Allocations of host resources are made pro-rata. For example, if 2 GPUs are
requested, ``sbatch`` will allocate 20 cores and around 190 GB of host memory
(in addition to 2 GPUs). Any attempt to use more than the allocated resources
will result in an error.

This automatic allocation by SLURM for GPU jobs means that the
submission script should not specify options such as ``--ntasks`` and
``--cpus-per-task``. Such a job submission will be rejected. See below
for some examples of how to use host resources and how to launch MPI
applications.

If you specify the ``--exclusive`` option, you will automatically be
allocated all host cores and all memory from the node irrespective
of how many GPUs you request. This may be needed if the application
has a large host memory requirement.

If more than one node is required, exclusive mode ``--exclusive`` and
``--gres=gpu:4`` options must be included in your submission script.
It is, for example, not possible to request 6 GPUs other than via
exclusive use of two nodes.

.. warning::

   In order to run jobs on the GPU nodes your budget must have positive
   GPU hours *and* positive CPU core hours associated with it.
   However, only your GPU hours will be consumed when running these jobs.

Partitions
~~~~~~~~~~
Your job script must specify a partition. The following table has a list 
of relevant GPU partition(s) on Cirrus.

.. list-table:: Cirrus Partitions
   :widths: 30 50 20
   :header-rows: 1

   * - Partition
     - Description
     - Maximum Job Size (Nodes)
   * - gpu
     - GPU nodes with Cascade Lake processors
     - 36

Quality of Service (QoS)
~~~~~~~~~~~~~~~~~~~~~~~~
Your job script must specify a QoS relevant for the GPU nodes. Available
QoS specifications are as follows.

.. list-table:: GPU QoS
   :header-rows: 1

   * - QoS Name
     - Jobs Running Per User
     - Jobs Queued Per User
     - Max Walltime
     - Max Size
     - Partition
   * - gpu
     - No limit
     - 128 jobs
     - 4 days
     - 64 GPUs
     - gpu
   * - long
     - 5 jobs
     - 20 jobs
     - 14 days
     - 8 GPUs
     - gpu
   * - short
     - 1 job
     - 2 jobs
     - 20 minutes
     - 4 GPUs
     - gpu
   * - lowpriority
     - No limit
     - 100 jobs
     - 2 days
     - 16 GPUs
     - gpu
   * - largescale
     - 1 job
     - 4 jobs
     - 24 hours
     - 144 GPUs
     - gpu

Examples
--------
   
Job submission script using one GPU on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that requires 1 GPU accelerator and 10 CPU cores for 20 minutes
would look like the following.

::

   #!/bin/bash
   #
   #SBATCH --partition=gpu
   #SBATCH --qos=gpu
   #SBATCH --gres=gpu:1
   #SBATCH --time=00:20:00

   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
     
   # Load the required modules 
   module load nvidia/nvhpc
   
   srun ./cuda_test.x

This will execute one host process with access to one GPU. If we wish to
make use of the 10 host cores in this allocation, we could use host
threads via OpenMP.

::

  export OMP_NUM_THREADS=10
  export OMP_PLACES=cores

  srun --ntasks=1 --cpus-per-task=10 --hint=nomultithread ./cuda_test.x

The launch configuration is specified directly to ``srun`` because, for the
GPU partitions, it is not possible to do this via ``sbatch``.


Job submission script using multiple GPUs on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that requires 4 GPU accelerators and 40 CPU cores for 20 minutes
would appear as follows.

::

    #!/bin/bash
    #
    #SBATCH --partition=gpu
    #SBATCH --qos=gpu
    #SBATCH --gres=gpu:4
    #SBATCH --time=00:20:00

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]
    
    # Load the required modules 
    module load nvidia/nvhpc

    srun ./cuda_test.x

A typical MPI application might assign one device per MPI process, in
which case we would want 4 MPI tasks in this example. This would again
be specified directly to ``srun``.

::

   srun --ntasks=4 ./mpi_cuda_test.x


Job submission script using multiple GPUs on multiple nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See below for a job script that requires 8 GPU accelerators for 20 minutes.

::

    #!/bin/bash
    #
    #SBATCH --partition=gpu
    #SBATCH --qos=gpu
    #SBATCH --gres=gpu:4
    #SBATCH --nodes=2
    #SBATCH --exclusive
    #SBATCH --time=00:20:00

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]
    
    # Load the required modules 
    module load nvidia/nvhpc

    srun ./cuda_test.x

An MPI application with four MPI tasks per node would be launched as follows.

::

  srun --ntasks=8 --tasks-per-node=4 ./mpi_cuda_test.x

Again, these options are specified directly to ``srun`` rather than
being declared as ``sbatch`` directives.

Attempts to oversubscribe an allocation (10 cores per GPU) will fail, and
generate an error message.

::

  srun: error: Unable to create step for job 234123: More processors requested
  than permitted


Debugging GPU applications
--------------------------

Applications may be debugged using ``cuda-gdb``. This is an extension
of ``gdb`` which can be used with CUDA. We assume the reader is
familiar with ``gdb``.

First, compile the application with the ``-g -G`` flags in order to generate
debugging information for both host and device code. Then, obtain an interactive
session like so.

::

  $ srun --nodes=1 --partition=gpu --qos=short --gres=gpu:1 \
         --time=0:20:0 --account=[budget code] --pty /bin/bash

Next, load the NVIDIA HPC SDK module and start ``cuda-gdb`` for your application.

::

  $ module load nvidia/nvhpc
  $ cuda-gdb ./my-application.x
  NVIDIA (R) CUDA Debugger
  ...
  (cuda-gdb) 

Debugging then proceeds as usual. One can use the help facility within ``cuda-gdb``
to find details on the various debugging commands. Type ``quit`` to end your debug
session followed by ``exit`` to close the interactive session.

Note, it may be necessary to set the temporary directory to somewhere in the user space
(e.g., ``export TMPDIR=$(pwd)/tmp``) to prevent unexpected internal CUDA driver errors.

For further information on CUDA-GDB, see https://docs.nvidia.com/cuda/cuda-gdb/index.html.


Profiling GPU applications
--------------------------

NVIDIA provide two useful tools for profiling performance of applications:
Nsight Systems and Nsight Compute; the former provides an overview of
application performance, while the latter provides detailed information
specifically on GPU kernels.

Using Nsight Systems
~~~~~~~~~~~~~~~~~~~~

Nsight Systems provides an overview of application performance and should
therefore be the starting point for investigation. To run an application,
compile as normal (including the ``-g`` flag) and then submit a batch job.

::

  #!/bin/bash
  
  #SBATCH --time=00:10:00
  #SBATCH --nodes=1
  #SBATCH --exclusive  
  #SBATCH --partition=gpu
  #SBATCH --qos=short
  #SBATCH --gres=gpu:1

  # Replace [budget code] below with your project code (e.g. t01)
  #SBATCH --account=[budget code]
  
  module load nvidia/nvhpc
  
  srun -n 1 nsys profile -o prof1 ./my_application.x

The run should then produce an additional output file called, in this
case, ``prof1.qdrep``. The recommended way to view the contents
of this file is to download the NVIDIA Nsight package to your own
machine (you do not need the entire HPC SDK). Then copy the ``.qdrep``
file produced on Cirrus so that if can be viewed locally.

Note, a profiling run should probably be of a short duration so that the
profile information (contained in the ``.qdrep`` file) does not become
prohibitively large.

Details of the download of Nsight Systems and a user guide can be found 
via the links below.

https://developer.nvidia.com/nsight-systems

https://docs.nvidia.com/nsight-systems/UserGuide/index.html

If your code was compiled with the tools provided by ``nvidia/nvhpc/21.2``
you should download and install Nsight Systems v2020.5.1.85.


Using Nsight Compute
~~~~~~~~~~~~~~~~~~~~

Nsight Compute may be used in a similar way as Nsight Systems. A job may
be submitted like so.

::

  #!/bin/bash
  
  #SBATCH --time=00:10:00
  #SBATCH --nodes=1
  #SBATCH --exclusive
  #SBATCH --partition=gpu
  #SBATCH --qos=short
  #SBATCH --gres=gpu:1
  
  # Replace [budget code] below with your project code (e.g. t01)
  #SBATCH --account=[budget code]

  module load nvidia/nvhpc
  
  srun -n 1 nv-nsight-cu-cli --section SpeedOfLight_RooflineChart \
                             -o prof2 -f ./my_application.x

In this case, a file called ``prof2.ncu-rep`` should be produced. Again, the
recommended way to view this file is to download the Nsight Compute
package to your own machine, along with the ``.ncu-rep`` file from Cirrus.
The ``--section`` option determines which statistics are recorded (typically
not all hardware counters can be accessed at the same time). A common starting
point is ``--section MemoryWorkloadAnalysis``.

Consult the NVIDIA documentation for further details.

https://developer.nvidia.com/nsight-compute

https://docs.nvidia.com/nsight-compute/2021.2/index.html

Nsight Compute v2021.3.1.0 has been found to work for codes compiled using
``nvhpc`` versions 21.2 and 21.9.


Compiling and using GPU-aware MPI
---------------------------------

For applications using message passing via MPI, considerable improvements
in performance may be available by allowing device memory references in
MPI calls. This allows replacement of relevant host device transfers by
direct communication within a node via NVLink. Between nodes, MPI
communication will remain limited by network latency and bandwidth.

Version of OpenMPI with both CUDA-aware MPI support and SLURM support
are available, you should load the following modules:

::

   module load openmpi/4.1.4-cuda-11.8
   module load nvidia/nvhpc-nompi/22.11
   
The command you use to compile depends on whether you are compiling C/C++ or
Fortran.

Compiling C/C++
~~~~~~~~~~~~~~~

The location of the MPI include files and libraries must be
specified explicitly, e.g.,

::

   nvcc -I${MPI_HOME}/include  -L${MPI_HOME}/lib -lmpi -o my_program.x my_program.cu

This will produce an executable in the usual way.

Compiling Fortran
~~~~~~~~~~~~~~~~~

Use the ``mpif90`` compiler wrapper to compile Fortran code for GPU. e.g.

::

   mpif90 -o my_program.x my_program.f90
   
This will produce an executable in the usual way.

Run time
~~~~~~~~

A batch script to use such an executable might be:

::

   #!/bin/bash
   
   #SBATCH --time=00:20:00

   #SBATCH --nodes=1
   #SBATCH --partition=gpu
   #SBATCH --qos=gpu
   #SBATCH --gres=gpu:4

   # Load the appropriate modules, e.g.,
   module load openmpi/4.1.4-cuda-11.8
   module load nvidia/nvhpc-nompi/22.2

   export OMP_NUM_THREADS=1

   # Note the addition
   export OMPI_MCA_pml=ob1

   srun --ntasks=4 --cpus-per-task=10 --hint=nomultithread ./my_program

Note the addition of the environment variable ``OMPI_MCA_pml=ob1`` is
required for correct operation. As before, MPI and placement options
should be directly specified to ``srun`` and not via ``SBATCH`` directives. 
