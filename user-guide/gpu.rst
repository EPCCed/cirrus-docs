Using the Cirrus GPU Nodes
==========================

Cirrus has two compute nodes equipped with GPGPU accelerators. This section of the user
guide explains how to compile code and submit jobs to the GPU nodes.

.. note::

        The GPU accelerators on Cirrus are only available in TCC (Tesla Compute Cluster)
        mode and so do not support graphics rendering tasks, only computational tasks.

Hardware details
----------------

The Cirrus GPU compute nodes each contain two 2.4 GHz, 20-core Intel Xeon Gold
6148 (Skylake) series processers. Each of the cores in these
processors support 2 hardware threads (Hyperthreads), which are enabled
by default. The nodes also each contain four NVIDIA Tesla V100-SXM2-16GB
(Volta) GPU accelerators connected to the host processors and each other
via PCIe.

The GPU compute nodes on Cirrus have 384 GB of main memory shared between
the two processors. The memory is arranged in a non-uniform access (NUMA) form:
each 20-core processor is a single NUMA region with local memory of 192
GB. Access to the local memory by cores within a NUMA region has a lower
latency and higher bandwidth than accessing memory on the other NUMA region.

There are three levels of cache, configured as follows:

* L1 Cache 32 KiB Instr., 32 KiB Data (per core)
* L2 Cache 1 GiB (per core)
* L3 Cache GiB MB (shared)

Each GPU accelerator has 16 GiB of fast GPU memory.

There are 2 GPU compute nodes on Cirrus giving a total of 80 CPU cores
and 8 GPU accelerators.

Compiling software for the GPU nodes
------------------------------------

.. note::

   As the Cirrus login nodes use Intel Xeon Broadwell processors and the GPU compute nodes
   are equipped with Intel Xeon Sylake processers additional flags are needed to compile
   code for the correct processors. These flags are described in the different compiler 
   suites below.


CUDA
~~~~

`CUDA <https://developer.nvidia.com/cuda-zone>`_ is a parallel computing platform and
programming model developed by NVIDIA for general computing on graphical processing units (GPUs).

To use the CUDA toolkit on Cirrus, you should load the `cuda` module:

::

   module load cuda

Once you have loaded the ``cuda`` module, you can access the CUDA compiler with the ``nvcc`` command.

As well as the CUDA compiler, you will also need a compiler module to support compilation of the
host (CPU) code. The CUDA toolkit supports both GCC and Intel compilers. You should load your
chosen compiler module before you compile.

.. note:: The ``nvcc`` compiler currently supports versions of GCC up to 6.x and versions of the Intel compilers up to 17.x.

Using CUDA with GCC
^^^^^^^^^^^^^^^^^^^

By default, ``nvcc`` will use the system version of GCC. We recommend that you load a more
recent version of GCC than the system default to support the CUDA compiler, e.g.

::

   module load gcc/6.3.0

.. note:: GCC 6.x is the latest version of the GCC compiler supported by ``nvcc``.

You can now use ``nvcc`` to compile your source code, e.g.:

::

   nvcc -o cuda_test.x cuda_test.cu

.. note::

   When compiling using GCC for the CPUs on the GPU compute nodes you should add the flag
   ``-march=skylake-avx512`` to get the correct instructions for the Skylake processors.

Using CUDA with Intel compilers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You should load either the Intel 16 or Intel 17 compilers to use with `nvcc`. We recommend the
Intel 17 compilers, you also need the ``gcc`` module to provide C++ support:

::

   module load intel-compilers-17
   module load gcc/6.3.0

.. note:: Intel 17 is the latest version of the Intel compilers supported by ``nvcc``.

You can now use ``nvcc -ccbin icpc`` to compile your source code, e.g.:

::

   nvcc -ccbin icpc -o cuda_test.x cuda_test.cu

The ``-ccbin icpc`` tells ``nvcc`` to use the Intel C++ compiler to compile the host (CPU)
code.

.. note:: When compiling using Intel compilers for the CPUs on the GPU compute nodes you should add the flag ``-xCore-AVX512 -qopt-zmm-usage=high`` to get the correct instructions for the Skylake processors


Submitting jobs to the GPU nodes
--------------------------------

Two additional options are needed in GPU job submission scripts over those in standard jobs:

 * ``-q gpu`` This option is required to submit the job to the ``gpu`` queue on Cirrus
 * ``ngpus=N`` (where ``N`` is the number of GPU accelerators you wish to use). This resource 
   request needs to be added to your ``select`` statement

.. note:: We generally recommend that you should request 10 CPU cores per GPU accelerator even if you do not need them.

Job submission script using single GPU on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that required 1 GPU accelerator and 10 CPU cores for 20 minutes
could look like:

::

   #!/bin/bash
   #
   #PBS -N cuda_test
   #PBS -q gpu
   #PBS -l select=1:ncpus=10:ngpus=1
   #PBS -l walltime=0:20:0
   # Budget: change 't01' to your budget code
   #PBS -A t01

   # Load the required modules (this assumes you compiled with GCC 6.3.0)
   module load cuda
   module load gcc/6.3.0

   cd $PBS_O_WORKDIR

   ./cuda_test.x

The line ``#PBS -l select=1:ncpus=10:ngpus=1`` requests 1 node, 10 cores on that node and 1 GPU
accelerator on that node.

Job submission script using multiple GPUs on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note:: Remember that there are a maximum of 4 GPU accelerators per node and a maximum of 40 CPU cores per node.

A job script that required 4 GPU accelerators and 40 CPU cores for 20 minutes
could look like:

::

   #!/bin/bash
   #
   #PBS -N cuda_test
   #PBS -q gpu
   #PBS -l select=1:ncpus=40:ngpus=4
   #PBS -l walltime=0:20:0
   # Budget: change 't01' to your budget code
   #PBS -A t01

   # Load the required modules (this assumes you compiled with GCC 6.3.0)
   module load cuda
   module load gcc/6.3.0

   cd $PBS_O_WORKDIR

   ./cuda_test.x

The line ``#PBS -l select=1:ncpus=40:ngpus=4`` requests 1 node, 40 cores on that node and 4 GPU
accelerators on that node (i.e. a full GPU compute node).

Job submission script using multiple GPUs on multiple nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note:: Remember that there are a maximum of 4 GPU accelerators per node and a maximum of 40 CPU cores per node.

A job script that required 8 GPU accelerators and 80 CPU cores for 20 minutes across 2 nodes
could look like:

::

   #!/bin/bash
   #
   #PBS -N cuda_test
   #PBS -q gpu
   #PBS -l select=2:ncpus=40:ngpus=4
   #PBS -l walltime=0:20:0
   # Budget: change 't01' to your budget code
   #PBS -A t01

   # Load the required modules (this assumes you compiled with GCC 6.3.0)
   module load cuda
   module load gcc/6.3.0
   module load mpt

   cd $PBS_O_WORKDIR

   mpirun -n 80 -ppn 40 ./cuda_test.x

The line ``#PBS -l select=2:ncpus=40:ngpus=4`` requests 2 nodes, 40 cores per node (80 in total)
and 4 GPU accelerators per node (8 in total).
