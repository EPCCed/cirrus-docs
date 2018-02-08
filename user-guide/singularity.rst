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
allows you to do this from Cirrus itself.

This functionality requires tools that are not part of the standard OS on Cirrus so we have
provided a Singularity image that allows you to build images from remote repositories (i.e.
you use a Singularity image to build Singularity images!).

For example, to retrieve an image from DockerHub on Cirrus we fist need to enter an 
interactive session in the image we provide for building Singularity images:

::

   module load singularity
   singularity exec $CIRRUS_SIMG/cirrus-sbuild.simg /bin/bash --login
   Singularity> 

This invokes a login bash shell within the ``$CIRRUS_SIMG/cirrus-sbuild.simg`` image as 
indicated by our prompt change. (We need a login shell to allow ``module`` commands to work 
within the image.)

Now we are in the image we can load the singularity module (to get access to the Singularity
commands) and pull an image from DockerHub:

::

   Singularity> module load singularity
   Singularity> singularity build lolcow.simg docker://godlovedc/lolcow
   Docker image path: index.docker.io/godlovedc/lolcow:latest
   Cache folder set to /lustre/home/t01/user/.singularity/docker
   Importing: base Singularity environment
   Importing: /lustre/home/t01/user/.singularity/docker/sha256:9fb6c798fa41e509b58bccc5c29654c3ff4648b608f5daa67c1aab6a7d02c118.tar.gz
   Importing: /lustre/home/t01/user/.singularity/docker/sha256:3b61febd4aefe982e0cb9c696d415137384d1a01052b50a85aae46439e15e49a.tar.gz
   Importing: /lustre/home/t01/user/.singularity/docker/sha256:9d99b9777eb02b8943c0e72d7a7baec5c782f8fd976825c9d3fb48b3101aacc2.tar.gz
   Importing: /lustre/home/t01/user/.singularity/docker/sha256:d010c8cf75d7eb5d2504d5ffa0d19696e8d745a457dd8d28ec6dd41d3763617e.tar.gz
   Importing: /lustre/home/t01/user/.singularity/docker/sha256:7fac07fb303e0589b9c23e6f49d5dc1ff9d6f3c8c88cabe768b430bdb47f03a9.tar.gz
   Importing: /lustre/home/t01/user/.singularity/docker/sha256:8e860504ff1ee5dc7953672d128ce1e4aa4d8e3716eb39fe710b849c64b20945.tar.gz
   Importing: /lustre/home/t01/user/.singularity/metadata/sha256:ab22e7ef68858b31e1716fa2eb0d3edec81ae69c6b235508d116a09fc7908cff.tar.gz
   WARNING: Building container as an unprivileged user. If you run this container as root
   WARNING: it may be missing some functionality.
   Building Singularity image...
   Singularity container built: lolcow.simg
   Cleaning up...

The first argument to ``singularity build`` (lolcow.simg) specifies a path and name for your container.
The second argument (docker://godlovedc/lolcow) gives the DockerHub URI from which to download the image.

Now we can exit the image and run our new image we have just built on the Cirrus login node:

::

   singularity run lolcow.simg

This image contains a *runscript* that tells Singularity what to do if we run the image. We demonstrate
different ways to use images below.

Similar syntax can be used for Singularity Hub. For more information see the Singularity documentation:

* `Build a Container <http://singularity.lbl.gov/docs-build-container>`_


Interactive use on the login nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once you have an image file, using it on the login nodes in an interactive way is extremely simple:
you use the ``singularity shell`` command. Using the image we built in the example above:

::

   module load singularity
   singularity shell lolcow.simg
   Singularity: Invoking an interactive shell within container...
   
   Singularity lolcow.simg:~> 

Within a Singularity image your home directory will be available. The directory with
centrally-installed software (``/lustre/sw``) is also available in images by default. Note that
the ``module`` command will not work in images unless you have installed he required software and
configured the environment correctly; we describe how to do this below.

Once you have finished using your image, you return to the Cirrus login node command line with the
``exit`` command:

::

   Singularity lolcow.simg:~> exit
   exit
   [user@cirrus-login0 ~]$

Interactive use on the compute nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The process for using an image interactively on the compute nodes is very similar to that for 
using them on the login nodes. The only difference is that you have to submit an interactive
serial job to get interactive access to the compute node first.

For example, to reserve a full node for you to work on interactively you would use:

::

   [user@cirrus-login0 ~]$ qsub -IVl select=1:ncpus=72,walltime=0:20:0,place=excl -A t01
   qsub: waiting for job 234192.indy2-login0 to start
   
   ...wait until job starts...
   
   qsub: job 234192.indy2-login0 ready
   
   [user@r1i2n13 ~]$

Note the prompt has changed to show you are on a compute node. Now you can use the image
in the same way as on the login node

::

   [user@r1i2n13 ~]$ module load singularity
   [user@r1i2n13 ~]$ singularity shell lolcow.simg
   Singularity: Invoking an interactive shell within container...
      
   Singularity lolcow.simg:~> exit
   exit
   [user@r1i2n13 ~]$ exit
   [user@cirrus-login0 ~]$

Note we used ``exit`` to leave the interactive image shell and then ``exit`` again to leave the
interactive job on the compute node.

Serial processes within a non-interactive batch script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also use Singularity images within a non-interactive batch script as you would any
other command. If your image contains a *runscript* then you can use ``singularity run`` to
execute the runscript in the job. You can also use ``singularity exec`` to execute arbitrary
commands (or scripts) within the image.

An exmaple job submission script to run a serial job that executes the runscript within the
``lolcow.simg`` we built above on Cirrus would be:

::

    #!/bin/bash --login

    # PBS job options (name, compute nodes, job time)
    #PBS -N simg_test
    #PBS -l select=1:ncpus=1
    #PBS -l walltime=0:20:0

    # Replace [budget code] below with your project code (e.g. t01)
    #PBS -A [budget code]

    # Change to the directory that the job was submitted from
    cd $PBS_O_WORKDIR

    # Load any required modules
    module load singularity

    # Run the serial executable
    singularity run $HOME/lolcow.simg

You submit this in the usual way and the output would be in the STDOUT/STDERR files in the
usual way.


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
