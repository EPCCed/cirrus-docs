# Cirrus migration to E1000 system 

There was a full service maintenance on Tuesday 12th March 2024 from 0900 - 1700 GMT which allowed some major changes on the Cirrus service. 

- [Change of authentication protocol ](#change-of-authentication-protocol)
- [New /work file system](#new-work-file-system)
    - [Note: Slurm pending work will be lost](#note)
- [CSE Module Updates](#cse-module-updates) 



!!! tip
    If you need help or have questions on the Cirrus E1000 migration 
    please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support/)


## Change of authentication protocol  

We changed the authentication protocol on Cirrus from `ldap` to `freeipa`. 

This change was transparent to users but you may have noticed a change from `username@cirrus` to `username@eidf` within your SAFE account. 

You should be able to connect using your existing Cirrus authentication factors i.e. your ssh key pair and  your TOTP token. 

If you do experience issues, then please reset your tokens and try to reconnect. If problems persist then please [contact the service desk](mailto:support@cirrus.ac.uk).

[Further details on Connecting to Cirrus](https://docs.cirrus.ac.uk/user-guide/connecting/ )



## New /work file system

We replaced the existing lustre `/work` file system with a new more performant lustre file system, `E1000`. 

The old `/work` file system will be available as read-only and we ask you to copy any files you require onto the new `/work` file system. 

The old read-only file system was be removed on **15th May 024** so please ensure all data is retrieved by then. 

For username in project x01, to copy data from <br>
`/mnt/lustre/indy2lfs/work/x01/x01/username/directory_to_copy  ` 
<br>to <br>
`/work/x01/x01/username/destination_directory` <br>
you would do this by running:

```cp -r /mnt/lustre/indy2lfs/work/x01/x01/username/directory_to_copy   \  ```
<br>
```/work/x01/x01/username/destination_directory ```


Further details of [Data Management and Transfer on Cirrus](https://docs.cirrus.ac.uk/user-guide/data/ )

<a name="note"></a>
!!! note
    **Slurm Pending Jobs**<br>
    As the underlying pathname for /work will be changing with the addition of the new file system, all of the pending work in the slurm queue will be removed during the migration. When the service is returned, please resubmit your slurm jobs to Cirrus.


## CSE Module Updates

Our Computational Science and Engineering (CSE) Team have taken the opportunity of the arrival of the new file system to update modules and also remove older versions of modules. A full list of the changes to the modules can be found below.

Please [contact the service desk](mailto:support@cirrus.ac.uk) if you have concerns about the removal of any of the older modules. 

