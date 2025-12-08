# Main differences on Cirrus EX4000

!!! important
    This information was last updated on 20 Nov 2025

This section provides an overview of the main differences between
the current Cirrus system and Cirrus EX4000 along with links to more
information where appropriate. It will be udated with more information
as it becomes available.

## Hardware

- There are **no** GPU nodes on Cirrus EX4000
- There are 288 cores on a Cirrus EX4000 compute node rather than 36 on current Cirrus
- Cirrus EX4000 uses the HPE Cray Slingshot 11 interconnect rather than the 
  Infiniband interconnect used on current Cirrus
- For more information see [the Hardware section in the User Guide](../user-guide/hardware.md)

## Software

- The software environment has completely changed to be based on the
  HPE Cray Programming Environment - no modules that were available
  on old Cirrus system are available in the same way on the new Cirrus
  system. The documentation has been updated to cover these changes in 
  details. See:
    - [Software Environment](../user-guide/sw-environment.md))
    - [Application Development Environment](../user-guide/development.md))

## Slurm scheduler configuration

- Many of the partitions and QoS aresimilar between the two systems
  but limits will change. See the [Scheduler secion of the User Guide](../user-guide/scheduler.md))


