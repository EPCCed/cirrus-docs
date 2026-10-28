# Energy consumption, emissions and responsible computing

This section covers responsible computing, in terms of environmental sustainability, energy use and greenhouse gas (GHG) emissions from Cirrus.

The monitoring energy use section describes how to measure the compute node energy consumption of your jobs on Cirrus and use this to estimate total energy consumption.

The emissions section describes how to estimate emissions from your use of Cirrus and the methodology we have used to produce emissions estimates for the service.

Following the Cirrus-specific energy and GHG emissions sections, there is a section covering approaches to producing a *Responsible Computing Plan* coving your project.

## Monitoring energy use

The Slurm accounting database stores the total energy consumed by a job and you can also directly access
the counters on compute nodes which capture instantaneous power and energy data broken down by different
hardware components.

### Using sacct to get energy usage for individual jobs

Energy usage for a particular job may be obtained using the `sacct` command. For instance

```
sacct -j 2658300 --format=JobID,Elapsed,ReqCPUFreq,ConsumedEnergy
```

will provide the elapsed time and consumed energy in joules for the job(s) specified with `-j`.
The output of this command is: 

```
JobID           Elapsed ReqCPUFreq ConsumedEnergy 
------------ ---------- ---------- -------------- 
2658300        02:19:48    Unknown          4.58M 
2658300.bat+   02:19:48          0          4.58M 
2658300.ext+   02:19:48          0          4.58M 
2658300.0      02:19:09    Unknown          4.57M 
```

In this case we can see that the job consumed 4.58 MJ for a run lasting 2 hours, 19 minutes and 48 seconds. To convert the energy to kWh we can multiply the energy in joules by 2.78e-7, in this case resulting in 1.27 kWh. 

!!! tip "Adding in other components and overheads"
    As noted below, the compute nodes (which the energy counters cover) are estimated to make up around 95% of the power draw of the Cirrus system. You can therefore add 5% additional energy to account for energy use by other components (such as storage and interconnect). On top of that, the overheads from power supply and cooling are estimated at an average of 10% so you can add an additional 10% energy to include these overheads.

The Slurm database may be cleaned without notice so you should gather any data you want as soon as possible after the job completes - you can even add the `sacct` command to the end of your job script to ensure this data is captured.

In addition to energy statistics `sacct` provides a number of other statistics that can be specified to the `--format`
option, the full list of which can be viewed with

```
sacct --helpformat
```

or using the `man` pages. 

### Accessing the node energy/power counters

!!! note
    The counters are available on each compute node and record data only for that compute node. If you are
    running multi-node jobs, you will need to combine data from multiple nodes to get data for the whole
    job. 

On compute nodes, the raw energy counters and instantaneous power draw data are available at:

```
/sys/cray/pm_counters
```

There are a number of files in this directory, all the counter files include the current value and a timestamp.

- power - Point-in-time power (Watts).
- energy - Accumulated energy (Joules).
- cpu_power - Point-in-time power (Watts) used by the CPU domain.
- cpu_energy - The total energy (Joules) used by the CPU domain.
- cpu*_temp - Temperature reading (Celsius) of the CPU domain - one file per CPU socket.
- memory_power - Point-in-time power (Watts) used by the memory domain.
- memory_energy - The total energy (Joules) used by the memory domain.
- generation - A counter that increments each time a power cap value is changed.
- startup - Startup counter.
- freshness - Free-running counter that increments at a rate of approximately 10Hz.
- version - Version number for power management counter support.
- power_cap - Current power cap limit in Watts; 0 indicates no capping.
- raw_scan_hz - The power management scanning rate for all data in pm_counters.

This documentation is from the official HPE documentation:

- [HPE Cray Operating System Administration Guide: CSM on HPE Cray EX
Systems](https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=dp00002748en_us)

!!! tip
    The overall `power` and `energy` counters include all on-node systems. The major components
    are the CPU (processor), memory and Slingshot network interface controller (NIC).

## Emissions

In this section we provide a brief overview of greenhouse gas (GHG) emissions sources relevant to Cirrus, show how we have estimated the emissions associated with the service and describe how users can estimate emissions associated with their use of Cirrus.

### Impact on reducing emissions

As well as a producer of GHG emissions, HPC systems like Cirrus also contribute to reducing emissions. The main source of reduced emissions from services such as Cirrus is in the research that leads to new technology, policies and approaches to reducing emissions. Some examples include:

- HPC services run the climate models that are used to provide evidence for setting emissions reductions policies and targets across the world.
- Research and modelling on HPC services leads to development of improved zero emission energy generation by, for example, modelling new wind turbine and wind farm designs.
- Modelling to support the development of new energy storage technologies such as improved batteries.

The emissions reductions from such activities are extremely difficult to quantify for a number of reasons so, at the moment, these are not factored in to the emissions estimates for Cirrus.

As well as the research activities on the service leading to reductions in emissions, there are other activities that HPC services can potentially take. For example:

- Using the waste heat generated by large scale HPC services as a heat source for homes, businesses or farming. For the ACF data centre where Cirrus is hosted we are looking for options on how to do this.
- Incorporating environmental and biodiversity improvements into the service. For the ACF data centre (which is in a rural location) we have been working to improve the site biodiversity and improve habitats. Responsible carbon offset schemes could also potentially be used to reduce emissions if they were undertaken as part of the service.

### Emission sources

The emissions from Cirrus potentially fall into two categories (wording inspired by the Green Software Practitioner course linked below):

- Scope 2: Indirect emissions related to emission generation of purchased energy, such as heat and electricity. On Cirrus this would correspond to any emissions from the electricity used by the service. As we will see, the Scope 2 emissions are reported as zero because the energy contract for the service is based on 100% renewable energy.
- Scope 3: Other indirect emissions from the service. For Cirrus, this corresponds to the embodied emissions of the hardware and infrastructure from the service, i.e. the emissions from manufacturing, shipping and decommissioning Cirrus hardware and supporting physical infrastructure.

The other class of emissions (Scope 1) are not directly relevant for the Cirrus service:

- Scope 1: Direct emissions from the service, such as on-site fuel combustion or fleet vehicles. We have not evaluated this for the Cirrus service

If you want to learn more about GHG emissions in the area of HPC then you may want to 
look at the Carpentries Incubator [Green Software Use on HPC course](https://carpentries-incubator.github.io/green-software-hpc/) developed by EPCC.

### Cirrus emissions

!!! important
    All Cirrus emissions are estimated and you should understand that there is the potential for
    significant variation from the current values as understanding of emissions values and 
    sources improves. 

#### Embodied (upstream scope 3) emissions

Embodied (upstream scope 3) emissions from the Cirrus hardware have been estimated from a subset of the components
that are expected to make up the majority of the emissions. Note that there is a large amount of uncertainty for
embodied emissions due to lack of high quality emissions data or a standardised approach for calculating these
emissions. 

We have used the methodology from Tailpipe (which is based on the Boavizta approach) to estimate the embodied
emissions from Cirrus:

- [Tailpipe methodology](https://tailpipe.ai/methodology/embodied-emissions-methodology/)
- [Boavizta approach](https://boavizta.org/en/blog/empreinte-de-la-fabrication-d-un-serveur )

| Component | Estimated kgCO<sub>2</sub>e | % Total Scope 3 |
|---|--:|--:|
| Compute nodes | 891,000 | 50% |
| Interconnect switches | 24,000 | 1% |
| Storage | 883,000 | 49% |
| Total | 1,798,000 | 100% |

We then estimate the per-CU (nodeh) embodied emissions by assuming a service lifetime of 6 years and
100% availability:

```
1,798,000 kgCO2e / (640 nodes x 288 cores per node x 6 years x 365 days x 24 hours) = 0.000186 kgCO2e/coreh
```

We use a value of **0.000186 kgCO<sub>2</sub>e/coreh** for Cirrus.

#### Operational (scope 2) emissions

Operational (scope 2) emissions from Cirrus are zero as the service is supplied by 100% certified renewable energy.
For information purposes we can calculate what the operational emissions would have been if the energy
was not 100% renewable energy using the methodology described below.

We are aware that there is ongoing discussion in the sustainability community about the impact and
effectiveness of certified renewable energy contracts that are supplied through UK National Grid
connections. We are monitoring these discussions and taking advice from sustainability professionals
on how we report and estimate Cirrus emissions.

UK National Grid based operational emissions are calculated using the compute node energy use for particular
jobs along with the carbon intensity of the South Scotland region of the UK National Grid at the start
time of the job. The carbon intensity is retrieved from the [carbonintensity.org.uk](carbonintensity.org.uk)
web API.

The compute node energy use for jobs is computed in one of two ways, depending on if exclusive node access is used for the job or not.

- Whole node jobs: energy taken from Slurm (which come from Cray PM counters as described above)
- Jobs sharing node: energy calculated from a value of 0.0041 W/core

Estimates of power draw of individual components of ARCHER2 suggest that the compute node power draw makes up
around 95% of the system power draw so to estimate energy use by additional components we add
5% of the measured compute node energy.

The estimates above do not include overheads from the electrical
and cooling plant, these will vary with outside weather conditions at the data centre but are typically
less than 10%. As a conservative estimate, we add an additional 10% energy use to the total to 
account for plant overheads. 

The final energy calculation for a job is therefore:

1. Calculate compute node energy use (either using Slurm reported energy or using 0.0041 W/core)
2. Add an additional 5% of this compute node energy use to estimate energy use by other components.
3. Add an additional 10% of the new total energy use to estimate energy use overheads from plant.

## Responsible Computing Plans

### What is a Responsible Computing Plan?

A *Responsible Computing Plan* is a document that ensures positive environmental impacts are captured and plans the project lifecycle to achieve project goals with minimal negative environmental impact. It is a living document that reacts to changes in the project rather than being prescriptive. 

There is often a disconnect between use and awareness of resources used in research computing. The default position is frequently to use more resources to achieve progress rather than think carefully about the most efficient way to achieve results. This is sometimes described as "reaching for the bigger hammer rather than the right tool."

Responsible Computing Plans help address this by:

- Providing the opportunity to think explicitly about the environmental impact of your computing choices
- Encouraging careful planning to minimise resource use and maximise resource efficiency
- Ensuring environmental considerations are built into the way the project is run throughout its lifetime 

This section frames responsible computing plans in the context of research projects but, with some thought, they can be adapted for use more widely. 

While they are most impactful if used before a project or activity starts and throughout its lifetime by the whole project team; they can be used at any point in a project or activity lifecycle and by subsets of people or even individuals to bring environmental benefits. 

In this section, we cover four main aspects of responsible computing plans to give you an idea of how to go about putting one together:

Evaluate positive environmental impacts 
: While we often focus on the negative environmental impacts of projects, it is important to try and evaluate any positive environmental impacts, both qualitative and quantitative.

Plan to minimise impact
: Looking at how we can plan projects and activities to minimise environmental impact, encourage good practice and behaviour and be as efficient as possible while still achieving the project goals.

Run the project responsibly
: While planning is important, following through on the plans and adapting to change as the project evolves is critical to working in an environmentally sustainable way.

Finish the project well
: One of the most challenging aspects of research projects is finishing them up in a way that makes the knowledge and outputs useable in a way that means future work can build on them without incurring unnecessary additional resource use. This is typically associated with ensuring project outputs and products conform to [FAIR principles](https://www.go-fair.org/fair-principles/).

### Evaluate positive environmental impacts

We will look at minimising the negative environmental impacts in the rest of this section, but the first step in developing responsible computing plan is taking some time to evaluate the positive environmental impacts of the work. Ideally, the impacts would be evaluated or estimated quantitatively but this may not always be possible and you may need to include more qualitative statements. You should consider direct, indirect and community/activism impacts.

The aim of the statement is to help justify the environmental cost of the computing resources used by highlighting the environmental benefits the project will deliver.

- Direct impacts: New approaches/technologies, efficiency improvements, understanding/quantifying polycrisis impacts
- Indirect impacts: Fundamental research to enable new approaches/technologies, model improvements
- Community/activism impacts: Adding awareness/skills in environmental issues, demonstrating leadership in environmental sustainability, normalising action

Some examples of direct, indirect and community/activism positive impacts can be found in the table below:

| Direct Impacts | Indirect Impacts | Community/activism impacts |
|:--|:--|:--|
| Developing a new, more efficient wind turbine | Research to understand possible new battery materials | Ensuring that environmental impact is publicly stated in all project outputs |
| Improving/evaluating biodiversity in a habitat | Developing improved climate modelling approaches | Developing training to raise awareness/understanding of environmental issues |
| Enabling reuse of water that would otherwise be wasted | Developing AI approaches that reduce the need for costly simulations | Organising events that normalise action to reduce environmental impacts in your research field |
| Running modelling to support IPCC reports and targets | Developing and using responsible computing plans for your projects | Gaining [GreenDiSC certification](https://www.software.ac.uk/GreenDiSC) for your research group |

### Planning projects

Planning the project with environmental sustainability in mind is typically the time when you can have the largest impact. Planning to run the project in a responsible way almost always makes the project more impactful and robust from a non-environmental standpoint too.

We will look at both compute resource use and data resource use and also selecting appropriate HPC resources for the project. Which of these is more important for your project/activity depends on the type of work you are doing. For most HPC work, compute resource use will dominate the emissions from the activity but if you use a relatively small amount of compute compared to data resources it could be a different story. You can use approaches such as the [Green Software Foundation Software Carbon Intensity (SCI)](https://grnsft.org/sci) or the related [HPC-CI](https://carpentries-incubator.github.io/green-software-hpc/measurement.html#hpc-carbon-intensity-hpc-ci-specification).

#### Responsible compute resource use

*Reduction of consumption* is the central tenet of reducing environmental impact. Planning to use minimal compute resources to achieve the project aims is critical. Some high level points to consider: 

- Look for existing datasets that you can use rather than repeating calculations
   - This is not all or nothing – existing data may help you make any use the most impactful use of resources
- Ensure that all planned use will contribute meaningful data points
   - If the project involves sampling, select a sampling distribution that maximises information per point
   - For example, a regular sampling grid at finest resolution is unlikely to be the most efficient use – minimise data points in regions of little change
- When running parallel calculations – using the smallest number of cores/nodes that take a reasonable time is usually the most efficient from an environmental standpoint

We now take a quick look in more detail at two aspects of planning compute resource use:

- The impact of testing before and during a project on environmental impact
- Making sure that environmental sustainability is considered when selecting the methods and approach to use

##### Testing before large-scale use

Test that the proposed methodologies will likely give viable results before embarking on large amounts of resource use:

- Review literature carefully
- Discuss the planned approach with experienced researchers
- Undertake pilot studies before committing to large resource use

You often do not need to run at full scale to test if the selected method is viable – shorter runs, reduced datasets or other reductions can give confidence in the proposed resource consumption estimates.

##### Selecting appropriate methods

Use methods proportionate to the project objectives rather than automatically choosing the most complex/advanced/higher resolution option:

- When planning a project, think carefully about the tools and methods you will use
- Some newer tools are more efficient than older ones, but not always
- Some computationally intensive approaches, including some machine learning methods, may not improve enough on simpler methods to justify their extra cost
- Think about redundancy – are you planning to compute too many datapoints or look at too many similar problems which will not provide substantial new information?
- Build smaller scale benchmarking and testing into the project plan to ensure the correct scale setup is chosen for each step (or when plans change)

#### Responsible data resource use

Many projects already produce data management plans, and these typically align well with responsible resource use. The questions that would be asked are similar to those for a data management plan. For example, questions such as:

- Do we really need to keep all intermediate files for a long period of time?
- Does each collaborator need their own copy of the dataset?
- Can rarely used data be compressed or moved to archival storage throughout the project?
- Have we planned time to review and tidy data during the project?

Additionally, build plans to publish data using a *FAIR approach* throughout the project (more on this in the "Finishing the project" section).

#### Selecting HPC resources

Projects often have choices of HPC facility to use for different parts of the project. With environmental sustainability in mind, the choice depends on considerations of the principles we covered earlier in this course: hardware efficiency, energy efficiency and carbon awareness.

Some high level notes:

- Use existing resources where possible – making use of existing resources is usually the most sustainable approach
- Shared resources are often a more sustainable choice - they usually achieve higher utilisation over their lifetimes (though this is not always the case for specialist use cases)

Beyond these very high level considerations, you are looking for facilities that have the lowest emissions per unit of resource used. The following rules can help you do this:

First, select a facility to minimise operational emissions:
  - Use HPC facilities in locations that have the lowest emissions from electricity generation
  - This usually corresponds to them being sited in locations with lowest national grid carbon intensities
  - Can also be that they have direct connections to renewable energy sources
  - In the UK, if connected to the national grid, this typically means HPC resources located as far North as possible

Once you have done this, the next evaluation points depend on the facility providing estimates of where the emissions come from over the facility lifetime:

- If embodied emissions are a significant fraction of lifetime emissions, then you should assume you will use the facility in a way the maximises performance per unit of resource.

- If operational emissions are the dominant factor in the lifetime emissions, then you should assume you will use the facility in a way to maximise the energy efficiency of your use.

Looking at these points for the range of possible HPC facilities available to you should help you to make the most emissions-efficient decision on which HPC facility (or facilities) to use for the project.

### Running the project

Re-planning is often needed during research projects as objectives might change, new methods may need to be employed, or new data may become available. Principles for responsible computing can be built into a research project throughout its execution.

#### Run software carefully

Reducing waste of resources is key to using HPC in a sustainable way. The disconnect between using resources and visible consumption inherent in HPC use (where the resource you are using is remote and not visible to you in an immediate way) makes it easier to waste resources.

Points to consider include many things we have already discussed but must be kept in mind throughout the project:

- Plan testing of software and scripts on a smaller scale before running in ways that can consume large amounts of resource
- Plan to run appropriate benchmarking before committing to large usage to ensure you are using resources efficiently (cores, memory, IO, etc.)
- Smallest number of cores/nodes is almost always the most emissions efficient for parallel calculations – how fast do you really need results?
- Plan to revisit and replan if the research direction changes in terms of software, method, problem size, etc.
- Consider using carbon intensity forecasts to schedule work at a lower-carbon time (if that is possible on the facility you are using)
- Before running work, ensure you are recording enough information to avoid rerunning this work unnecessarily

#### Optimise where it matters

Many projects waste time optimising workflows in areas that will make a negligible impact on reducing environmental impact (or even performance) or optimise inefficiently due to lack of specialist support.

- Find the locations where optimisation will likely have the largest impact
    + Remember, you may get a larger impact from running carefully without ever needing to get involved with programming
- Make sure you have some plan to measure the impact of any changes (e.g., using SCI/HPC-CI)
- Enlist the support of specialists** to analyse and optimise your workflow
    + For example, many institutions have a [local Research Software Engineering team](https://society-rse.org/community/rse-groups/) who are well placed to help

### Finishing the project

In environmental sustainability terms, planning how a project will be finalised means:

- Ensuring that calculations do not need to be needlessly re-run for outcomes related to the project
- Ensuring that the right data is kept in a useful form
- Deleting data that is no longer needed
- Ensuring work can be re-used effectively in future work

For example, the following points could be considered:

- Which data genuinely need to be retained and what can be deleted?
- Could publishing this data or code reduce duplicated work elsewhere?
- Have I left enough documentation for others to reuse what has been done?

Finishing a project well typically corresponds to applying *FAIR principles**.

#### FAIR data principles

The FAIR data principles provide a framework for ensuring data is:

1. **Findable** – Easy to find by both humans and computer systems and based on mandatory description of the metadata that allow the discovery of interesting datasets

2. **Accessible** – Stored for long term such that they can be easily accessed and/or downloaded with well-defined license and access conditions (Open Access when possible), whether at the level of metadata, or at the level of the actual data content

3. **Interoperable** – Ready to be combined with other datasets by humans as well as computer systems

4. **Re-usable** – Ready to be used for future research and to be processed further using computational methods

- [How to go FAIR](https://www.go-fair.org/how-to-go-fair/)

By following FAIR principles, you ensure that:
- Your data can be found and used by others (and your future self)
- Work does not need to be duplicated
- The environmental cost of data generation is amortised over maximum reuse
- Research is more impactful and efficient overall

### Summary: Responsible Computing Plan

A Responsible Computing Plan with an HPC focus should cover:

### Before the project starts
- Write a positive environmental impact statement
- Plan to minimise resource consumption
- Build testing and benchmarking into the project plan
- Select appropriate methods and scales
- Plan responsible data management
- Choose HPC resources based on emissions efficiency

### During the project
- Test at small scale before large runs
- Benchmark to ensure efficient resource use
- Use the minimum resources needed
- Consider carbon intensity when scheduling
- Record enough information to avoid reruns
- Optimise where it will have the most impact
- Seek specialist support when needed

### At the end of the project
- Delete unnecessary data
- Publish data and code following FAIR principles
- Document work for future reuse
- Ensure calculations do not need to be rerun

Remember: an RCP is a living document that should evolve as your project develops, not a prescriptive checklist to be completed once and forgotten.
