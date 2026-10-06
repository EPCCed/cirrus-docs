# Data migration to Cirrus NCR

If you want any of your ARCHER2 data on Cirrus, you must transfer this yourself
using standard data transfer methods as documented in [the ARCHER2 documentation
on data transfer](https://docs.archer2.ac.uk/user-guide/data/#archiving-and-data-transfer).

!!! important
    Globus Online is not yet available on Cirrus for data transfer so you cannot
    use this method at the moment.

!!! tip "Use EPCCFS/NSCDS to move data from ARCHER2 to Cirrus"
    The EPCCFS/NSCDS storage is shared between ARCHER2 and Cirrus so copying data to this
    storage system on ARCHER2 (mounted at `/nscds`) is the simplest way to move your data
    to Cirrus (where it is mounted at `/epccfs`). More details on transferring data in this
    way are given below.

## /home and /work file systems

While Cirrus has /home and /work file systems like ARCHER2, these are completely 
different file systems to the ARCHER2 ones so none of your ARCHER2 data will be
automatically available on Cirrus.

If you have questions about data transfer, please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support-access/user-support/).

## EPCCFS/NSCDS

The EPCCFS/NSCDS storage is shared between ARCHER2 and Cirrus:

- On ARCHER2 it is mounted at `/nscds`
- On Cirrus it is mounted at `/epccfs`

### Copying data to EPCCFS/NSCDS from ARCHER2 file systems (on ARCHER2)

You can use the standard Linux `cp` command to copy data from ARCHER2 file
systems to EPCCFS/NSCDS when you are logged into ARCHER2. For example, to
transfer the file `important-data.tar.gz` from the ARCHER2 `/work` file system to
EPCCFS/NSCDS you would use the following command **on ARCHER2** (assuming you are user `auser`
in project `e05`):

```
cp /work/e05/e05/auser/important-data.tar.gz /nscds/e05/e05/auser/
```

(remember to replace the project code and username with your own username
and project code).

!!! tip "Use rclone parallel local data transfers for large datasets"
    If you are transferring a large amount of data to EPCCFS/NSCDS, you should consider
    using [rclone local data transfer](../user-guide/data.md#local-file-transfer) (perhaps in a 
    serial job submission script) rather than using the basic `cp` command.

