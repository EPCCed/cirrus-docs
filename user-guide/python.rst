Using Python
============

Python on Cirrus is provided by a number of `Miniconda <https://conda.io/miniconda.html>`__ modules and one `Anaconda <https://www.continuum.io>`__ module.
(Miniconda being a small bootstrap version of Anaconda).

The Anaconda module is called ``anaconda/python3`` and is suitable for
running serial applications - for parallel applications using
``mpi4py`` see `mpi4py for CPU`_ or `mpi4py for GPU`_.

You can list the Miniconda modules by running ``module avail python`` on a login node. Those module versions that have the ``gpu`` suffix are
suitable for use on the `Cirrus GPU nodes <gpu.html>`__. There are also modules that extend these Python environments, e.g., ``pyfr``, ``horovod``,
``tensorflow`` and ``pytorch`` - simply run ``module help <module name>`` for further info.

The Miniconda modules support Python-based parallel codes, i.e., each such ``python`` module provides a suite of packages
pertinent to parallel processing and numerical analysis such as ``dask``, ``ipyparallel``, ``jupyter``, ``matplotlib``, ``numpy``, ``pandas`` and ``scipy``.

All the packages provided by a module can be obtained by running ``pip
list``. We now give some examples that show how the ``python`` modules
can be used on the Cirrus CPU/GPU nodes.


mpi4py for CPU
--------------

The ``python/3.9.13`` module provides mpi4py 3.1.3 linked with OpenMPI 4.1.4.

See ``numpy-broadcast.py`` below which is a simple MPI Broadcast
example, and the Slurm script ``submit-broadcast.slurm`` which
demonstrates how to run across it two compute nodes.

.. raw:: html

    <details><summary><b>numpy-broadcast.py</b></summary>

.. code-block:: python

    #!/usr/bin/env python

    """
    Parallel Numpy Array Broadcast 
    """

    from mpi4py import MPI
    import numpy as np
    import sys

    comm = MPI.COMM_WORLD

    size = comm.Get_size()
    rank = comm.Get_rank()
    name = MPI.Get_processor_name()

    arraySize = 100
    if rank == 0:
        data = np.arange(arraySize, dtype='i')
    else:
        data = np.empty(arraySize, dtype='i')

    comm.Bcast(data, root=0)

    if rank == 0:
        sys.stdout.write(
            "Rank %d of %d (%s) has broadcast %d integers.\n"
            % (rank, size, name, arraySize))
    else:
        sys.stdout.write(
            "Rank %d of %d (%s) has received %d integers.\n"
            % (rank, size, name, arraySize))

        arrayBad = False
        for i in range(100):
            if data[i] != i:
                arrayBad = True
                break

        if arrayBad:
            sys.stdout.write(
                "Error, rank %d array is not as expected.\n"
                % (rank))

.. raw:: html

    </details><br>

The MPI initialisation is done automatically as a result of calling ``from mpi4py import MPI``.

.. raw:: html

    <details><summary><b>submit-broadcast.slurm</b></summary>

.. code-block:: bash

    #!/bin/bash

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=broadcast
    #SBATCH --time=00:20:00
    #SBATCH --exclusive
    #SBATCH --partition=standard
    #SBATCH --qos=standard
    #SBATCH --account=[budget code]
    #SBATCH --nodes=2
    #SBATCH --tasks-per-node=36
    #SBATCH --cpus-per-task=1

    module load python/3.9.13

    export OMPI_MCA_mca_base_component_show_load_errors=0

    srun numpy-broadcast.py

.. raw:: html

    </details><br>

The Slurm submission script (``submit-broadcast.slurm``) above sets a ``OMPI_MCA`` environment variable before launching the job.
That particular variable suppresses warnings written to the job output file; it can of course be removed.
Please see the `OpenMPI documentation <https://www.open-mpi.org/faq/?category=tuning#mca-def>`__ for info on all ``OMPI_MCA`` variables.


mpi4py for GPU
--------------

There's also an mpi4py module (again using OpenMPI 4.1.4) that is tailored for CUDA 11.6 on the Cirrus
GPU nodes, ``python/3.9.13-gpu``. We show below an example that features an MPI reduction
performed on a `CuPy array <https://docs.cupy.dev/en/stable/overview.html>`__ (``cupy-allreduce.py``).

.. raw:: html

    <details><summary><b>cupy-allreduce.py</b></summary>

.. code-block:: python

    #!/usr/bin/env python
  
    """
    Reduce-to-all CuPy Arrays 
    """

    from mpi4py import MPI
    import cupy as cp
    import sys

    comm = MPI.COMM_WORLD

    size = comm.Get_size()
    rank = comm.Get_rank()
    name = MPI.Get_processor_name()

    sendbuf = cp.arange(10, dtype='i')
    recvbuf = cp.empty_like(sendbuf)
    assert hasattr(sendbuf, '__cuda_array_interface__')
    assert hasattr(recvbuf, '__cuda_array_interface__')
    cp.cuda.get_current_stream().synchronize()
    comm.Allreduce(sendbuf, recvbuf)

    assert cp.allclose(recvbuf, sendbuf*size)

    sys.stdout.write(
        "%d (%s): recvbuf = %s\n"
        % (rank, name, str(recvbuf)))

.. raw:: html

    </details><br>

By default, the CuPy cache will be located within the user's home directory.
And so, as ``/home`` is not accessible from the GPU nodes, it is necessary to set
``CUPY_CACHE_DIR`` such that the cache is on the ``/work`` file system instead.

.. raw:: html

    <details><summary><b>submit-allreduce.slurm</b></summary>

.. code-block:: bash

    #!/bin/bash
  
    #SBATCH --job-name=allreduce
    #SBATCH --time=00:20:00
    #SBATCH --exclusive
    #SBATCH --partition=gpu
    #SBATCH --qos=gpu
    #SBATCH --account=[budget code]
    #SBATCH --nodes=2
    #SBATCH --gres=gpu:4

    module load python/3.9.13-gpu

    export CUPY_CACHE_DIR=${HOME/home/work}/.cupy/kernel_cache

    export OMPI_MCA_mpi_warn_on_fork=0
    export OMPI_MCA_mca_base_component_show_load_errors=0

    srun --ntasks=8 --tasks-per-node=4 --cpus-per-task=1 cupy-allreduce.py

.. raw:: html

    </details><br>

Again, the submission script (``submit-allreduce.slurm``) is the place to set ``OMPI_MCA`` variables - the two
shown are optional, see the link below for further details.

https://www.open-mpi.org/faq/?category=tuning#mca-def


Machine Learning frameworks
---------------------------

There are several more Python-based modules that also target the Cirrus GPU nodes. These include two machine
learning frameworks, ``pytorch/1.12.1-gpu`` and ``tensorflow/2.9.1-gpu``. Both modules are Python virtual environments
that extend ``python/3.9.13-gpu``. The MPI comms is handled by the `Horovod <https://horovod.readthedocs.io/en/stable/>`__ 0.25.0
package along with the `NVIDIA Collective Communications Library <https://developer.nvidia.com/nccl>`__ v2.11.4.

A full package list for these environments can be obtained by loading the module of interest and then
running ``pip list``.

Please click on the link indicated to see examples of how to use the `PyTorch and TensorFlow modules <https://github.com/hpc-uk/build-instructions/blob/main/pyenvs/horovod/run_horovod_0.25.0_cirrus_gpu.md>`__ .


Installing your own Python packages (with pip)
----------------------------------------------

This section shows how to setup a local custom Python environment such that it extends a centrally-installed ``python`` module.
By extend, we mean being able to install packages locally that are not provided by the central ``python``. This is needed because
some packages such as ``mpi4py`` must be built specifically for the Cirrus system and so are best provided centrally.

You can do this by creating a lightweight **virtual** environment where the local packages can be installed. Further, this environment
is created on top of an existing Python installation, known as the environment's **base** Python.

Select the base Python by loading the ``python`` module you wish to extend, e.g., ``python/3.9.13-gpu`` (you can run
``module avail python`` to list all the available ``python`` modules).

.. code-block:: bash

    [auser@cirrus-login1 auser]$ module load python/3.9.13

Next, create the virtual environment within a designated folder.

.. code-block:: bash

    python -m venv --system-site-packages /work/x01/x01/auser/myvenv

In our example, the environment is created within a ``myvenv`` folder located on ``/work``, which means the environment
will be accessible from the compute nodes. The ``--system-site-packages`` option ensures that this environment is
based on the currently loaded ``python`` module. See https://docs.python.org/3/library/venv.html for more details.

.. code-block:: bash

    extend-venv-activate /work/x01/x01/auser/myvenv

The ``extend-venv-activate`` command ensures that your virtual environment's activate script loads and unloads the base
``python`` module when appropriate. You're now ready to activate your environment.

.. code-block:: bash

    source /work/x01/x01/auser/myvenv/bin/activate

.. note::

  The path above uses a fictitious project code, ``x01``, and username, ``auser``. Please remember to replace those values
  with your actual project code and username. Alternatively, you could enter ``${HOME/home/work}`` in place of ``/work/x01/x01/auser``.
  That command fragment expands ``${HOME}`` and then replaces the ``home`` part with ``work``.

Installing packages to your local environment can now be done as follows.

.. code-block:: bash

    (myvenv) [auser@cirrus-login1 auser]$ python -m pip install <package name>

Running ``pip`` directly as in ``pip install <package name>`` will also work, but we show the ``python -m`` approach
as this is consistent with the way the virtual environment was created. And when you have finished installing packages,
you can deactivate your environment by issuing the ``deactivate`` command.

.. code-block:: bash

    (myvenv) [auser@cirrus-login1 auser]$ deactivate
    [auser@cirrus-login1 auser]$

The packages you have just installed locally will only be available once the local environment has been activated. So, when running code that requires these packages,
you must first activate the environment, by adding the activation command to the submission script, as shown below.

.. raw:: html

    <details><summary><b>submit-myvenv.slurm</b></summary>

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=myvenv
    #SBATCH --time=00:20:00
    #SBATCH --exclusive
    #SBATCH --partition=gpu
    #SBATCH --qos=gpu
    #SBATCH --account=[budget code]
    #SBATCH --nodes=2
    #SBATCH --gres=gpu:4

    source /work/x01/x01/auser/myvenv/bin/activate

    srun --ntasks=8 --tasks-per-node=4 --cpus-per-task=10 myvenv-script.py

.. raw:: html

    </details><br>

Lastly, the environment being extended does not have to come from one of the centrally-installed ``python`` modules.
You could just as easily create a local virtual environment based on one of the Machine Learning (ML) modules, e.g., ``horovod``,
``tensorflow`` or ``pytorch``. This means you would avoid having to install ML packages within your local area. Each of those ML
modules is based on a ``python`` module. For example, ``tensorflow/2.11.0-gpu`` is itself an extension of ``python/3.10.8-gpu``.


Installing your own Python packages (with conda)
------------------------------------------------

This section shows you how to setup a local custom Python environment such that it duplicates a centrally-installed ``python`` module,
ensuring that your local ``conda`` environment will contain packages that are compatible with the Cirrus system.

Select the base Python by loading the ``python`` module you wish to duplicate, e.g., ``python/3.9.13-gpu`` (you can run
``module avail python`` to list all the available ``python`` modules).

.. code-block:: bash

    [auser@cirrus-login1 auser]$ module load python/3.9.13

Next, create the folder for holding your ``conda`` environments. This folder should be on the ``/work`` file system as ``/home`` is not
accessible from the compute nodes.

.. code-block:: bash

    CONDA_ROOT=/work/x01/x01/auser/condaenvs
    mkdir -p ${CONDA_ROOT}

The following commands tell ``conda`` where to save your custom environments and packages.

.. code-block:: bash

    conda config --prepend envs_dirs ${CONDA_ROOT}/envs
    conda config --prepend pkgs_dirs ${CONDA_ROOT}/pkgs

The ``conda config`` commands are executed just once and the configuration details are held in a ``.condarc`` file located
in your home directory. You now need to move this ``.condarc`` file to a directory visible from the compute nodes.

.. code-block:: bash

    mv ~/.condarc ${CONDA_ROOT}

You can now activate the ``conda`` configuration.

.. code-block:: bash

    export CONDARC=${CONDA_ROOT}/.condarc
    eval "$(conda shell.bash hook)"

These two lines need to be called each time you want to use your virtual ``conda`` environment. The next command creates
that virtual environment.

.. code-block:: bash

    conda create --clone base --name myvenv

The above creates an environment called ``myvenv`` that will hold the same packages provided by the base ``python`` module.
As this command involves a significant amount of file copying and downloading, it may take a long time to complete. When it
has completed please activate the local ``myvenv`` conda environment.

.. code-block:: bash

    conda activate myvenv

You can now install packages using ``conda install -p ${CONDA_ROOT}/envs/myvenv <package_name>``.
And you can see the packages currently installed in the active environment with the command ``conda list``.
After all packages have been installed, simply run ``conda deactivate`` twice in order to restore the original
comand prompt.

.. code-block:: bash

    (myvenv) [auser@cirrus-login1 auser]$ conda deactivate
    (base) [auser@cirrus-login1 auser]$ conda deactivate
    [auser@cirrus-login1 auser]$

The submission script below shows how to use the conda environment within a job running on the compute nodes.

.. raw:: html

    <details><summary><b>submit-myvenv.slurm</b></summary>

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=myvenv
    #SBATCH --time=00:20:00
    #SBATCH --exclusive
    #SBATCH --partition=gpu
    #SBATCH --qos=gpu
    #SBATCH --account=[budget code]
    #SBATCH --nodes=2
    #SBATCH --gres=gpu:4

    module load python/3.9.13

    CONDA_ROOT=/work/x01/x01/auser/condaenvs
    export CONDARC=${CONDA_ROOT}/.condarc
    eval "$(conda shell.bash hook)"

    conda activate myvenv

    srun --ntasks=8 --tasks-per-node=4 --cpus-per-task=10 myvenv-script.py

.. raw:: html

    </details><br>

You can see that using ``conda`` is less convenient compared to ``pip``. In particular, the centrally-installed Python
packages on copied in to the local ``conda`` environment, consuming some of the disk space allocated to your project.
Secondly, activating the ``conda`` environment within a submission script is more involved: five commands are required
(including an explicit load for the base ``python`` module), instead of the single ``source`` command that is sufficient
for a ``pip`` environment.

Further, ``conda`` cannot be used if the base environment is one of the Machine Learning (ML) modules, as ``conda``
is not flexible enough to gather Python packages from both the ML and base ``python`` modules (e.g., the ML module
``pytorch/2.0.0-gpu`` is itself based on ``python/3.10.8-gpu``, and so ``conda`` will only duplicate packages
provided by the ``python`` module and not the ones supplied by ``pytorch``). 


Using JupyterLab on Cirrus
--------------------------

It is possible to view and run JupyterLab on both the login and compute
nodes of Cirrus. Please note, you can test notebooks on the login nodes, but
please don’t attempt to run any computationally intensive work (such jobs will
be killed should they reach the login node CPU limit).

If you want to run your JupyterLab on a compute node, you will need to
enter an `interactive session <batch.html#interactive-jobs>`_; otherwise
you can start from a login node prompt.
 
1. As described above, load the Anaconda module on Cirrus using
   ``module load anaconda/python3``.

2. Run ``export JUPYTER_RUNTIME_DIR=$(pwd)``.

3. Start the JupyterLab server by running ``jupyter lab --ip=0.0.0.0 --no-browser``
   - once it’s started, you will see some lines resembling the following output.

   ::

     Or copy and paste one of these URLs:
         ...
      or http://127.0.0.1:8888/lab?token=<string>

   You will need the URL shown above for step 6.

4. Please skip this step if you are connecting from Windows. If you are
   connecting from Linux or macOS, open a new terminal window, and run the
   following command.

   ::
     
     ssh <username>@login.cirrus.ac.uk -L<port_number>:<node_id>:<port_number>

   where <username> is your username, <port_number> is as shown in the URL from
   the Jupyter output and <node_id> is the name of the node we’re currently on.
   On a login node, this will be ``cirrus-login1``, or similar; on a compute node,
   it will be a mix of numbers and letters such as ``r2i5n5``.

   .. note::
     If, when you connect in the new terminal, you see a message of the
     form `channel_setup_fwd_listener_tcpip: cannot listen to port: 8888`,
     it means port 8888 is already in use.
     You need to go back to step 3 (kill the existing jupyter lab) and retry
     with a new explicit port number by adding the ``--port=N`` option.
     The port number ``N`` can be in the range 5000-65535. You should
     then use the same port number in place of 8888.

5. Please skip this step if you are connecting from Linux or macOS. If you are
   connecting from Windows, you should use MobaXterm to configure an SSH tunnel
   as follows.

   5.1. Click on the ``Tunnelling`` button above the MobaXterm terminal. Create a new tunnel by clicking on ``New SSH tunnel`` in the window that opens.

   5.2. In the new window that opens, make sure the ``Local port forwarding`` radio button is selected.

   5.3. In the ``forwarded port`` text box on the left under ``My computer with MobaXterm``, enter the port number indicated in the Jupyter server output.

   5.4. In the three text boxes on the bottom right under ``SSH server`` enter ``login.cirrus.ac.uk``, your Cirrus username, and then ``22``.

   5.5. At the top right, under ``Remote server``, enter the name of the Cirrus login or compute node that you noted earlier followed by the port number (e.g. `8888`).

   5.6. Click on the ``Save`` button.

   5.7. In the tunnelling window, you will now see a new row for the settings you just entered. If you like, you can give a name to the tunnel in the leftmost column to identify it. Click on the small key icon close to the right for the new connection to tell MobaXterm which SSH private key to use when connecting to Cirrus. You should tell it to use the same ``.ppk`` private key that you normally use.

   5.8. The tunnel should now be configured. Click on the small start button (like a play ``>`` icon) for the new tunnel to open it. You'll be asked to enter your Cirrus password -- please do so.


6. Now, if you open a browser window on your local machine, you should be able to
   navigate to the URL from step 3, and this should display the JupyterLab server.

   - Please note, you will get a connection error if you haven't used the
     correct node name in step 4 or 5.

If you are on a compute node, the JupyterLab server will be available for the length of
the interactive session you have requested.

You can also run Jupyter sessions using the centrally-installed Miniconda3 modules available
on Cirrus. For example, the following link provides instructions for how to setup a Jupyter server
on a GPU node.

https://github.com/hpc-uk/build-instructions/tree/main/pyenvs/ipyparallel
