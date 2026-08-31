# Main similarities/differences between Cirrus NCR and ARCHER2

This section provides an overview of the main differences between
the ARCHER2 system and Cirrus NCR along with links to more
information where appropriate.

## Similarities

- Cirrus NCR is an HPE Cray EX system like ARCHER2
- Cirrus NCR provides the HPE Cray Programming Environment (CPE)
  in a similar way to ARCHER2 so many of the same libraries, tools
  and compilers are available (though they are more recent versions
  on Cirrus)


## Hardware

- Cirrus is a much smaller system - there are only 640 compute nodes on Cirrus
  (compared to 5860 on ARCHER2)
- There are **no** GPU nodes on Cirrus NCR
- There are 288 cores on a Cirrus NCR compute node rather than 128 on ARCHER2
- Cirrus NCR uses the HPE Cray Slingshot 11 interconnect rather than the 
  Slingshot 10 interconnect used on ARCHER2
- Cirrus NCR compute nodes can access the internet directly
- There are no separate "serial" nodes
- For more information see [the Hardware section in the User Guide](../user-guide/hardware.md)

## Software

- The software provided by the Cirrus support team is delivered via Spack rather
  than manual install processes used on ARCHER2
- We will typically advise that users use Spack to build their own software on 
  Cirrus NCR wherever possible
- A smaller number of research software packages are provided centrally on Cirrus
  compared to ARCHER2
- Cirrus supports the use of the Intel compilers on top of Cray compilers (CCE),
  GCC and AMD compilers (AOCC)
- The current Cray Programming Environment (CPE) on Cirrus (25.03) is newer than the
  CPE on ARCHER2 (23.09) and provides the following versions:
    - CCE 19.0.0 (ARCHER2: CCE 16.0.0)
    - GCC 14.2.0 (ARCHER2: GCC 11.2.0)
    - AOCC 5.0.0 (ARCHER2: AOCC 5.0.0)
    - Intel OneAPI 25.0 (ARCHER2: N/A)
    - Cray MPICH 8.1.32 or 9.0.0 (ARCHER2: Cray MPICH 8.1.27)

## Slurm scheduler configuration

- Many of the partitions and QoS are similar between the two systems.
  See the [Scheduler secion of the User Guide](../user-guide/batch.md)


