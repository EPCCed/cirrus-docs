Using the Cirrus GPU Nodes
==========================

Cirrus has 38 compute nodes each equipped with 4 NVIDIA V100 (Volta)
GPU cards. This section of the user guide gives some details of the
hardware, and goes on to describe how to compile and run standard
GPU applications.

.. Those interested specificially in machine learning applications
.. (particularly using packages such as PyTorch) may be interested
.. in THIS PENDING PAGE.

The GPU cards on Cirrus do not support graphics rendering tasks
(they are only available for computational tasks in "compute cluster mode").


Hardware details
----------------

All the GPU nodes on Cirrus contain four V100-SXM2-16GB (Volta) cards. Each
card has 16GB of high-bandwidth memory (HBM2, often referred to as device
memory). Maximum
device memory bandwidth is in the region of 900 GB per second. Each card
has 5,120 CUDA cores, and 640 "Tensor" cores.

There are two GPU partitions available to SLURM, with slightly different
host architectures.

Two nodes have Intel Skylake processors (as detailed elsewhere), while
the remaining 36 nodes are slightly later Intel Cascadelake archetecture.
Users concerned with host performance should add appropriate compilation
options for the specific host architecture.

In both cases, the host node has two 20-core sockets (2.5 GHz), and a total
of 384 GB host memory (192 GB per socket). Each core supports two threads
in hardware.

For further details of the V100 architecture see, e.g.,
https://www.nvidia.com/en-gb/data-center/tesla-v100/


Compiling software for the GPU nodes
------------------------------------

NVIDIA HPC SDK
~~~~~~~~~~~~~~

NVIDIA now make regular releases of a unified HPC SDK which provides the
relevant compilers and libraries needed to build and run GPU programs.
Versions of the SDK are available via the module system, e.g.:

::

  $ module avail nvidia/nvhpc
  ---------------------------- /lustre/sw/modulefiles -------------------------
  nvidia/nvhpc-byo-compiler/21.2  nvidia/nvhpc/21.2(default)  
  nvidia/nvhpc-nompi/21.2         nvidia/nvhpc/21.2-gnu       

In the first instance, the default ``nvhpc`` module is recommended:

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
module is loaded when ``nvidia/nvhpc`` is loaded.

Compile your source code in the usual way, e.g.:

::

   nvcc -o cuda_test.x cuda_test.cu

Using CUDA with Intel compilers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can load either the Intel 18 or Intel 19 compilers to use with ``nvcc``,
e.g.,

::

   module unload gcc
   module load intel-compilers-18

You can now use ``nvcc -ccbin icpc`` to compile your source code with
the Intel C++ compiler ``icpc``, e.g.:

::

   nvcc -ccbin icpc -o cuda_test.x cuda_test.cu


Compiling OpenACC code
~~~~~~~~~~~~~~~~~~~~~~

OpenACC is a directive-based approach to introducing parallelism into
either C/C++ or Fortran codes. A code with OpenACC directives may be
compiled via:

::

  $ module load nvidia/nvhpc
  $ nvc program.c

or

::

  $ nvc++ program.cpp

Note that ``nvc`` and ``nvc++`` are distinct from the NVIDIA CUDA compiler
``nvcc``. They provide a way to compile standard C or C++ programs without
explicit CUDA content. See ``man nvc`` or ``man nvc++`` for further details.


CUDA Fortran
~~~~~~~~~~~~

CUDA Fortran provides extensions to standard Fortran which allow GPU
functionality to be used. CUDA Fortran files (with file extension ``.cuf``)
may be compiled with the NVIDIA Fortran compiler:

::

  $ module load nvidia/nvhpc
  $ nvfortran program.cuf

See ``man nvfortran`` for further details.


Submitting jobs to the GPU nodes
--------------------------------

To run a GPU job, a SLURM submission must specify a GPU partition and
quality of service, and the number of GPUs required.
You specify the number of GPU cards you want using the ``--gres=gpu:N``
where ``N`` is typically 1, 2 or 4.

.. note::

   As there are 4 GPUs per node, each GPU is associated with 1/4 of the
   resources of the node, i.e., 10/40 physical cores and roughly 91/384 GB in
   host memory.
   Allocations of host resources are made pro-rata by ``sbatch`` on this basis.

For example, if 2 GPUs are requested, ``sbatch`` will allocate 20 cores
and around 190 GB of host memory (in addition to 2 GPUs). Any attempt to
use more than the allocated resources will result in an error.

This automatic allocation by SLURM for GPU jobs means that the
submission script should not specify options such as ``--ntasks`` and
``--cpus-per-task`` via ``sbatch``. Such a job submission will be
rejected. See below for some examples of how to use host resources and how to
launch MPI applications.

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
of relevant GPU partitions on Cirrus:

.. list-table:: Cirrus Partitions
   :widths: 30 50 20
   :header-rows: 1

   * - Partition
     - Description
     - Maximum Job Size (Nodes)
   * - gpu-cascade
     - GPU nodes with Cascade Lake processors
     - 36
   * - gpu-skylake
     - GPU nodes with Skylake processors
     - 2

Quality of Service (QoS)
~~~~~~~~~~~~~~~~~~~~~~~~
Your job script must specify a QoS relevant for the GPU nodes. Available
QoS specifications are:


.. list-table:: GPU QoS
   :header-rows: 1

   * - QoS Name
     - Jobs Running Per User
     - Jobs Queued Per User
     - Max Walltime
     - Max Size
     - GPU Partition
   * - gpu
     - No limit
     - 128 jobs
     - 4 days
     - 64 GPUs
     - gpu-skylake, gpu-cascade
   * - long
     - 5 jobs
     - 20 jobs
     - 14 days
     - 8 GPUs
     - gpu-cascade
   * - short
     - 1 job
     - 2 jobs
     - 20 minutes
     - 4 GPUs or 2 nodes
     - gpu-skylake


Examples
--------
   
Job submission script using single GPU on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that requires 1 GPU accelerator and 10 CPU cores for 20 minutes
might look like:

::

   #!/bin/bash
   #
   #SBATCH --partition=gpu-cascade
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
threads via OpenMP, e.g.,

::

  export OMP_NUM_THREADS=10
  export OMP_PLACES=cores

  srun --ntasks=1 --cpus-per-task=10 --hint=nomultithread ./cuda_test.x

Note here we have specified the launch configuration directly to ``srun``
as it is not possible to do it via ``sbatch`` in the GPU partitions.


Job submission script using multiple GPUs on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that required 4 GPU accelerators and 40 CPU cores for 20 minutes
could look like:

::

    #!/bin/bash
    #
    #SBATCH --partition=gpu-cascade
    #SBATCH --qos=gpu
    #SBATCH --gres=gpu:4
    #SBATCH --time=00:20:00

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]
    
    # Load the required modules 
    module load nvidia/nvhpc

    srun ./cuda_test.x

A typical MPI application might assign one device per MPI process, in
which case we would want 4 MPI tasks in this example. This would be
specified again directly to ``srun`` via

::

   srun --ntasks=4 ./mpi_cuda_test.x


Job submission script using multiple GPUs on multiple nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that required 8 GPU accelerators for 20 minutes
could look like:

::

    #!/bin/bash
    #
    #SBATCH --partition=gpu-cascade
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

An MPI application with four MPI tasks per node in this case would be
launched via

::

  srun --ntasks=8 --tasks-per-node=4 ./mpi_cuda_test.x

Again, these options are specified directly to ``srun``, and not ``sbatch``.


Attempts to oversubscribe an allocation (10 cores per GPU) will fail, and
generate an error message, e.g.:

::

  srun: error: Unable to create step for job 234123: More processors requested
  than permitted


Debugging GPU applications
--------------------------

Applications may be debugged using ``cuda-gdb``. This is an extension
of ``gdb`` which can be used with CUDA. We assume the reader is
familiar with ``gdb``.

Compile the application with the ``-g -G`` flags to retain debugging
information. Obtain an interactive session, e.g.:

::

  $ srun --nodes=1 --partition=gpu-cascade --qos=gpu --gres=gpu:1 \
         --time=01:00:00 --pty /bin/bash

Load the NVIDIA HPC SDK module and start ``cuda-gdb`` for your application
via

::

  $ module load nvidia/nvhpc
  $ cuda-gdb ./my-application.x
  NVIDIA (R) CUDA Debugger
  ...
  (cuda-gdb) 

Debugging then proceeds as usual.
One can use the help facility from the ``cuda-gdb`` to find details
of commands available.

Note: it may be necessary to set the temporary directory to somewhere in
the user space, e.g.,

::

  export TMPDIR=$(pwd)/tmp

to prevent unexpected internal CUDA driver errors.

For further information on CUDA-GDB see https://docs.nvidia.com/cuda/cuda-gdb/index.html.


Profiling GPU applications
--------------------------

NVIDIA provide two useful tools for profiling performance of applications:
Nsight Systems and Nsight Compute; the former provides an overview of
application performance, while the latter provides detailed information
specifically on GPU kernels.

Using Nsight Systems
~~~~~~~~~~~~~~~~~~~~

Nsight Systems provides an overview of application performance, and should
therefore be the starting point for investigation. To run an application,
compile as normal (including the ``-g`` flag) and then submit to the queue
system, e.g.,

::

  #!/bin/bash
  
  #SBATCH --time=00:10:00
  #SBATCH --nodes=1
  #SBATCH --exclusive
  
  #SBATCH --partition=gpu-cascade
  #SBATCH --qos=gpu
  #SBATCH --gres=gpu:1
  
  module load nvidia/nvhpc
  
  srun -n 1 nsys profile -o prof1 ./my_application.x

The run should then produce an additional output file called, in this
case, ``prof1.qdrep``. The recommended way to view the contents
of this file is to download the NVIDIA Nsight package to your own
machine (you do not need the entire HPC SDK). Then copy the ``.qdrep``
file produced on Cirrus so that if can be viewed locally.

Note that a profiling run should probably be of a short duration
so that the profile information (the ``.qdrep file``) does not become
prohibitively large.

Details of the download of Nsight Systems and a user guide can be found at
the links:

https://developer.nvidia.com/nsight-systems

https://docs.nvidia.com/nsight-systems/UserGuide/index.html


Using Nsight Compute
~~~~~~~~~~~~~~~~~~~~

Nsight Compute may be used in a simliar way as Nsight Systems. A job may
be submitted with, e.g.,


::

  #!/bin/bash
  
  #SBATCH --time=00:10:00
  #SBATCH --nodes=1
  #SBATCH --exclusive
  
  #SBATCH --partition=gpu-cascade
  #SBATCH --qos=gpu
  #SBATCH --gres=gpu:1
  
  module load nvidia/nvhpc
  
  srun -n 1 nv-nsight-cu-cli --section SpeedOfLight_RooflineChart \
                             -o prof2 -f ./my_application.x

In this case, a file ``prof2.ncu-rep`` should be produced. Again, the
recommended way to view this file is to downloaded the Nsight Compute
package to your own machine, along with the ``.ncu-rep`` file from Cirrus.
The ``--section`` option determines the details of which statistics are
recorded (typically not all hardware counters can be accessed at the
same time). A common starting point is ``--section MemoryWorkloadAnalysis``.
Consult the NVIDIA documentation for further details.

Details are available at, e.g.,

https://developer.nvidia.com/nsight-compute

https://docs.nvidia.com/nsight-compute/2021.2/index.html
