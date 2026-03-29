# Profiling using PerfTools

In this section, we discuss the HPE Cray PerfTools performance
measurement and analysis tool, accessed via various `perftools` modules.
These tools are also referred to as CrayPat-lite or CrayPat (from an
earlier name Performance Analysis Toolkit).

PerfTools can be used with compiled programs (typically C/C++ or Fortran),
interpreted python, and for executables where the source code is not
available. The PerfTools modules admit a very general and flexible
approach to profiling, depending on the level of user experience. We
start with the least invasive approach, and then describe methods
requiring increasing levels of user intervention.


## Generating a profile with `pat_run`

For an existing executable, or for a python script, a simple profile
can be generated with minimal intervention using `pat_run`. This is
also relevant for executables for which the source code is not
available (but are dynamically linked).

### Existing executable

1. Make sure the `perftools-base` module is loaded. This provides the
   common underlying functionality of PerfTools, and should be present
   by default.

2. Run the application in the usual way, but insert `pat_run` just
   before the executable name:
   ```
   srun --ntasks=36 pat_run ./myapp.x
   ```

3. At the start of execution, a new directory will appear in the current
   working directory which contains
   the profiling data files. The default directory name is that of the
   executable followed by a unique series of numbers for each profiling
   instance, e.g., `myapp.x+2048522-1010655545s`.

4. To produce a summary report of the profiling data, run `pat_report`
   with the new directory name as the argument, e.g.,
   ```
   pat_report myapp.x+2048522-1010655545s
   ```

   The typical output will provide a summary, and a series of tables which
   are discussed in more detail in the following sections.
??? info "Typical PerfTools summary output using `pat_run`"
    ```
    CrayPat/X:  Version 25.03.0 Revision 5ef9ac5bb rhel9.5_x86_64  01/22/25 23:09:16
    Number of PEs (MPI ranks):    36
    Number of Nodes:               1
    Numbers of PEs per Node:      36
    Numbers of Threads per PE:     1
    Number of Cores per Socket:  144
    Execution start time:  Wed Dec  3 14:28:07 2025
    System name and speed:  cs-n0000  2.326 GHz (nominal)
    AMD   Turin                CPU  Family: 26  Model: 17  Stepping:  0
    Core Performance Boost:  288 PEs have CPB capability
    ...
    ...
    ```
    Further output is omitted.


### Python

Support for python profiling when using module `cray-python` is
available. For example,
```
module load cray-python
srun --ntasks=36 pat_run $(which python3) myapp.py
```
Note that the absolute path to the python interpreter is used after `pat_run`.
Again, a summary report can be generated with `pat_report`, e.g.:
```
module load cray-python
pat_report myapp.py+2048522-1010655545s
```

## Profiling following re-compilation

To allow PerfTools access to fuller information about a compiled program,
re-compilation is required to allow the introduction of instrumentation.
There are a number of ways to do this using PerfTools. A lightweight
starting point is to use the `perftools-lite` module.

### perftools-lite

1.  Make sure the `perftools-base` module is loaded (it should be present
    by default), and load `perftools-lite` in addition:
    ```
    module load perftools-lite
    ```

2.  Compile your application normally (make sure any existing objects are
    removed). A message will appear at the link stage
    indicating that the executable has been instrumented. For example:

    ```
    cc -o myapp.x myapp.c
    INFO: creating the PerfTools-instrumented executable 'myapp.x' (lite-samples)
    ```
    You must use the compiler wrappers `cc`, `CC` or `ftn`.

3.  Run the new executable by submitting a job in the usual way.
    There are no special additions related to profiling once
    the executable exists. E.g.,
    ```
    srun --ntasks=36 ./myapp.x
    ```

4.  At the start of execution, a new directory will be created to hold
    the profiling data files. The directory name is based on the
    executable name and a unique string of numbers for each profiling
    run, e.g., `myapp.x+1607079-1010655545s`. Note the `s` at the end,
    indicating this was a sampling exercise.

5.  When the job finishes executing, summary profile report will be
    directed to standard output (i.e., at the end of the job's output file).

    The `perftools` report is structured as a series of tables which are
    designed to be self-explanatory.
??? info "Typical PerfTools sampling output via `perftools-lite`"
    ```
    ...
    Summary output omitted
    ...
    Table 1:  Sample Profile by Function

    Samp%     |    Samp |  Imb. |  Imb. | Group
              |         |  Samp | Samp% |  Function
              |         |       |       |   PE=HIDE

       100.0% | 6,113.2 |    -- |    -- | Total
     |-----------------------------------------------------------------
     |  92.5% | 5,654.4 |    -- |    -- | USER
    ||----------------------------------------------------------------
    ||  22.4% | 1,371.3 |  86.7 |  6.1% | function_a
    ||  11.0% |   674.6 |  61.4 |  8.6% | function_b
    ||   8.9% |   545.9 |  59.1 | 10.0% | function_c
    ||   8.2% |   502.8 |  26.2 |  5.1% | function_d
    ||   7.8% |   474.5 |  18.5 |  3.9% | function_e
    ||================================================================
     |   3.9% |   235.7 |    -- |    -- | MPI
    ||----------------------------------------------------------------
    ||   3.6% |   222.8 | 213.2 | 50.3% | MPI_Waitall
    ||================================================================
    ...
    ...
    ```
    In this incomplete example, the table provides an overview of the
    propartion of the time (i.e., the samples) spent in different parts
    of the code. Over 90% of the time is spent in the user code, and 3.9%
    of time is spent in message passing (MPI). By default, only a subset
    of the most significant functions are shown. Further output is omitted.

For `perftools-lite` the default profiling is a sampling exercise,
where a statistical picture of performance is obtained based on the
proportion of samples taken in different parts of the program.
The report should include the default sampling interval:
```
Sampling interval:  10000 microsecs
```
This choice should keep the overhead of profiling low compared to running
the program without profiling.


### `perftools-lite-events`

In the bare `perftools-lite` sampling approach, a statistical picture
of performance is obtained. If more detailed information is required,
an event-based approach can be employed. This is typically based on
the time-stamp of events such as the entry to and exit from a
particular function. This comes at the cost of higher overhead in time
taken and the size of the report files generated.

To prepare an executable for event profiling, follow the same process
as for sampling, that is:


1.  Make sure the `perftools-base` module is loaded and load the
    `perftools-lite-events` module

    `module load perftools-lite-events`

2.  Compile your application normally. For example:

    ```
    ftn -o myapp.x myapp.f90
    INFO: creating the PerfTools-instrumented executable 'myapp.x' (lite-events)
    ```

3.  Run the new executable by submitting a job in the usual way.

4. Analyse the data. Again, a summary will appear at the end of execution
   in the standard output. As this is now event-based, additional information
   such as the exact number of calls to a given function can be presented.

??? info "Example PerfTools event output via `perftools-lite-events`"
    ```
    ...
    Summary output omitted
    ...

    Table 1:  Profile by Function Group and Function

    Time%     |      Time |     Imb. |  Imb. |        Calls | Group
              |           |     Time | Time% |              |  Function=[MAX10]
              |           |          |       |              |   PE=HIDE
              |           |          |       |              |    Thread=HIDE

       100.0% | 15.801060 |       -- |    -- | 10,958,605.4 | Total
    |-----------------------------------------------------------------------------
    |   89.9% | 14.203748 |       -- |    -- | 10,932,614.3 | USER
    ||----------------------------------------------------------------------------
    ||  13.9% |  2.191225 | 0.094256 |  4.3% |  1,621,433.3 | function_a
    ||  11.3% |  1.781757 | 0.029626 |  1.7% |        100.0 | function_b.LOOP@li.164
    ||   8.3% |  1.311064 | 0.045393 |  3.5% |  1,621,433.3 | function_c
    ||   6.7% |  1.054684 | 0.050999 |  4.8% |        100.0 | function_d.LOOP@li.264
    ||============================================================================
    |    5.4% |  0.856573 |       -- |    -- |     23,434.0 | MPI
    ||----------------------------------------------------------------------------
    ||   5.0% |  0.792062 | 0.297903 | 28.5% |        313.0 | MPI_Waitall
    ||============================================================================
    |    2.5% |  0.388409 |       -- |    -- |      2,030.0 | OMP
    |=============================================================================
    ```
    In contrast to the sampling approach, event-based profiling can provide
    the actual time (seconds) spent in various parts of the program, along
    with the exact number of calls to particlular functions. As compile
    time information is available based on the source code, the profiler is
    also be able to associate time with specific line numbers in the code.

Profiling with events can generate large amounts of data, so it is
best to start with a small problem size of short duration. Additional
measures to reduce the overhead of profiling by targeting specific
part of a program are also discussed below.


## Viewing profiling data

### Using `pat_report`

The default reports produced by `perftools-lite` and `perftools-lite-events`
give information on a relatively small number of the most significant
routines in the instrumented program in terms of samples, or time taken.
The `pat_report`
utility can be used to interrogate the profiling data to give additional
information, particularly when event tracing is used.

The report format can be controlled with the `-O` flag to `pat_report`.
A number of examples are:

  - `-O calltree`
  Show top-down call tree with inclusive times (or samples).
  - `-O callers`
  Show the calls leading to the routines that have a high use in the
  report (bottom-up).
  - `-O callers+src`
  Append the relevant source code line numbers in the callers list.
  - `-O load_balance`
  Show load-balance statistics for the high-use routines in the program.
  Parallel processes with minimum, maximum and median times for routines
  will be displayed. Only available with event profiling.
  - `-O mpi_callers`
  Show MPI message statistics. Only available with event profiling.

Other `pat_report` options include:

  - `-T` Set threshold for reporting to zero; this will show all functions
    called by the program.
  - `-v` Give verbose information and suggestions in the Table notes.

See `man pat_report` for further information.

### Using the Apprentice GUI

A graphical user interface to PerfTools results is provided by Apprentice,
for which a suitable X-windows LINK PENING connection will be required.

Apprentice is invoked with, e.g.,
```
module load perftools-base
app3 myapp.x+606388-1010655545t
```
where the `myapp.x+606388-1010655545t` is the relevant profiling directory.
The text report (cf `pat_report`) or various graphical representations can
be explored.



## General `perftools` instrumentation

The `perftools-lite` and `perftools-lite-events` modules provide a simple
way to generate sampling and event-based profiles, respectively. However,
for a large production run, event sampling might come with an unduly
large overhead. In this situation, it would be disirable to be able to
combine the low overhead of the sampling approach with the detail generated
by the event-based profile. This can be done using the general `perftools`
module.


### Sampling via `pat_build`

1.  Ensure the `perftools-base` module is loaded, and load the `perftools`
    module:
    ```
    module load perftools
    ```

2.  Compile or re-compile your code using the compiler
    wrappers (`cc`, `CC` or `ftn`). Object files (or libraries) need to be
    made available to PerfTools to be able to build an instrumented
    executable for profiling.
    This may mean that the compile and link stage need to be
    separated, e.g..
    ```
    cc -c myapp.c
    cc -o myapp.x myapp.o
    ```

3.  To instrument the binary, use the `pat_build` command. This will
    generate a new executable with `+pat` appended, e.g.:
    ```
    pat_build myapp.x
    ```
    will generate a new executable `myapp.x+pat` (it will leave the
    original unchanged).

4.  Run the new executable with `+pat` extension to generate a sampling
    result. This will produce a new directory with the raw sampling
    results, e.g., `myapp.x+pat+540878-1010655545s`.

5.  At this point the sampling results directory will contain a single
    subdirectory with the raw results (typically `xf-files`). Use
    `pat_report` to generate a report in the usual way. This will
    also create a new file in the results directory called
    `build-options.apa`.

### Targeted event profiling

What we can now do is to use the sampling information produced by the
program with the `+pat` extension to generate an event based profile
which consists of only those routines identified in the sampling as
significant. This reduces the overhead of the event profiling.

1. Generate a further executable using `pat_build` from the build options
   file produced at the previous sampling report stage, e.g.:
   ```
   pat_build -O myapp.x+pat+540878-1010655545s/build-options.apa
   ```
   The new execytable will have the exetension `myapp.x+apa` (for
   automatic program analysis).

2. Run the new executable with the `.apa` extension to produce a
   new event-based profile. This with create a new results
   directory, e.g., `myapp.x+apa+933004-1010655545t`. The `t` at
   the end of the directory name indicates this is a trace, or
   event-based profile.

3. A report on the new event-based profile can now be generated
   in the usual way using `pat_report`.


### Manual event specification

If the automatic program analysis does not produce the correct events,
`pat_build` can be used to specify explicitly the set to be collected.
The are a number of options to do this, e.g.:

1. `pat_build -w myapp.x` selects all functions/events.

2. `pat_build -w -g mpi myapp.x` selects a group of functions (here MPI
   calls). Other groups include `libsci`, `lapack`, `omp` (for OpenMP
   runtime API functions).
3. `pat_build -T function1 myapp.x` selects a named function (this is
   the mangled name for Fortran and C++).

See the manual page for `pat_build` for further details.

### Hardware counter groups

Profiling will collect a default set of hardware counters
which will appear int the report, e.g.,
```
  PAPI_TOT_CYC      2,664,774,564,580   # Total number of CPU cycles
  PAPI_TOT_INS      5,310,155,653,321   # Instructions completed
  PAPI_TLB_DM             125,957,932   # Translation lookaside buffer misses
  PAPI_FP_OPS       3,437,814,054,580   # Floating point operations
```
(the annonations are added here). A number of different groups are
available which can be selected via the environment variable, e.g.,
```
export PAT_RT_PERFCTR=fp_stats
```
to select floating point operations. Only one counter group can be
selected in any one profileing run. A full list of individual
counter descriptions is given by
```
papi_avail
```
which also indicates whether the counters are available or not.


## Further information

Additional information is available interactively via `pat_help`, and via
man pages for `pat_report`, `pat_build` etc.

* [HPE Performance Analysis Tools User Guide](https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=a00123563en_us)
