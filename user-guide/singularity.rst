Singularity Containers
======================

This page was originally based on the documentation at the `University of Sheffield HPC service
<http://docs.hpc.shef.ac.uk/en/latest/sharc/software/apps/singularity.html>`_.

Designed around the notion of mobility of compute and reproducible science,
Singularity enables users to have full control of their operating system environment.
This means that a non-privileged user can "swap out" the Linux operating system and
environment on the host for a Linux OS and environment that they control.
So if the host system is running CentOS Linux but your application runs in Ubuntu Linux
with a particular software stack; you can create an Ubuntu image, install your software
into that image, copy the image to another host (e.g. Cirrus), and run your application
on that host in its native Ubuntu environment.

Singularity also allows you to leverage the resources of whatever host you are on.
This includes high-speed interconnects (i.e. Infinband on Cirrus),
file systems (i.e. /lustre on Cirrus) and potentially other resources (e.g. the
licensed Intel compilers on Cirrus).

**Note:** Singularity only supports Linux containers. You cannot create images
that use Windows or macOS (this is a restriction of the containerisation model
rather than of Singularity).

Useful Links
------------

* `Singularity website <https://www.sylabs.io/>`_
* `Singularity documentation <https://www.sylabs.io/docs/>`_

About Singularity Containers (Images)
-------------------------------------

Similar to Docker,
a Singularity container (or, more commonly, *image*) is a self-contained software stack.
As Singularity does not require a root-level daemon to run its images (as
is required by Docker) it is suitable for use on a multi-user HPC system such as Cirrus.
Within the container/image, you have exactly the same permissions as you do in a
standard login session on the system.

In principle, this means that an image created on your local machine
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

.. hint::

  Singularity has not been installed as root on Cirrus, so the following limitations apply:
  
   - All containers will be run from sandbox directories
   - Filesystem image, and SIF-embedded persistent overlays cannot be used
   - Encrypted containers cannot be used
   - Fakeroot functionality will rely on external setuid root `newuidmap` and `newgidmap` binaries which may be provided by the distribution
  
  These are described in more detail in the `Singularity documentation <https://sylabs.io/guides/3.6/admin-guide/user_namespace.html#userns-limitations>`_


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
get existing images onto Cirrus so that you can use them.

Getting existing images onto Cirrus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Singularity images are simply files, so if you already have an image file, you can use
``scp`` to copy the file to Cirrus as you would with any other file.

If you wish to get a file from one of the container image repositories then Singularity
allows you to do this from Cirrus itself.

For example, to retrieve an image from SingularityHub on Cirrus we can simply issue a Singularity
command to pull the image.

::

   [user@cirrus-login1 ~]$ module load singularity
   [user@cirrus-login1 ~]$ singularity pull hello-world.sif shub://vsoch/hello-world

The image located at the ``shub`` URI is written to a Singularity Image File (SIF) called ``hello-world.sif``.


Interactive use on the login nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The container represented by the image file can be run on the login node like so.

::

   [user@cirrus-login1 ~]$ singularity run hello-world.sif 
   INFO:    Convert SIF file to sandbox...
   RaawwWWWWWRRRR!! Avocado!
   INFO:    Cleaning up image...
   [user@cirrus-login1 ~]$

We can also ``shell`` into the container.

::

   [user@cirrus-login1 ~]$ singularity shell hello-world.sif
   INFO:    Convert SIF file to sandbox...
   Singularity hello-world.sif:~> ls /
   bin  boot  dev	environment  etc  home	lib  lib64  lustre  media  mnt	opt  proc  rawr.sh  root  run  sbin  singularity  srv  sys  tmp  usr  var
   Singularity hello-world.sif:~> exit
   INFO:    Cleaning up image...
   [user@cirrus-login1 ~]$ 

For more information see the Singularity documentation:

* `Build a Container <https://www.sylabs.io/guides/2.6/user-guide/build_a_container.html>`_


Interactive use on the compute nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The process for using an image interactively on the compute nodes is very similar to that for
using them on the login nodes. The only difference is that you have to submit an interactive
serial job to get interactive access to the compute node first.

For example, to reserve a full node for you to work on interactively you would use something like:

::

   [user@cirrus-login1 ~]$ salloc --exclusive --nodes=1 --tasks-per-node=36 --cpus-per-task=1 --time=00:20:00 --partition=standard --qos=standard --account=[budget code] 
   salloc: Pending job allocation 14507
   salloc: job 14507 queued and waiting for resources
   salloc: job 14507 has been allocated resources
   salloc: Granted job allocation 14507
   salloc: Waiting for resource configuration
   salloc: Nodes r1i0n8 are ready for job
   [user@cirrus-login1 ~]$ ssh r1i0n8

   [user@r1i0n8 ~]$

Note the prompt has changed to show you are on a compute node. Now you can use the image
in the same way as on the login node.

::

   [user@r1i0n8 ~]$ module load singularity
   [user@r1i0n8 ~]$ singularity shell hello-world.sif
   INFO:    Convert SIF file to sandbox...
   Singularity hello-world.sif:~> exit
   INFO:    Cleaning up image...
   [user@r1i0n8 ~]$ exit
   logout
   Connection to r1i0n8 closed.
   [user@cirrus-login1 ~]$ exit
   salloc: Relinquishing job allocation 14507
   [user@cirrus-login1 ~]$

Note we used ``exit`` to leave the interactive container shell and then called ``exit`` twice
more to close the interactive job on the compute node.

Serial processes within a non-interactive batch script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also use Singularity images within a non-interactive batch script as you would any
other command. If your image contains a *runscript* then you can use ``singularity run`` to
execute the runscript in the job. You can also use ``singularity exec`` to execute arbitrary
commands (or scripts) within the image.

An exmaple job submission script to run a serial job that executes the runscript within the
``hello-world.sif`` we built above on Cirrus would be:

::

    #!/bin/bash --login

    # job options (name, compute nodes, job time)
    #SBATCH --job-name=hello-world
    #SBATCH --ntasks=1
    #SBATCH --exclusive
    #SBATCH --time=0:20:0
    #SBATCH --partition=standard
    #SBATCH --qos=standard

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]

    # Load any required modules
    module load singularity

    # Run the serial executable
    srun --cpu-bind=cores singularity run $HOME/hello-world.sif

You submit this in the usual way and the output would be in the STDOUT/STDERR files in the
usual way.


.. _create_image_singularity:

Creating Your Own Singularity Images
------------------------------------

You can create Singularity images by importing from DockerHub or Singularity Hub on Cirrus itself.
If you wish to create your own custom image then you must install Singularity on a system where you
have root (or administrator) privileges - often your own laptop or workstation.

We provide links below to instructions on how to install Singularity locally and then cover what
options you need to include in a Singularity definition file in order to create images that can run
on Cirrus and access the software development modules. (This can be useful if you want to create a
custom environment but still want to compile and link against libraries that you only have access to
on Cirrus such as the Intel compilers, HPE MPI libraries, etc.)

Installing Singularity on Your Local Machine
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You will need Singularity installed on your machine in order to locally run, create and modify images.
How you install Singularity on your laptop/workstation depends on the operating system you are using.

If you are using Windows or macOS, the simplest solution is to use `Vagrant <http://www.vagrantup.com>`_
to give you an easy to use virtual environment with Linux and Singularity installed. The Singularity
website has instructions on how to use this method to install Singularity:

* `Installing Singularity on macOS with Vagrant <https://www.sylabs.io/guides/2.6/user-guide/installation.html#install-on-mac>`_
* `Installing Singularity on Windows with Vagrant <https://www.sylabs.io/guides/2.6/user-guide/installation.html#install-on-windows>`_

If you are using Linux then you can usually install Singularity directly, see:

* `Installing Singularity on Linux <https://www.sylabs.io/guides/2.6/user-guide/installation.html#install-on-linux>`_

Singularity Recipes to Access modules on Cirrus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may want your custom image to be able to access the modules environment on Cirrus so you can make
use of custom software that you cannot access elsewhere. We demonstrate how to do this for a CentOS 7
image but the steps are easily translated for other flavours of Linux.

For the Cirrus modules to be available in your Singularity container you need to ensure that the
``environment-modules`` package is installed in your image.

In addition, when you use the container you must invoke access as a login shell to have access to the
module commands.

Here is an example recipe file to build a CentOS 7 image with access to TCL modules already installed
on Cirrus:

::

   BootStrap: docker
   From: centos:centos7

   %post
       yum update -y
       yum install environment-modules -y
       echo 'module() { eval `/usr/bin/modulecmd bash $*`; }' >> /etc/bashrc
       yum install wget -y
       yum install which -y
       yum install squashfs-tools -y

If we save this definition to a file called ``cirrus-centos7.def`` then we can use the following command
to build the image (remember this command must be run on a system where you have root access, not Cirrus):

::

   me@my-system:~> sudo singularity build cirrus-centos7.sif cirrus-centos7.def

The resulting image file (``cirrus-centos7.sif``) can then be copied to Cirrus using scp.

When you use the image interactively on Cirrus you must start with a login shell and also
bind ``/lustre/sw`` so that the container can see all the module files, see below.

::

   [user@cirrus-login1 ~]$ module load singularity
   [user@cirrus-login1 ~]$ singularity exec -B /lustre/sw cirrus-centos7.sif /bin/bash --login
   INFO:    Convert SIF file to sandbox...
   Singularity> module avail intel-compilers

   ------------------------- /lustre/sw/modulefiles ---------------------
   intel-compilers-18/18.05.274  intel-compilers-19/19.0.0.117
   Singularity>
