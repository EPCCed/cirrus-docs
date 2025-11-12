# Using Containers

This page was originally based on the documentation at the [University
of Sheffield HPC
service](http://docs.hpc.shef.ac.uk/en/latest/sharc/software/apps/singularity.html).

Designed around the notion of mobility of compute and reproducible
science, containers enable users to have full control of their
operating system environment. This means that a non-privileged user can
"swap out" the Linux operating system and environment on the host for a
Linux OS and environment that they control. So if the host system is
running CentOS Linux but your application runs in Ubuntu Linux with a
particular software stack, you can create an Ubuntu image, install your
software into that image, copy the image to another host (e.g. Cirrus),
and run your application on that host in its native Ubuntu environment.

Containers also allow you to leverage the resources of whatever host
you are on. This includes high-speed interconnects (e.g. Infiniband),
file systems (e.g. Lustre) and potentially other resources.

## Apptainer

The container software supported on Cirrus is Apptainer.

!!! Note
	Apptainer only supports Linux containers. You cannot create images
	that use Windows or macOS (this is a restriction of the containerisation
	model rather than of Apptainer).

### Useful Links

- [Apptainer website](https://apptainer.org/)
- [Apptainer documentation](https://apptainer.org/docs/user/latest/)

## About Apptainer container images

Similar to Docker or Podman, an Apptainer container image (or, more commonly, *image*)
is a self-contained software stack. As Apptainer does not require a
root-level daemon to run its images (as is required by Docker) it is
suitable for use on a multi-user HPC system such as Cirrus. Within a 
running container created from the container image, you have exactly
the same permissions as you do in a standard login session on the system.

In principle, this means that a container image created on your local machine
with all your research software installed for local development will
also run on Cirrus.

Pre-built container images (such as those on [DockerHub](http://hub.docker.com) or
[Quay.io](hhttps://quay.io/) can simply be downloaded
and used on Cirrus (or anywhere else Singularity is installed).

Creating and modifying container images requires root permission and so must be
done on a system where you have such access (in practice, this is
usually your laptop/workstation using Docker or Podman).

## Using container images on Cirrus

Container images can be used on Cirrus in a number of ways.

1.  Interactively on the login nodes
2.  Interactively on compute nodes
3.  As serial processes within a non-interactive batch script
4.  As parallel processes within a non-interactive batch script

We provide information on each of these scenarios. First, we describe
briefly how to get existing container images onto Cirrus and converted
to the Apptainer format so that you can use them.

### Getting existing container images onto Cirrus

Container images are most usually downloaded onto Cirrus from a 
container image repository (such as Dockerhub or Quay.io) so we 
discuss that mechanism in detail. If you already have your 
container images in Apptainer format as an *image file* then you 
can copy these to Cirrus in the same way as any other file.

Singularity images are simply files, so if you already have an image
file, you can use `scp` to copy the file to Cirrus as you would with any
other file.

To fetch a container image from a container image repository and
convert to an Apptainer container image file on the fly, you can 
use a command such as:

```
apptainer build hello_world.sif docker://hub.docker.com/hello-world
```

This will download the "hello-world" container image from DockerHub
and save it as an Apptainer image file in the file `hello-world.sif`.

### Interactive use on the login nodes

To run a container created from a container image file on the login node
you would use (note mention of Docker as this was downloaded from Docker Hub,
however we are running the container using Apptainer):

```bash
[user@login01 ~]$ apptainer run hello-world.sif 
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

We can also run a container created from the container image file
and get an interactive shell prompt in the running container:

```bash
[user@login01 ~]$ apptainer shell hello-world.sif
Apptainer> ls /
bin  boot  dev  environment  etc  home  lib  lib64  lustre  media  mnt  opt  proc  rawr.sh  root  run  sbin  singularity  srv  sys  tmp  usr  var
Apptainer> exit
exit
[user@login01 ~]$ 
```

### Interactive use on the compute nodes

The process for using an image interactively on the compute nodes is
very similar to that for using them on the login nodes. The only
difference is that you first have to submit an interactive serial job to
get interactive access to the compute node.

First though, move to a suitable location on `/work` and re-pull the
`hello-world` image. This step is necessary as the compute nodes do not
have access to the `/home` file system.

    [user@cirrus-login1 ~]$ cd ${HOME/home/work}
    [user@cirrus-login1 ~]$ singularity pull hello-world.sif shub://vsoch/hello-world

Now reserve a full node to work on interactively by issuing an `salloc`
command, see below.

    [user@cirrus-login1 ~]$ salloc --exclusive --nodes=1 \
      --tasks-per-node=36 --cpus-per-task=1 --time=00:20:00 \
      --partition=standard --qos=standard --account=[budget code] 
    salloc: Pending job allocation 14507
    salloc: job 14507 queued and waiting for resources
    salloc: job 14507 has been allocated resources
    salloc: Granted job allocation 14507
    salloc: Waiting for resource configuration
    salloc: Nodes r1i0n8 are ready for job
    [user@cirrus-login1 ~]$ ssh r1i0n8

Note the prompt has changed to show you are on a compute node. Once you
are logged in to the compute node (you may need to submit your account
password), move to a suitable location on `/work` as before. You can now
use the `hello-world` image in the same way you did on the login node.

    [user@r1i0n8 ~]$ cd ${HOME/home/work}
    [user@r1i0n8 ~]$ singularity shell hello-world.sif
    Singularity> exit
    exit
    [user@r1i0n8 ~]$ exit
    logout
    Connection to r1i0n8 closed.
    [user@cirrus-login1 ~]$ exit
    exit
    salloc: Relinquishing job allocation 14507
    salloc: Job allocation 14507 has been revoked.
    [user@cirrus-login1 ~]$

Note we used `exit` to leave the interactive container shell and then
called `exit` twice more to close the interactive job on the compute
node.

### Serial processes within a non-interactive batch script

You can also use Singularity images within a non-interactive batch
script as you would any other command. If your image contains a
*runscript* then you can use `singularity run` to execute the runscript
in the job. You can also use `singularity exec` to execute arbitrary
commands (or scripts) within the image.

An example job submission script to run a serial job that executes the
runscript within the `hello-world.sif` we built above on Cirrus would be
as follows.

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
    srun --cpu-bind=cores singularity run ${HOME/home/work}/hello-world.sif

Submit this script using the `sbatch` command and once the job has
finished, you should see `RaawwWWWWWRRRR!! Avocado!` in the Slurm output
file.

### Parallel processes within a non-interactive batch script

Running a Singularity container on the compute nodes isn't too different
from launching a normal parallel application. The submission script
below shows that the `srun` command now contains an additional
`singularity` clause.

    #!/bin/bash --login

    # job options (name, compute nodes, job time)
    #SBATCH --job-name=[name of application]
    #SBATCH --nodes=4
    #SBATCH --tasks-per-node=36
    #SBATCH --cpus-per-task=1
    #SBATCH --exclusive
    #SBATCH --time=0:20:0
    #SBATCH --partition=standard
    #SBATCH --qos=standard

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]

    # Load any required modules
    module load mpt
    module load singularity

    # The host bind paths for the Singularity container.
    BIND_ARGS=/work/y07/shared/cirrus-software,/opt/hpe,/etc/libibverbs.d,/path/to/input/files

    # The file containing environment variable settings that will allow
    # the container to find libraries on the host, e.g., LD_LIBRARY_PATH . 
    ENV_PATH=/path/to/container/environment/file

    CONTAINER_PATH=/path/to/singularity/image/file

    APP_PATH=/path/to/containerized/application/executable
    APP_PARAMS=[application parameters]

    srun --distribution=block:block --hint=nomultithread \
        singularity exec --bind ${BIND_ARGS} --env-file ${ENV_PATH} ${IMAGE_PATH}
            ${APP_PATH} ${APP_PARAMS}

The script above runs a containerized application such that each of the
four nodes requested is fully populated. In general, the containerized
application's input and output will be read from and written to a
location on the host; hence, it is necessary to pass a suitable bind
path to singularity (`/path/to/input/files`).



!!! Note

	The paths in the submission script that begin `/path/to` should be
	provided by the user. All but one of these paths are host specific. The
	exception being `APP_PATH`, which should be given a path relative to the
	container file system.



If the Singularity image file was built according to the [Bind
model](https://sylabs.io/guides/3.7/user-guide/mpi.html#bind-model), you
will need to specify certain paths (`--bind`) and environment variables
(`--env-file`) that allow the containerized application to find the
required MPI libraries.

Otherwise, if the image follows the [Hybrid
model](https://sylabs.io/guides/3.7/user-guide/mpi.html#hybrid-model)
and so contains its own MPI implementation, you instead need to be sure
that the containerized MPI is compatible with the host MPI, the one
loaded in the submission script. In the example above, the host MPI is
HPE MPT 2.25, but you could also use OpenMPI (with `mpirun`), either by
loading a suitable `openmpi` module or by referencing the paths to an
OpenMPI installation that was built locally (i.e., within your Cirrus
work folder).

## Creating Your Own Singularity Images

You can create Singularity images by importing from DockerHub or
Singularity Hub directly to Cirrus. If you wish to create your own
custom image then you must install Singularity on a system where you
have root (or administrator) privileges - often your own laptop or
workstation.

We provide links below to instructions on how to install Singularity
locally and then cover what options you need to include in a Singularity
definition file in order to create images that can run on Cirrus and
access the software development modules. This can be useful if you want
to create a custom environment but still want to compile and link
against libraries that you only have access to on Cirrus such as the
Intel compilers and HPE MPI libraries.

### Installing Singularity on Your Local Machine

You will need Singularity installed on your machine in order to locally
run, create and modify images. How you install Singularity on your
laptop/workstation depends on the operating system you are using.

If you are using Windows or macOS, the simplest solution is to use
[Vagrant](http://www.vagrantup.com) to give you an easy to use virtual
environment with Linux and Singularity installed. The Singularity
website has instructions on how to use this method to install
Singularity.

- [Installing Singularity on macOS with
  Vagrant](https://sylabs.io/guides/3.7/admin-guide/installation.html#mac)
- [Installing Singularity on Windows with
  Vagrant](https://sylabs.io/guides/3.7/admin-guide/installation.html#windows)

If you are using Linux then you can usually install Singularity
directly.

- [Installing Singularity on
  Linux](https://sylabs.io/guides/3.7/admin-guide/installation.html#installation-on-linux)

### Accessing Cirrus Modules from Inside a Container

You may want your custom image to be able to access the modules
environment on Cirrus so you can make use of custom software that you
cannot access elsewhere. We demonstrate how to do this for a CentOS 7
image but the steps are easily translated for other flavours of Linux.

For the Cirrus modules to be available in your Singularity container you
need to ensure that the `environment-modules` package is installed in
your image.

In addition, when you use the container you must invoke access as a
login shell to have access to the module commands.

Below, is an example Singularity definition file that builds a CentOS 7
image with access to TCL modules already installed on Cirrus.

    BootStrap: docker
    From: centos:centos7

    %post
        yum update -y
        yum install environment-modules -y
        echo 'module() { eval `/usr/bin/modulecmd bash $*`; }' >> /etc/bashrc
        yum install wget -y
        yum install which -y
        yum install squashfs-tools -y

If we save this definition to a file called `centos7.def`, we can use
the following `build` command to build the image (remember this command
must be run on a system where you have root access, not on Cirrus).

    me@my-system:~> sudo singularity build centos7.sif centos7.def

The resulting image file (`centos7.sif`) can then be copied to Cirrus
using scp; such an image already exists on Cirrus and can be found in
the `/work/y07/shared/cirrus-software/singularity/images` folder.

When you use that image interactively on Cirrus you must start with a
login shell and also bind `/work/y07/shared/cirrus-software` so that the container
can see all the module files, see below.

    [user@cirrus-login1 ~]$ module load singularity
    [user@cirrus-login1 ~]$ singularity exec -B /work/y07/shared/cirrus-software \
      /work/y07/shared/cirrus-software/singularity/images/centos7.sif \
        /bin/bash --login
    Singularity> module avail intel-*/compilers

    --------- /work/y07/shared/cirrus-modulefiles -------------
    intel-19.5/compilers  intel-20.4/compilers
    Singularity> exit
    logout
    [user@cirrus-login1 ~]$ 

### Altering a Container on Cirrus

A container image file is immutable but it is possible to alter the
image if you convert the file to a sandbox. The sandbox is essentially a
directory on the host system that contains the full container file
hierarchy.

You first run the `singularity build` command to perform the conversion
followed by a `shell` command with the `--writable` option. You are now
free to change the files inside the container sandbox.

    user@cirrus-login1 ~]$ singularity build --sandbox image.sif.sandbox image.sif
    user@cirrus-login1 ~]$ singularity shell -B /work/y07/shared/cirrus-software --writable image.sif.sandbox
    Singularity> 

In the example above, the `/work/y07/shared/cirrus-software` bind path is specified, allowing
you to build code that links to the Cirrus module libraries.

Finally, once you are finished with the sandbox you can exit and convert
back to the original image file.

    Singularity> exit
    exit
    user@cirrus-login1 ~]$ singularity build --force image.sif image.sif.sandbox



!!! Note
	
	Altering a container in this way will cause the associated definition
	file to be out of step with the current image. Care should be taken to
	keep a record of the commands that were run within the sandbox so that
	the image can be reproduced.


