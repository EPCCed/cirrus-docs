# Molpro

[Molpro](https://www.molpro.net/) is a comprehensive system of ab initio
programs for advanced molecular electronic structure calculations,
designed and maintained by H.-J. Werner and P. J. Knowles, and
containing contributions from many other authors. It comprises efficient
and well parallelized programs for standard computational chemistry
applications, such as DFT with a large choice of functionals, as well as
state-of-the art high-level coupled-cluster and multi-reference wave
function methods.

## Useful Links

- [Molpro User
  Guides](https://www.molpro.net/info/2015.1/doc/manual/index.html?portal=user&choice=User%27s+manual)
- [Molpro
  Licensing](https://www.molpro.net/info/products.php?portal=visitor&choice=Licence+types)

## Using Molpro on Cirrus

In order to use the Molpro binaries on Cirrus you must possess a valid
Molpro licence key. Without a key you will be able to access the
binaries but will not be able to run any calculations.

## Running

To run Molpro you need to add the correct module to your environment;
specify your licence key using the MOLPRO_KEY environment variable and
make sure you specify the location for the temporary files using the
TMPDIR environment variable. You can load the default Molpro module
with:

    module add molpro

Once you have loaded the module, the Molpro executables are available in
your PATH.

## Example Job Submission Script

An example Molpro job submission script is shown below.

    #!/bin/bash
    #SBATCH --job-name=molpro_test
    #SBATCH --nodes=1
    #SBATCH --tasks-per-node=36
    #SBATCH --exclusive
    #SBATCH --time=0:15:0
    #SBATCH --partition=standard
    #SBATCH --qos=standard

    # Replace "budget" with your budget code in the line below
    #SBATCH --account=budget

    # Load the molpro module 
    module add molpro

    # Specify your Molpro licence key
    #   Replace this with the value of your Molpro licence key
    export MOLPRO_KEY="...your Molpro key..."

    # Make sure temporary files are in your home file space
    export TMPDIR=$SLURM_SUBMIT_DIR

    # Run Molpro using the input my_file.inp
    #    Requested 1 node above = 36 cores
    #    Note use of "molpro" command rather than usual "srun"
    molpro -n 36 my_file.inp
