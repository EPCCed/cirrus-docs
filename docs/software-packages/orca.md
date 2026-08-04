# ORCA

ORCA is an ab initio quantum chemistry program package that contains modern electronic structure methods including density functional theory, many-body perturbation, coupled cluster, multireference methods, and semi-empirical quantum chemistry methods. Its main field of application is larger molecules, transition metal complexes, and their spectroscopic properties. ORCA is developed in the research group of Frank Neese. The free version is available only for academic use at academic institutions.

!!! warning "ORCA calculations cannot use multiple compute nodes"
    As ORCA depends on OpenMPI 4.x and OpenMPI 4.x does not support using
    the Slingshot 11 interconnect on Cirrus, single, parallel ORCA calculations
    cannot span multiple compute nodes. As there are not many cases where 
    scaling beyond 288 parallel processes makes sense when using ORCA this
    should not prove particularly restrictive.

## Useful Links

- [ORCA Website](https://www.faccts.de/orca/)
- [ORCA Forum](https://orcaforum.kofo.mpg.de/app.php/portal)

## Using ORCA on Cirrus

ORCA is available for academic use only on Cirrus. If you wish to use ORCA for commercial
applications, you must contact the ORCA developers.

!!! tip "Register for ORCA"
    You should register for use of ORCA on the [ORCA Forums](https://orcaforum.kofo.mpg.de).
    This also gives you access to ORCA support and visibility of previous questions and
    answers.

## Running parallel ORCA jobs

The following script will run an ORCA job on the 
system using 12 MPI processes on a single node, each MPI process will be placed on a separate
physical core. It assumes that the input file is `my_calc.inp`.

!!! important "Parallelism must also be set in the ORCA input file"
    You must also specify the number of parallel processes you want
    to use in your ORCA input file and this **must** match the number
    of parallel tasks specified in your Slurm job submission script.
    For the example below (using 12 parallel tasks), the input file
    should contain a line similar to:
    ```
    %PAL NPROCS 12 END
    ```

```slurm
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --time=0:20:00

# Replace [budget code] below with your project code (e.g. e05)
#SBATCH --account=[budget code]
#SBATCH --partition=standard
#SBATCH --qos=standard

module load orca

# Launch the ORCA calculation
#   * You must use "$ORCADIR/orca" so the application has the full executable path
#   * Do not use "srun" to launch parallel ORCA jobs as they use OpenMPI rather than Cray MPICH
#   * Remember to change the name of the input file to match your file name
$ORCADIR/orca my_calc.inp
```

