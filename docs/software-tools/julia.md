# Julia

[Julia](https://julialang.org) is a general purpose software used widely
in data science and for data visualisation.

!!! important
    Julia is not part of the officially supported
    software on Cirrus. While the Cirrus service desk is able to provide
    support for basic use of this software (e.g. access to software, writing
    job submission scripts) it does not generally provide detailed technical
    support for the software and you may be directed to seek support from
    other places if the service desk cannot answer the questions.

## First time installation

!!! note
    There is no centrally installed version of Julia, so you will have to
    manually install it and any packages you may need. The following
    guide was tested on julia-1.13.1.

You will first need to download Julia into your work directory and untar the
folder. You should then add the folder to your system path so you can use the
`julia` executable. Finally, you need to tell Julia to install any packages in
the `/epccfs` directory as opposed to the default home directory,  which can only be
accessed from the login nodes. This can be done with the following code

```bash
export EPCCFS=/epccfs/t01/t01/auser
cd $EPCCFS

wget https://julialang-s3.julialang.org/bin/linux/x64/1.13/julia-1.13.1-linux-x86_64.tar.gz
tar zxvf julia-1.13.1-linux-x86_64.tar.gz
rm ./julia-1.13.1-linux-x86_64.tar.gz

export PATH="$PATH:$EPCCFS/julia-1.13.1/bin"

mkdir $EPCCFS/.julia
export JULIA_DEPOT_PATH="$EPCCFS/.julia"
export PATH="$PATH:$EPCCFS/$JULIA_DEPOT_PATH/bin"
```

At this point you should have a working installation of Julia. The environment
variables will however be cleared when you log out of the terminal. You can
set them in the `.bash_profile` file so that they're automatically defined every time
you log in by adding the following lines to the end of the file `~/.bash_profile`

```bash
export EPCCFS="/epccfs/t01/t01/auser"
export JULIA_DEPOT_PATH="$EPCCFS/.julia"
export PATH="$PATH:$EPCCFS/julia-1.13.1/bin"
export PATH="$PATH:$JULIA_DEPOT_PATH/bin"
```

## Installing packages and using environments

Julia has a built in package manager which can be used to install registered
packages quickly and easily. Like with many other high level programming
languages we can make use of environments to control dependencies etc.

To make an environment, first navigate to where you want your environment to be
(ideally a subfolder of your `/epccfs` directory) and create an empty folder to
store the environment in. Then launch Julia with the --project flag.

```bash
cd $EPCCFS
mkdir MyTestEnv
julia --project=$EPCCFS/MyTestEnv
```

This launches Julia in the `MyTestEnv` environment. You can then install
packages as usual using the normal commands in the Julia terminal. E.g.

```julia
using Pkg
Pkg.add("Oceananigans")
```

## Configuring MPI.jl

The `MPI.jl` package does not use the system MPICH implementation by default.
You can set it up to do this by following the steps below. Then you can launch
Julia in an environment of your choice, ready to build.

First create the directory to hold the Julia environment with MPI:

```
mkdir $EPCCFS/MyMPIEnv
```

Create the config file `$EPCCFS/MyMPIEnv/LocalPreferences.toml` with the following 
contents to configure MPI for use on Cirrus:

```toml
[MPIPreferences]
__clear__ = ["preloads_env_switch"]
_format = "1.0"
abi = "MPICH"
binary = "system"
cclibs = []
libmpi = "/opt/cray/pe/mpich/8.1.32/ofi/gnu/11.2/lib/libmpi.so"
mpiexec = "srun"
preloads = []
```

Launch Julia using the newly created environment:

```bash
julia --project=$EPCCFS/MyMPIEnv
```

Once in the Julia terminal you can build the `MPI.jl` package using the
following code. The final line installs the `mpiexecjl` command which should
be used instead of `srun` to launch mpi processes.

```julia
using Pkg
Pkg.add("MPI")
MPI.install_mpiexecjl(command = "mpiexecjl", force = false, verbose = true)
```
The `mpiexecjl` command will be installed in the directory that `JULIA_DEPOT_PATH`
points too.

!!! note
    The MPI package only needs to be added once per environment. `mpiexecjl` only
    needs to be installed once per Julia installation.


## Running Julia on the compute nodes
Below is an example script for running Julia with mpi on the compute nodes

```slurm
#!/bin/bash
# Slurm job options (job-name, compute nodes, job time)
#SBATCH --job-name=<<job-name>>
#SBATCH --time=0:20:0

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1

#SBATCH --partition=standard
#SBATCH --qos=standard

#SBATCH --account=<<your account>>

module load PrgEnv-gnu

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically
#   using threading.
export OMP_NUM_THREADS=1
export JULIA_NUM_THREADS=1

# Ensure the cpus-per-task option is propagated to srun commands
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Define some paths
export EPCCFS=/epccfs/t01/t01/auser

export JULIA="$EPCCFS/julia-1.13.1/bin/julia"  # The julia executable
export PATH="$PATH:$EPCCFS/julia-1.13.1/bin"  # The folder of the julia executable
export JULIA_DEPOT_PATH="$EPCCFS/.julia"
export MPIEXECJL="$JULIA_DEPOT_PATH/bin/mpiexecjl"  # The path to the mpiexexjl executable

$MPIEXECJL --project=$EPCCFS/MyMPIEnv -n 12 $JULIA ./MyMpiJuliaScript.jl
```

The above script uses pure MPI but you can also use multithreading by setting the `JULIA_NUM_THREADS`
environment variable.
