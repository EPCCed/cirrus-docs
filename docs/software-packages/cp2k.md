# CP2K

[CP2K](https://www.cp2k.org/) is a quantum chemistry and solid state
physics software package that can perform atomistic simulations of solid
state, liquid, molecular, periodic, material, crystal, and biological
systems. CP2K provides a general framework for different modelling
methods such as DFT using the mixed Gaussian and plane waves approaches
GPW and GAPW. Supported theory levels include DFTB, LDA, GGA, MP2, RPA,
semi-empirical methods (AM1, PM3, PM6, RM1, MNDO, …), and classical
force fields (AMBER, CHARMM, …). CP2K can do simulations of molecular
dynamics, metadynamics, Monte Carlo, Ehrenfest dynamics, vibrational
analysis, core level spectroscopy, energy minimisation, and transition
state optimisation using NEB or dimer method.

## Useful Links

- [CP2K Reference Manual](https://manual.cp2k.org)
- [CP2K HOWTOs](https://www.cp2k.org/howto)
- [CP2K FAQs](https://www.cp2k.org/faq)

## Using CP2K on Cirrus

CP2K is available through the `cp2k` module. Loading this module
provides access to the MPI/OpenMP hybrid `cp2k.psmp` executable.
To see which versions are available:
```
$ module avail cp2k
...
   cp2k/2025.2
```

### Optional packages

The centrally installed module versions of CP2K are managed by Spack.
To see the list of optional packages built, along with the compiler
details, one can use, e.g.:
```
$ module load cp2k
$ cp2k.psmp --version
 CP2K version 2025.2
 Source code revision
 cp2kflags: omp libint fftw3 libxc parallel scalapack xsmm
 compiler: GCC version 14.2.1 20240801 (Red Hat 14.2.1-1)
...
```
showing that CP2K has been built with OpenMP, libint, FFTW3, and so on.


## Running parallel CP2K jobs (MPI/OpenMP hybrid)

To run CP2K using MPI and OpenMP, load the `cp2k` module and use the
`cp2k.psmp` executable.

For larger jobs requiing one or more nodes, an exclusive SLURM submission
is appropriate. For example, a job using two nodes (576 cores), with
two cores (OpenMP threads) for each MPI process:

??? info "Exclusive SLURM job submission script for CP2K"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --export=none
    #SBATCH --time=00:20:00

    #SBATCH --nodes=2
    #SBATCH --exclusive

    #SBATCH --ntasks-per-node=188
    #SBATCH --cpus-per-task=2

    #SBATCH --partition=standard
    #SBATCH --qos=standard

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load cp2k

    export OMP_NUM_THREADS=2
    export OMP_PLACES=cores

    srun cp2k.psmp -i H2O-0512.inp
    ```
    In this example, SLURM allocates two nodes based on `--nodes=2` and
    `--exclusive`, and the `srun parameters are controlled via
    `--ntasks-per-node=188` and `--cpus-per-task=2` inherited from
    the environment, together with `OMP_NUM_THREADS=2`.

    A valid budget may be required, e.g.,
    ```
    #SBATCH --account=z00`
    ```
A relatively small CP2K job requiring less than a full nude should be
run in non-exclusive mode. E.g., A job requiring 18 MPI processes each
with two threads might be:

??? info "Non-exclusive SLURM job submission for CP2K"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --export=none
    #SBATCH --time=00:20:00

    #SBATCH --partition=standard
    #SBATCH --qos=standard

    #SBATCH --ntasks=18
    #SBATCH --cpus-per-task=2

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load cp2k

    export OMP_NUM_THREADS=2
    export OMP_PLACES=cores

    srun cp2k.psmp -i H2O-0064.inp
    ```
    This job will use a total of 36 cores.


See [Running Jobs on Cirrus](/user-guide/batch) for further general
information on SLURM submissions.


## Compiling and testing CP2K on Cirrus


### Using Spack

If a specific version of CP2K is required, and this is not available as
a central module, it is possible to build CP2K using Spack.
```
$ module load spack
# spack info cp2k
```

For further information, see

- [Using Spack on Cirrus](/software-tools/spack)
- [Building CP2K using Spack](]https://manual.cp2k.org/trunk/getting-started/build-with-spack.html) from the CP2K documentation


### Builds using the toolchain

The recommendation for developers who wish to build their own version is
to use the toolchain build process.

FURTHER INFORMATION PENDING
