Using Python
============

Python on Cirrus is provided by a number of `Miniconda <https://conda.io/miniconda.html>`__ modules and one `Anaconda <https://www.continuum.io>`__ module.
(Miniconda being a small bootstrap version of Anaconda).

The Anaconda module is called ``anaconda/python3`` and is suitable for running serial applications.

You can list the Miniconda modules by running ``module avail python`` on a login node. Those module versions that have the ``gpu`` suffix are
suitable for use on the `Cirrus GPU nodes <gpu.html>`__. There are also modules that extend these Python environments, e.g., ``pyfr``, ``horovod``,
``tensorflow`` and ``pytorch`` - simply run ``module help <module name>`` for further info.

The Miniconda modules support Python-based parallel codes, i.e., each such ``python`` module provides a suite of packages
pertinent to parallel processing and numerical analysis such as ``dask``, ``ipyparallel``, ``jupyter``, ``matplotlib``, ``numpy``, ``pandas`` and ``scipy``.

All the packages provided by a module can be obtained by running ``pip list``. We now give some examples that show how the ``python``
modules can be used on the Cirrus CPU/GPU nodes.


mpi4py for CPU
--------------

The ``python/3.9.13`` module provides mpi4py 3.1.3 linked with OpenMPI 4.1.4.

The scripts below demonstrate how to run a simple MPI Broadcast example (``numpy-broadcast.py``)
across two compute nodes.

.. raw:: html

    <details><summary><b>numpy-broadcast.py</b></summary>

.. code-block:: python

    #!/usr/bin/env python

    """
    Parallel Numpy Array Broadcast 
    """

    import mpi4py.rc
    mpi4py.rc.initialize = False

    from mpi4py import MPI
    import numpy as np
    import sys

    MPI.Init()

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

    MPI.Finalize()

.. raw:: html

    </details>


The purpose of the ``mpi4py.rc.initialize = False`` line above is to turn off the automatic MPI initialization
that would otherwise happen as a result of ``from mpi4py import MPI`` - the MPI initialization is invoked explicitly
by calling ``MPI.Init()``.

.. raw:: html

    <details><summary><b>submit-broadcast.ll</b></summary>

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

    </details>

The Slurm submission script (``submit-broadcast.ll``) above sets a ``OMPI_MCA`` environment variable before launching the job.
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

    import mpi4py.rc
    mpi4py.rc.initialize = False

    from mpi4py import MPI
    import cupy as cp
    import sys

    MPI.Init()

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

    MPI.Finalize()

.. raw:: html

    </details>

By default, the CuPy cache will be located within the user's home directory.
And so, as ``/home`` is not accessible from the GPU nodes, it is necessary to set
``CUPY_CACHE_DIR`` such that the cache is on the ``/work`` file system instead.

.. raw:: html

    <details><summary><b>submit-allreduce.ll</b></summary>

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

    </details>

Again, the submission script (``submit-allreduce.ll``) is the place to set ``OMPI_MCA`` variables - the two
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

.. note::

  The Cirrus compute nodes cannot access the ``/home`` file system, which means you may need to run
  ``export XDG_CACHE_HOME=${HOME/home/work}`` if you're working from within an interactive session as
  that export command will ensure the pip cache is located off ``/work``.

Please click on the link indicated to see examples of how to use the `PyTorch and TensorFlow modules <https://github.com/hpc-uk/build-instructions/blob/main/pyenvs/horovod/run_horovod_0.25.0_cirrus_gpu.md>`__ .


Installing your own Python packages (with pip)
----------------------------------------------

This section shows how to setup a local custom Python environment such that it extends a centrally-installed Miniconda module.
By extend, we mean being able to install packages locally that are not provided by the Miniconda module. This is needed because
some packages such as ``mpi4py`` must be built specifically for the Cirrus system and so are best provided centrally.

The first action to take is to decide which ``python`` module to extend, e.g., ``python/3.9.13-gpu`` (you can run
``module avail python`` to list all the available ``python`` modules).

.. code-block:: bash

    [auser@cirrus-login1 auser]$ module load python/3.9.13-gpu

Loading the python module above will set a number of environment variables such as ``MINICONDA3_PYTHON_VERSION`` and
``MINICONDA3_PYTHON_LABEL``. This can be confirmed by looking at the output from ``module show python/3.9.13-gpu``.

.. code-block:: bash

    /mnt/lustre/indy2lfs/sw/modulefiles/python/3.9.13-gpu:

    conflict	python
    setenv	MINICONDA3_PYTHON_VERSION 3.9.13
    setenv      MINICONDA3_PYTHON_LABEL python3.9
    ...
    setenv	MINICONDA3_BIN_PATH /mnt/lustre/indy2lfs/sw/miniconda3/4.12.0-py39-gpu/bin

The *local* packages will be installed using ``pip``. Now, as the ``/home`` file system is not available on the compute nodes,
you will need to modify the default install location that ``pip`` uses to point to a location on ``/work``. To do this, you set
the ``PYTHONUSERBASE`` environment variable to point to the location on ``/work`` where you intend to install your local virtual
Python environment, which we are calling ``myvenv`` for purposes of illustration.

.. code-block:: bash

    export PYTHONUSERBASE=/work/x01/x01/auser/myvenv

.. note::

  The path above uses a fictitious project code, ``x01``, and username, ``auser``. Please remember to replace those values
  with your actual project code and username. Alternatively, you could enter ``${HOME/home/work}`` in place of ``/work/x01/x01/auser``.
  That command fragment expands ``${HOME}`` and then replaces the ``home`` part with ``work``.

You will also need to ensure that:

1. the location of executables installed by ``pip`` are available on the command line by modifying the ``PATH`` environment variable;
2. any packages you install are available to Python by modifying the ``PYTHONPATH`` environment variable.

You can do this in the following way (once you have set ``PYTHONUSERBASE`` as described above).

.. code-block:: bash

    export PATH=${PYTHONUSERBASE}/bin:${PATH}
    export PYTHONPATH=${PYTHONUSERBASE}/lib/${MINICONDA3_PYTHON_LABEL}/site-packages:${PYTHONPATH}

Once, you have done this, you can use ``pip`` to add packages on top of the centrally-installed Miniconda environment.

.. code-block:: bash

    pip install --user <package_name>

The ``--user`` flag ensures that packages are installed in the directory specified by ``PYTHONUSERBASE``.

However, before you start installing packages, we recommend that you first install ``virtualenv`` (or ``pipenv`` if you prefer).
We will walk you through how to create and manage a virtual environment, but for further information, see `Pipenv and Virtual Environments <https://docs.python-guide.org/dev/virtualenvs/>`__.

.. code-block:: bash

    pip install --user virtualenv

Next, you point ``virtualenv`` at the location where your local environment is to be installed.

.. code-block:: bash

    virtualenv -p ${MINICONDA3_BIN_PATH}/python ${PYTHONUSERBASE}

    extend-venv-activate ${PYTHONUSERBASE}

The ``virtualenv`` command creates an activate script for your local environment. The second command, ``extend-venv-activate``, amends that script such
that the centrally-installed ``python`` module is always loaded in subsequent login sessions or job submissions, and unloaded whenever the virtual
environment is deactivated.

You're now ready to *activate* your environment.

.. code-block:: bash

    source /work/x01/x01/auser/myvenv/bin/activate

Once your environment is activated you will be able to install packages using ``pip install <package name>``. Note, it is no longer necessary to use the ``--user`` option
as activating the virtual environment ensures that all new packages are installed within ``/work/x01/x01/auser/myvenv``. And when you have finished installing packages,
you can deactivate your environment by issuing the `deactivate` command.

.. code-block:: bash

    (myvenv) [auser@cirrus-login1 auser]$ deactivate
    [auser@cirrus-login1 auser]$

The packages you have just installed locally will only be available once the local environment has been activated. So, when running code that requires these packages,
you must first activate the environment, by adding the activation command to the submission script, as shown below.

.. raw:: html

    <details><summary><b>submit-myvenv.ll</b></summary>

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

    </details>

Lastly, the environment being extended does not have to come from one of the centrally-installed ``python`` modules.
You could just as easily create a local virtual environment based on one of the Machine Learning (ML) modules, e.g., ``horovod``,
``tensorflow`` or ``pytorch``. This means you would avoid having to install ML packages within your local area. Each of those ML
modules is based on a ``python`` module. For example, ``tensorflow/2.11.0-gpu`` is itself an extension of ``python/3.10.8-gpu``
(and so the ``MINICONDA3_PYTHON_VERSION`` environment variable will be set to ``3.10.8``).


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
