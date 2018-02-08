Singularity Containers
======================

This page was originally based on the documentation at the `University of Sheffield HPC service:
<http://docs.hpc.shef.ac.uk/en/latest/sharc/software/apps/singularity.html>`_.

Designed around the notion of mobility of compute and reproducible science,
Singularity enables users to have full control of their operating system environment.
This means that a non-privileged user can "swap out" the Linux operating system and 
environment on the host for a Linux OS and environment that they control.
So if the host system is running CentOS Linux but your application runs in Ubuntu Linux
with a particular software stack; you can create an Ubuntu image, install your software into that image,
copy the image to another host (e.g. Cirrus), and run your application on that host in it’s native Ubuntu
environment.

Singularity also allows you to leverage the resources of whatever host you are on.
This includes high-speed interconnects (i.e. Infinband on Cirrus),
file systems (i.e. /lustre on Cirrus) and potentially other resources (e.g. the
licensed Intel compilers on Cirrus).

Useful Links
------------

* `Singularity website <http://singularity.lbl.gov/>`_
* `Singularity user documentation <http://singularity.lbl.gov/user-guide>`_

About Singularity Containers (Images)
-------------------------------------

Similar to Docker,
a Singularity container (or, more commonly, *image*) is a self-contained software stack.
As Singularity does not require a root-level daemon to run its images (this
is required by Docker) it is suitable for use on a multi-user HPC system such as Cirrus.
Within the container/image, you have exactly the same permissions as you do in a
standard login session on the system.

In practice, this means that an image created on your local machine
with all your research software installed for local development
will also run on Cirrus.

Pre-built images (such as those on `DockerHub <http://hub.docker.com>`_ or
`SingularityHub <https://singularity-hub.org/>`_) can simply be downloaded
and used on Cirrus (or anywhere else Singularity is installed); see
:ref:`use_image_singularity`).

Creating and modifying images requires root permission and so
must be done on a system where you have such access (in practice, this is
usually within a virtual machine on your laptop/workstation); see
:ref:`create_image_singularity`.

.. _use_image_singularity:

Using Singularity Images on Cirrus
----------------------------------

Singularity images can be used on Cirrus in a number of ways, including:

* Interactively on the login nodes
* Interactively on compute nodes
* As serial processes within a non-interactive batch script
* As parallel processes within a non-interactive batch script (not yet documented)

We provide information on each of these scenarios (apart from the parallel use where 
we are still preparing the documentation) below. First, we describe briefly how to
get exisitng images onto Cirrus so you can use them.

Getting existing images onto Cirrus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Singularity images are simply files so, if you already have an image file, you can use
``scp`` to copy the file to Cirrus as you would with any other file.

If you wish to get a file from one of the container image repositories then Singularity
allows you to do this from Cirrus itself. For example, to retrieve an image from
DockerHub on Cirrus:

::

   module load singularity
   singularity build lolcow.simg docker://godlovedc/lolcow


Interactive use on the login nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Interactive Usage of Singularity Images
---------------------------------------

**To use Singularity interactively, an interactive session must first be requested using** :ref:`qrshx` **for example.**

To get an interactive shell in to the image, use the following command: ::

  singularity shell path/to/imgfile.img

Or if you prefer bash: ::

  singularity exec path/to/imgfile.img /bin/bash

Note that the ``exec`` command can also be used to execute other applications/scripts inside the image or
from the mounted directories (See :ref:`auto_mounting_filestore_singularity_sharc`): ::

    singularity exec path/to/imgfile.img my_script.sh

.. note::

    You may get a warning similar to:

    .. code-block:: none

        groups: cannot find name for group ID ...

    :ref:`This can be ignored <unnamed_groups>` and will not have an affect on running the image.


.. _use_image_batch_singularity_sharc:

Submitting Batch Jobs That Uses Singularity Images
--------------------------------------------------

When submitting a job that uses a Singularity image,
it is not possible to use the interactive shell
(e.g. ``singularity shell`` or ``singularity exec path/to/imgfile.img /bin/bash``).
You must use the ``exec`` command to call the desired application or script directly.

For example, if we would like to use a command ``ls /`` to get the content of the root folder in the image,
two approaches are shown in the following job script ``my_singularity_job.sh``:

.. code-block:: bash

  #!/bin/bash
  #$ -l rmem=8G
  # We requested 8GB of memory in the line above, change this according to your
  # needs e.g. add -l gpu=1 to reqest a single GPU

  #Calling ls directly using the exec command
  singularity exec path/to/imgfile.img ls /

  #Have Singularity call a custom script from your home or other mounted directories
  #Don't forget to make the script executable before running by using chmod
  chmod +x ~/myscript.sh
  singularity exec path/to/imgfile.img ~/myscript.sh

Where the content of ``~/myscript.sh`` is shown below:

.. code-block:: bash

  #!/bin/bash

  ls /

The job can then be submitted as normal with ``qsub``: ::

  qsub my_singularity_job.sh


Using Nvidia GPU with Singularity Images
--------------------------------------------------------------

You can use GPUs in your image by adding the ``--nv`` flag to the command e.g. for running interactively: ::

  singularity shell --nv myimage.simg

or when running within the batch file: ::

  singularity exec --nv myimage.sim myscript.sh

A quick way to test that GPU is enabled in your image is by running the command: ::

  nvidia-smi

Where you will get something similar to the following:

.. code-block:: none

  Tue Mar 28 16:43:08 2017
  +-----------------------------------------------------------------------------+
  | NVIDIA-SMI 367.57                 Driver Version: 367.57                    |
  |-------------------------------+----------------------+----------------------+
  | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
  |===============================+======================+======================|
  |   0  GeForce GTX TITAN   Off  | 0000:01:00.0      On |                  N/A |
  | 30%   35C    P8    18W / 250W |    635MiB /  6078MiB |      1%      Default |
  +-------------------------------+----------------------+----------------------+


.. _auto_mounting_filestore_singularity_sharc:

Automatic Mounting of ShARC Filestore Inside Images
----------------------------------------------------

When running Singularity images on ShARC,
the paths ``/fastdata``, ``/data``, ``/home``, ``/scratch``, ``/shared`` are
automatically mounted to your ShARC directories.

Image Index on Github
---------------------

All Singularity container definitions available on ShARC can be found at `https://github.com/rses-singularity <https://github.com/rses-singularity>`_. The definition files can be used as a template for building your own images.


Installing Singularity on Your Local Machine
--------------------------------------------

You will need Singularity installed on your machine in order to locally run, create and modify images.

The following is the installation command for debian/ubuntu based systems:

.. code-block:: bash

  #Updating repository and installing dependencies
  sudo apt-get update && \
    sudo apt-get install \
    python \
    dh-autoreconf \
    build-essential

  # Installing Singularity
  git clone https://github.com/singularityware/singularity.git
  cd singularity
  ./autogen.sh
  ./configure --prefix=/usr/local --sysconfdir=/etc
  make
  sudo make install


Manually mounting paths
-----------------------

When using ShARC's pre-built images on your local machine,
it may be useful to mount the existing directories in the image to your own path.
This can be done with the flag ``-B local/path:image/path`` with
the path outside of the image left of the colon and
the path in the image on the right side, e.g. ::

  singularity shell -B local/datapath:/data,local/fastdatapath:/fastdata path/to/imgfile.img

The command mounts the path ``local/datapath`` on your local machine to
the ``/data`` path in the image.
Multiple mount points can be joined with ``,``
as shown above where we additionally specify that ``local/fastdata`` mounts to ``/fastdata``.
The ``/home`` folder is automatically mounted by default.

**Note: In order to mount a path, the directory must already exist within the image.**

.. _create_image_singularity_sharc:

Creating Your Own Singularity Images
------------------------------------

**Root access is required for modifying Singularity images so if you need to edit an image it must be done on your local machine.  However you can create disk images and import docker images using normal user privileges on recent versions of Singularity**

First create a Singularity definition file for bootstrapping an image your image. An example definition file we'll name ``Singularity`` is shown below ::

  Bootstrap: docker
  From: ubuntu:latest

  %setup
  	#Runs on host. The path to the image is $SINGULARITY_ROOTFS

  %post
  	#Post setup, runs inside the image

    #Default mount paths
  	mkdir /scratch /data /shared /fastdata

    #Install the packages you need
    apt-get install git vim cmake


  %runscript
    #Runs inside the image every time it starts up

  %test
    #Test script to verify that the image is built and running correctly

The definition file takes a base image from `docker hub <https://hub.docker.com/>`_,
in this case the latest version of Ubuntu ``ubuntu:latest``.
Other images on the hub can also be used as the base for the Singularity image,
e.g. ``From: nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04`` uses Nvidia's docker image with Ubuntu 16.04 that already has CUDA 8 installed.

After creating a definition file, use the ``build`` command to build the image from your definition file: ::

  sudo singularity build myimage.simg Singularity

It is also possible to  build Singularity images directory from `Singularity hub <https://singularity-hub.org/>`_ or `docker hub <https://hub.docker.com/>`_: ::

  #Singularity hub
  sudo singularity build myimage.simg shub://GodloveD/ubuntu:latest


  #Docker hub
  sudo singularity build myimage.simg docker://ubuntu:latest

By default, the ``build`` command creates a read-only squashfs file. It is possible to add the ``--writable`` or ``--sandbox`` flag to the build command in order to create a writable ext image or a writable sandbox directory respectively. ::

  sudo singularity build --sandbox myimage_folder Singularity

You will also need to add the ``--writable`` flag to the command when going in to change the contents of an image: ::

  sudo singularity shell --writable myimage_folder


How Singularity is installed and 'versioned' on the cluster
-----------------------------------------------------------

Singularity, unlike much of the other key software packages on ShARC,
is not activated using module files.
This is because module files are primarily for the purpose of
being able to install multiple version of the same software
and for security reasons only the most recent version of Singularity is installed.
The security risks associated with providing outdated builds of Singularity
are considered to outweigh the risk of upgrading to backwards incompatible versions.

Singularity has been installed on all worker nodes
using the latest RPM package
from the `EPEL <https://fedoraproject.org/wiki/EPEL>`_ repository.
