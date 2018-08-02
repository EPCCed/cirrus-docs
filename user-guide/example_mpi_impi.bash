#!/bin/bash --login

# PBS job options (name, compute nodes, job time)
#PBS -N Example_MPI_Job
# Select 4 full nodes
#PBS -l select=4:ncpus=36
# Parallel jobs should always specify exclusive node access
#PBS -l place=scatter:excl
#PBS -l walltime=00:20:00

# Replace [budget code] below with your project code (e.g. t01)
#PBS -A [budget code]             

# Change to the directory that the job was submitted from
cd $PBS_O_WORKDIR
  
# Load any required modules
module load intel-mpi-17
module load intel-compilers-17

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1

# Launch the parallel job
#   Using 144 MPI processes and 36 MPI processes per node
mpirun -n 144 -ppn 36 ./my_mpi_executable.x arg1 arg2 > my_stdout.txt 2> my_stderr.txt
