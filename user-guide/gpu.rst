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


Submitting jobs to the GPU nodes
--------------------------------

Instead of requesting nodes and CPU cores as you do for standard jobs, you request 
the number of GPUs you require and the system automatically allocates the correct
proportion of tasks (CPU cores) to match the number of GPUs you have requested.
You specify the number of GPUs you want using the ``--gres=gpu:N`` option:

 * ``--gres=gpu:N`` (where ``N`` is the number of GPU accelerators you wish to use). This resource 
   request needs to be added to your Slurm script.

.. note::

   You will be allocated 10 CPU cores and one quarter of the node memory
   (~9.1 GB) per GPU that you request. If you specify the ``--exclusive`` option,
   you will be allocated all CPU cores and memory from the node irrespective
   of how many GPUs you request.


Job submission script using single GPU on a single node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A job script that required 1 GPU accelerator and 10 CPU cores for 20 minutes
could look like:

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



Job submission script using multiple GPUs on multiple nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. info::

   Information on running multi-node GPU jobs will be added shortly.
