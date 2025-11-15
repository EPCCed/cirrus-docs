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

First though, move to a suitable location on `/work` and copy the
`hello-world` container image file. This step is necessary as the compute
nodes do not have access to the `/home` file system. (This step assumes
you already downloaded the image as described above, if you have not done
this you can download directly to the `/work` file system by following the
instructions above.)

```bash
[user@login01 ~]$ cd ${HOME/home/work}
[user@login01 ~]$ cp ~/hello-world.sif .
```

Now reserve a full node to work on interactively by issuing an `salloc`
command, see below.

```bash
[user@login01 ~]$ salloc --exclusive --nodes=1 \
    --tasks-per-node=288 --cpus-per-task=1 --time=00:20:00 \
    --partition=standard --qos=standard --account=[budget code] 
salloc: Pending job allocation 14507
salloc: job 14507 queued and waiting for resources
salloc: job 14507 has been allocated resources
salloc: Granted job allocation 14507
salloc: Waiting for resource configuration
salloc: Nodes cs-n0030 are ready for job
[user@login01 ~]$ ssh cs-n0030
```

!!!tip
   You will need to setup an SSH key pair and upload the public part
   to SAFE in the usual way to allow SSH login from login
   nodes to compute nodes.
   
Note the prompt has changed to show you are on a compute node. Once you
are logged in to the compute node, move to a suitable location on `/work`
as before. You can now create a container from the `hello-world.sif`
container image file in the same way you did on the login node.

```bash
[user@cs-n0030 ~]$ cd ${HOME/home/work}
[user@cs-n0030 ~]$ apptainer shell hello-world.sif
Apptainer> exit
exit
[user@cs-n0030 ~]$ exit
logout
Connection to cs-n0030 closed.
[user@login01 ~]$ exit
exit
salloc: Relinquishing job allocation 14507
salloc: Job allocation 14507 has been revoked.
[user@login01 ~]$
```

We used `exit` to leave the interactive container shell and then
called `exit` twice more to close the interactive job on the compute
node.

### Serial processes within a non-interactive batch script

You can also use Apptainer to run containers within a non-interactive batch
script as you would any other command. If your image contains a
*runscript* then you can use `apptainer run` to execute the runscript
in the job. You can also use `apptainer exec` command to execute arbitrary
commands (or scripts) within the image.

An example job submission script to run a serial job that executes the
runscript within the `hello-world.sif` container image file we downloaded
above on Cirrus would be as follows. Assuming we submit from the same
directory that the `ello-world.sif` file is stored in/

```slurm
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

# Run the serial executable
srun --cpu-bind=cores apptainer run hello-world.sif
```

Submit this script using the `sbatch` command and once the job has
finished, you should see the same output you got interactively
in the Slurm output file when the job finishes.

### Parallel processes within a non-interactive batch script

Running a container in parallel on the compute nodes using Apptainer
is not too different from launching a normal parallel application. 
he submission script below shows how the `srun` command can be used
along with Apptainer to run a container created from a container 
image file in parallel.

```slurm
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

# The host bind paths for the Singularity container.
BIND_ARGS=/work/y07/shared/cirrus-ex,/path/to/input/files

# The file containing environment variable settings that will allow
# the container to find libraries on the host, e.g., LD_LIBRARY_PATH . 
ENV_PATH=/path/to/container/environment/file

IMAGE_PATH=/path/to/apptainer/image/file

APP_PATH=/path/to/containerized/application/executable
APP_PARAMS=[application parameters]

srun --distribution=block:block --hint=nomultithread \
    singularity exec --bind ${BIND_ARGS} --env-file ${ENV_PATH} ${IMAGE_PATH}
        ${APP_PATH} ${APP_PARAMS}
```

The script above runs a containerised application such that each of the
four nodes requested is fully populated. In general, the containerised
application's input and output will be read from and written to a
location on the host; hence, it is necessary to pass a suitable bind
path to the `apptainer` command (`/path/to/input/files`).

!!! Note
	The paths in the submission script that begin `/path/to` should be
	provided by the user. All but one of these paths are locations on the
    host (rather than in the running container). The exception being
    `APP_PATH`, which should be given a path relative to the container
    file system.

## Creating your own Apptainer container images

As we saw above, you can create Apptainer container image files by importing from
DockerHub or other repositories on Cirrus itself. If you wish to create
your own custom container image to use with Apptainer then you must use a system
where you have root (or administrator) privileges - often your own
laptop or workstation.

There are a number of different options to create container images on your local
system to use with Apptainer on Cirrus. We are going to use Podman on our 
local system to create the container image, push the new container image to
Docker Hub and then use Apptainer on Cirrus to convert the Docker container
image to an Apptainer container image file.

For macOS and Windows users we recommend installing Podman Desktop. For Linux
users, we recommend installing Podman directly on your local system. See the
Podman documentation for full details on how to install Podman Desktop/Podman.

### Building container images using Podman

!!! note
    We assume that you are familiar with using Podman/Docker in these instructions. You 
    can find an introduction to Docker at
    [Reproducible Computational Environments Using Containers: Introduction to Docker](https://carpentries-incubator.github.io/docker-introduction/).
    Podman uses very similar commands to Docker.

As usual, you can build container images with a command similar to:

```bash
podman build --platform linux/amd64 -t <username>/<image name>:<version> .
```

Where:

- `<username>` is your Docker Hub username
- `<image name>` is the name of the container image you wish to create
- `<version>` - specifies the version of the image you are creating (e.g. "latest", "v1")
- `.` is the *build context* - in this example it is the location of the Dockerfile

Note, you should use the `--platform linux/amd64` option to ensure that the container
image is compatible with the processor architecture on Cirrus.

## Using Apptainer with MPI on Cirrus

MPI on Cirrus is provided by the Cray MPICH libraries with the interface
to the high-performance Slingshot interconnect provided via the OFI interface.
Therefore, as per the [Apptainer MPI Hybrid model](https://apptainer.org/docs/user/latest/mpi.html#hybrid-model), we will build our container image such that it contains a version of the MPICH MPI library compiled with support for OFI.
Below, we provide instructions on creating a container image with
a version of MPICH compiled in this way. We then provide an 
example of how to run an Apptainer container with MPI over multiple 
Cirrus compute nodes.

### Building an image with MPI from scratch

!!! warning
    Remember, all these steps should be executed on your local system where
    you have administrator privileges and Podman installed, **not on Cirrus**.

We will illustrate the process of building an Apptainer container image with MPI from
scratch by building a container image that contains MPI provided by MPICH and the OSU
MPI benchmarks. As part of the container image creation we need to download the source code
for both MPICH and the OSU benchmarks. At the time of writing, the stable MPICH 3
release is 3.4.3 and the stable OSU benchmark release is 7.5.1 - this may have
changed by the time you are following these instructions.

First, create a Dockerfile that describes how to build the image:

```docker
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install the necessary packages (from repo)
RUN apt-get update && apt-get install -y --no-install-recommends \
 apt-utils \
 build-essential \
 curl \
 libcurl4-openssl-dev \
 libzmq3-dev \
 pkg-config \
 software-properties-common
RUN apt-get clean
RUN apt-get install -y dkms
RUN apt-get install -y autoconf automake build-essential numactl libnuma-dev autoconf automake gcc g++ git libtool

# Download and build an ABI compatible MPICH
RUN curl -sSLO http://www.mpich.org/static/downloads/3.4.2/mpich-3.4.2.tar.gz \
   && tar -xzf mpich-3.4.2.tar.gz -C /root \
   && cd /root/mpich-3.4.2 \
   && ./configure --prefix=/usr --with-device=ch4:ofi --disable-fortran \
   && make -j8 install \
   && cd / \
   && rm -rf /root/mpich-3.4.2 \
   && rm /mpich-3.4.2.tar.gz

# OSU benchmarks
RUN curl -sSLO http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5.1.tar.gz \
   && tar -xzf osu-micro-benchmarks-7.5.1.tar.gz -C /root \
   && cd /root/osu-micro-benchmarks-7.5.1 \
   && ./configure --prefix=/usr/local CC=/usr/bin/mpicc CXX=/usr/bin/mpicxx \
   && make -j8 install \
   && cd / \
   && rm -rf /root/osu-micro-benchmarks-7.5.1 \
   && rm /osu-micro-benchmarks-7.5.1.tar.gz

# Add the OSU benchmark executables to the PATH
ENV PATH=/usr/local/libexec/osu-micro-benchmarks/mpi/startup:$PATH
ENV PATH=/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt:$PATH
ENV PATH=/usr/local/libexec/osu-micro-benchmarks/mpi/collective:$PATH
ENV OSU_DIR=/usr/local/libexec/osu-micro-benchmarks/mpi

# path to mlx IB libraries in Ubuntu
ENV LD_LIBRARY_PATH=/usr/lib/libibverbs:$LD_LIBRARY_PATH
```

A quick overview of what the above Dockerfile is doing:

 - The image is being bootstrapped from the `ubuntu:22.04` Docker image (this contains GLIBC compatible with the Cirrus Linux kernel).
 - The first set of `RUN` sections with `apt-get` commands: install the base packages required from the Ubuntu package repos
 - MPICH install: downloads and compiles the MPICH 3.4.3 in a way that is compatible with Cray MPICH on ARCHER2
 - OSU MPI benchmarks install: downloads and compiles the OSU micro benchmarks
 - `ENV` sections: add the OSU benchmark executables to the PATH so they can be executed in the container without specifying the full path; set the correct paths to the network libraries within the container.


Now we can go ahead and build the container image using Podman (this assumes that
you issue the command in the same directory as the Dockerfile you created based on
the specification above):

```bash
podman build --platform linux/amd64 -t auser/osu-benchmarks:7.5.1 .
```

(Remember to change `auser` to your Dockerhub username.)

Once you have successfully built your container image, you should push it to
Dockerhub:

```bash
podman push auser/osu-benchmarks:7.5.1
```

Finally, you need to use Apptainer on Cirrus to convert the Docker container image
to an Apptainer container image file. Log into Cirrus, move to the work file system
and then use a command like:

```bash
auser@login01:/work/t01/t01/auser> apptainer build osu-benchmarks-7.5.1.sif docker://auser/osu-benchmarks:7.5.1
```

!!! tip
    You can find a copy of the `osu-benchmarks_7.5.1.sif` image on Cirrus in the directory
    `$EPCC_CONTAINER_DIR` if you do not want to build it yourself but still want to
    test.

### Running parallel MPI jobs using Apptainer containers

!!! tip
    These instructions assume you have built an Apptainer container image file on 
    Cirrus that includes MPI provided by MPICH with the OFI interface.
    See the sections above for how to build such container images.

Once you have built your Apptainer container image file that includes MPICH built with
OFI for ARCHER2, you can use it to run parallel jobs in a similar way to
non-Apptainer jobs. The example job submission script below uses the container image file
we built above with MPICH and the OSU benchmarks to run the Allreduce benchmark
on two nodes where all 288 cores on each node are used for MPI processes (so, 576
MPI processes in total).

```bash
#!/bin/bash

#SBATCH --job-name=apptainer_parallel
#SBATCH --time=0:10:0
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=288
#SBATCH --cpus-per-task=1

#SBATCH --partition=standard
#SBATCH --qos=standard
#SBATCH --account=[budget code]

# Load the module to make the Cray MPICH ABI available
module load cray-mpich-abi/8.1.32

export OMP_NUM_THREADS=1
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Set the LD_LIBRARY_PATH environment variable within the Singularity container
# to ensure that it used the correct MPI libraries.
export APPTAINERENV_LD_LIBRARY_PATH="/opt/cray/pe/mpich/8.1.32/ofi/gnu/11.2/lib-abi-mpich:/opt/cray/libfabric/1.22.0/lib64:/opt/cray/pals/1.6/lib:/opt/cray/pe/lib64:/opt/xpmem/lib64:/lib64"

# This makes sure HPE Cray Slingshot interconnect libraries are available
# from inside the container.
export APPTAINER_BIND="/opt/cray,/var/spool,/opt/cray/pe/mpich/8.1.32/ofi/gnu/11.2/lib-abi-mpich,/etc/host.conf,/etc/libibverbs.d/mlx5.driver,/etc/libnl/classid,/etc/resolv.conf,/opt/cray/libfabric/1.22.0/lib64/libfabric.so.1,/lib64/libatomic.so.1,/lib64/libgcc_s.so.1,/lib64/libgfortran.so.5,/lib64/libquadmath.so.0,/opt/cray/pals/1.6/lib/libpals.so.0,/opt/cray/pe/lib64/libpmi2.so.0,/opt/cray/pe/lib64/libpmi.so.0,/opt/xpmem/lib64/libxpmem.so.0,/run/munge/munge.socket.2,/lib64/libmunge.so.2,/lib64/libnl-3.so.200,/lib64/libnl-genl-3.so.200,/lib64/libnl-route-3.so.200,/lib64/librdmacm.so.1,/lib64/libcxi.so.1,/lib64/libm.so.6"

# Launch the parallel job.
srun --hint=nomultithread --distribution=block:block \
    singularity run osu-benchmarks-7.5.1.sif \
        osu_allreduce
```

The only changes from a standard submission script are:

- We set the environment variable `APPTAINER_LD_LIBRARY_PATH` to ensure that the excutable can find the correct libraries are available within the container to be able to use HPE Cray Slingshot interconnect.
- We set the environment variable `APPTAINER_BIND` to ensure that the correct libraries are available within the container to be able to use HPE Cray Slingshot interconnect.
- `srun` calls the `apptainer` software with the container image file we created rather than the parallel program directly.

!!! important
    Remember that the image file must be located on `/work` to run jobs on the
    compute nodes.

If the job runs correctly, you should see output similar to the following in your `slurm-*.out` 
file:

```
Lmod is automatically replacing "cray-mpich/8.1.32" with
"cray-mpich-abi/8.1.32".


# OSU MPI Allreduce Latency Test v7.5
# Datatype: MPI_INT.
# Size       Avg Latency(us)
4                      10.05
8                      10.84
16                     11.19
32                     11.49
64                     13.08
128                    17.09
256                    22.97
512                    22.23
1024                   23.24
2048                   26.16
4096                   60.79
8192                   75.56
16384                  80.11
32768                 120.08
65536                 214.08
131072                378.17
262144                764.93
524288                515.50
1048576              1064.92

```