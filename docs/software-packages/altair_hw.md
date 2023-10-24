# Altair Hyperworks

[Hyperworks](http://www.altairhyperworks.com/) includes best-in-class
modeling, linear and nonlinear analyses, structural and system-level
optimization, fluid and multi-body dynamics simulation, electromagnetic
compatibility (EMC), multiphysics analysis, model-based development, and
data management solutions.

## Useful Links

> - [Hyperworks 14 User
>   Guide](http://www.altairhyperworks.com/hwhelp/Altair/hw14.0/help/altair_help/altair_help.htm?welcome_page.htm)

## Using Hyperworks on Cirrus

Hyperworks is licenced software so you require access to a Hyperworks
licence to access the software. For queries on access to Hyperworks on
Cirrus and to enable your access please contact the Cirrus helpdesk.

The standard mode of using Hyperworks on Cirrus is to use the
installation of the Desktop application on your local workstation or
laptop to set up your model/simulation. Once this has been done you
would transsfer the required files over to Cirrus using SSH and then
launch the appropriate Solver program (OptiStruct, RADIOSS,
MotionSolve).

Once the Solver has finished you can transfer the output back to your
local system for visualisation and analysis in the Hyperworks Desktop.

## Running serial Hyperworks jobs

Each of the Hyperworks Solvers can be run in serial on Cirrus in a
similar way. You should construct a batch submission script with the
command to launch your chosen Solver with the correct command line
options.

For example, here is a job script to run a serial RADIOSS job on Cirrus:

``` bash
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=HW_RADIOSS_test
#SBATCH --time=0:20:0
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard,gpu)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long,gpu)
#SBATCH --qos=[qos name]

# Set the number of threads to the CPUs per task
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Load Hyperworks module
module load altair-hwsolvers/14.0.210

# Launch the parallel job
#   Using 36 threads per node
#   srun picks up the distribution from the sbatch options
srun --cpu-bind=cores radioss box.fem
```

## Running parallel Hyperworks jobs

Only the OptiStruct Solver currently supports parallel execution.
OptiStruct supports a number of parallel execution modes of which two
can be used on Cirrus:

- Shared memory (SMP) mode uses multiple cores within a single node
- Distributed memory (SPMD) mode uses multiple cores across multiple
  nodes via the MPI library

### OptiStruct SMP

- [OptiStruct SMP
  documentation](http://www.altairhyperworks.com/hwhelp/Altair/hw14.0/help/hwsolvers/hwsolvers.htm?shared_memory_parallelization.htm)

You can use up to 36 physical cores (or 72 virtual cores using
HyperThreading) for OptiStruct SMP mode as these are the maximum numbers
available on each Cirrus compute node.

You use the `-nt` option to OptiStruct to specify the number of cores to
use.

For example, to run an 18-core OptiStruct SMP calculation you could use
the following job script:

``` bash
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=HW_OptiStruct_SMP
#SBATCH --time=0:20:0
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=36

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard,gpu)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long,gpu)
#SBATCH --qos=[qos name]

# Load Hyperworks module
module load altair-hwsolvers/14.0.210

# Launch the parallel job
#   Using 36 threads per node
#   srun picks up the distribution from the sbatch options
srun --cpu-bind=cores --ntasks=18 optistruct box.fem -nt 18
```

### OptiStruct SPMD (MPI)

- [OptiStruct SPMD
  documentation](http://www.altairhyperworks.com/hwhelp/Altair/hw14.0/help/hwsolvers/hwsolvers.htm?optistruct_spmd.htm)

There are four different parallelisation schemes for SPMD OptStruct that
are selected by different flags:

- Load decomposition (master/slave): `-mpimode` flag
- Domain decomposition: `-ddmmode` flag
- Multi-model optimisation: `-mmomode` flag
- Failsafe topology optimisation: `-fsomode` flag

You should launch OptiStruct SPMD using the standard Intel MPI `mpirun`
command.

*Note:* OptiStruct does not support the use of SGI MPT, you must use
Intel MPI.

Example OptiStruct SPMD job submission script:

``` bash
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=HW_OptiStruct_SPMD
#SBATCH --time=0:20:0
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard,gpu)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long,gpu)
#SBATCH --qos=[qos name]

# Load Hyperworks module and Intel MPI
module load altair-hwsolvers/14.0.210
module load intel-mpi-17

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1

# Run the OptStruct SPMD Solver (domain decomposition mode)
#   Use 72 cores, 36 on each node (i.e. all physical cores)
#   srun picks up the distribution from the sbatch options
srun --ntasks=72 $ALTAIR_HOME/hwsolvers/optistruct/bin/linux64/optistruct_14.0.211_linux64_impi box.fem -ddmmode
```
