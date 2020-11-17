Using the Cirrus GPU Nodes
==========================

Cirrus has 38 compute nodes equipped with GPGPU accelerators. This section of the user
guide explains how to compile code and submit jobs to the GPU nodes.

.. note::

        The GPU accelerators on Cirrus are only available in TCC (Tesla Compute Cluster)
        mode and so do not support graphics rendering tasks, only computational tasks.

Hardware details
----------------

36 of the Cirrus GPU compute nodes each contain two 2.5 GHz, 20-core Intel Xeon Gold
6248 (Cascade Lake) series processors. Each of the cores in these
processors support 2 hardware threads (Hyperthreads), which are enabled
by default. The nodes also each contain four NVIDIA Tesla V100-SXM2-16GB
(Volta) GPU accelerators connected to the host processors and each other
via PCIe. These nodes are available in the `gpu-cascade` partition. This
partition has a total of 144 GPU accelerators and 1440 CPU cores.

Two of the Cirrus GPU compute nodes each contain two 2.4 GHz, 20-core Intel Xeon Gold
6148 (Skylake) series processors. Each of the cores in these
processors support 2 hardware threads (Hyperthreads), which are enabled
by default. The nodes also each contain four NVIDIA Tesla V100-SXM2-16GB
(Volta) GPU accelerators connected to the host processors and each other
via PCIe. These nodes are available in the `gpu-skylake` partition. This
partition has a total of 8 GPU accelerators and 80 CPU cores. 

All of the GPU compute nodes on Cirrus have 384 GB of main memory shared between
the two processors. The memory is arranged in a non-uniform access (NUMA) form:
each 20-core processor is a single NUMA region with local memory of 192
GB. Access to the local memory by cores within a NUMA region has a lower
latency and higher bandwidth than accessing memory on the other NUMA region.

There are three levels of cache, configured as follows:

* L1 Cache 32 KiB Instr., 32 KiB Data (per core)
* L2 Cache 1 GiB (per core)
* L3 Cache GiB MB (shared)

Each GPU accelerator has 16 GiB of fast GPU memory.


Compiling software for the GPU nodes
------------------------------------

.. note::

   As the Cirrus login nodes use Intel Xeon Broadwell processors and the GPU compute nodes
   are equipped with Intel Xeon Sylake or Cascade Lake processors, additional flags are needed to compile
   code for the correct processors. These flags are described in the different compiler 
   suites below.


CUDA
~~~~

`CUDA <https://developer.nvidia.com/cuda-zone>`_ is a parallel computing platform and
programming model developed by NVIDIA for general computing on graphical processing units (GPUs).

To use the CUDA toolkit on Cirrus, you should load one of the `cuda` modules, e.g:

::

   module load nvidia/cuda-10.2

Once you have loaded the ``cuda`` module, you can access the CUDA compiler with the ``nvcc`` command.

As well as the CUDA compiler, you will also need a compiler module to support compilation of the
host (CPU) code. The CUDA toolkit supports both GCC and Intel compilers. You should load your
chosen compiler module before you compile.

..  The ``nvcc`` compiler currently supports versions of GCC up to 6.x and versions of the Intel compilers up to 17.x.

Using CUDA with GCC
^^^^^^^^^^^^^^^^^^^

When compiling using ``nvcc`` we recommend that you load a recent version of GCC to support the CUDA compiler, e.g.

::

   module load gcc/6.3.0

..  GCC 6.x is the latest version of the GCC compiler supported by ``nvcc``.

You can now use ``nvcc`` to compile your source code, e.g.:

::

   nvcc -march=skylake-avx512 -o cuda_test.x cuda_test.cu

.. note::

   When compiling using GCC for the CPUs on the GPU compute nodes you should add the flag
   ``-march=skylake-avx512`` to get the correct instructions for the Skylake processors.

Using CUDA with Intel compilers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You should load either the Intel 18 or Intel 19 compilers to use with `nvcc`.

..  We recommend the Intel 17 compilers, you also need the ``gcc`` module to provide C++ support:

::

   module load intel-compilers-18

.. Intel 17 is the latest version of the Intel compilers supported by ``nvcc``.

You can now use ``nvcc -ccbin icpc`` to compile your source code, e.g.:

::

   nvcc -ccbin icpc -xCore-AVX512 -qopt-zmm-usage=high -o cuda_test.x cuda_test.cu

The ``-ccbin icpc`` tells ``nvcc`` to use the Intel C++ compiler to compile the host (CPU)
code.

.. note:: When compiling using Intel compilers for the CPUs on the GPU compute nodes you should add the flag ``-xCore-AVX512 -qopt-zmm-usage=high`` to get the correct instructions for the Skylake processors


OpenACC
~~~~~~~

OpenACC is a directive-based approach to introducing parallelism into
either C or Fortran codes. A code with OpenACC directives may be
compiled via:

::

  $ module load nvidia/compilers-20.5
  $ module load gcc
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

  $ module load nvidia/compilers-20.5
  $ module load gcc
  $ nvfortran program.cuf

See ``man nvfortran`` for further details.


Submitting jobs to the GPU nodes
--------------------------------

To run a GPU job, a SLURM submission needs to specify a GPU partition and
quality of service, and the number of GPUs required.
You specify the number of GPUs you want using the ``--gres=gpu:N`` option:

 * ``--gres=gpu:N`` (where ``N`` is the number of GPU accelerators you wish to use). This resource 
   request needs to be added to your Slurm script.

.. note::

   As there are 4 GPUs per node, each GPU is associated with 1/4 of the
   resources of the node, i.e., 10/40 physical cores and roughly 91/384 GB in
   main memory.
   Allocations of host resources are made pro-rata by ``sbatch`` on this basis.

For example, if 2 GPUs are requested, ``sbatch`` will allocate 20 cores
and around 190 GB of host memory (in addition to 2 GPUs). Any attempt to
use more than the allocated resources will result in an error.

This automatic allocation by SLURM for GPU jobs means that the
submission script should not specify options such as ``--ntasks`` and
``--cpus-per-task`` via ``sbatch``. Such a job submission will be
rejected.

See below for some examples of how to use host resources and how to
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

Compute nodes are grouped into partitions. You will have to specify a partition
using the ``--partition`` option in your submission script. The following table has a list 
of active GPU partitions on Cirrus.

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

Quality of Service (QoS) is used alongside the partition to control how work
is allocated to the available resources. There is only one relevant QoS
for GPU jobs:

.. list-table::
   :widths: 20 20 20 40
   :header-rows: 1

   * - QoS
     - Description
     - Maximum Walltime
     - Other Limits
   * - gpu
     - GPU QoS
     - 96 hours
     - max. 16 GPUs per user, max. 10 jobs running per user, max. 50 jobs queued per user


Examples
--------
   
Job submission script using single GPU on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that requires 1 GPU accelerator and 10 CPU cores for 20 minutes
might look like:

::

   #!/bin/bash
   #
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=CUDA_Example
   #SBATCH --time=0:20:0
   #SBATCH --partition=gpu-cascade
   #SBATCH --qos=gpu
   #SBATCH --gres=gpu:1

   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
     
   # Load the required modules 
   module load nvidia/cuda-10.2
   
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

.. note:: Remember that there are a maximum of 4 GPU accelerators per node and a maximum of 40 CPU cores per node.

A job script that required 4 GPU accelerators and 40 CPU cores for 20 minutes
could look like:

::

    #!/bin/bash
    #
    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=CUDA_Example
    #SBATCH --time=0:20:0
    #SBATCH --partition=gpu-cascade
    #SBATCH --qos=gpu
    #SBATCH --gres=gpu:4

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]
    
    # Load the required modules 
    module load nvidia/cuda-10.2


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
    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=CUDA_Example
    #SBATCH --time=0:20:0
    #SBATCH --partition=gpu-cascade
    #SBATCH --nodes=2
    #SBATCH --exclusive
    #SBATCH --qos=gpu
    #SBATCH --gres=gpu:4

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]
    
    # Load the required modules 
    module load nvidia/cuda-10.2


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
