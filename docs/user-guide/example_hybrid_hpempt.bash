#!/bin/bash --login

# PBS job options (name, compute nodes, job time)
#PBS -N Example_MixedMode_Job
#PBS -l select=4:ncpus=36
# Parallel jobs should always specify exclusive node access
#PBS -l place=scatter:excl
#PBS -l walltime=6:0:0

# Replace [budget code] below with your project code (e.g. t01)
#PBS -A [budget code]

# Change to the directory that the job was submitted from
cd $PBS_O_WORKDIR

# Load any required modules
module load mpt
module load intel-compilers-17

# Set the number of threads to 18
#   There are 18 OpenMP threads per MPI process
export OMP_NUM_THREADS=18

# Launch the parallel job
#   Using 8 MPI processes
#   2 MPI processes per node
#   18 OpenMP threads per MPI process
#
#   '-ppn' option is required for all HPE MPT jobs otherwise you will get an error similar to:
#       'mpiexec_mpt error: Need 36 processes but have only 1 left in PBS_NODEFILE.'
#
mpiexec_mpt -ppn 2 -n 8 omplace -nt 18 ./my_mixed_executable.x arg1 arg2 > my_stdout.txt 2> my_stderr.txt

