# Cirrus migration to E1000 system migration

This section of the documentation is a guide for users migrating to the E1000 taking place in March 2024

It covers:

-  [Change of authentication from ldap to free-ipa](#change-of-authentication-from-ldap-to-free-ipa)
-  [New storage -> Data migration](#new-storage-data-migration)
-  [CSE Module Updates](#cse-module-updates)



!!! tip
    If you need help or have questions on the Cirrus E1000 migration 
    please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support/)


## Change of authentication from ldap to free-ipa: 

This change should be transparent to users and the TOTP and ssh keys should work as previously  
If users do experience issues then please reset your TOTP and ssh keys and try to reconnect. 
If issues persist, then please [contact the service desk](mailto:support@cirrus.ac.uk) 

## New storage -> Data migration

The old data will be made available from the Cirrus login nodes and will be read-ony. 
Users will be asked to migrate any data they require from the old data disks to the new disks on the E1000

Old data is mounted as: <br>
`/mnt/lustre/indy2lfs` with user files being at `/mnt/lustre/indy2lfs/work/`

Need Example command to do this: 

-	Do we just use `mv` or suggest `rsync`? 



!!! note
    Due to the change of location of the data, all pending jobs within slurm will be removed and users will need to resubmit any required jobs to ensure they are submitted with the correct pathname and data destination 


## CSE Module Updates

We are taking the opportunity to update modules and remove outdated modules. 


### TO BE REMOVED (Alphabetical order!)

<table  ><colgroup><col  /><col  /><col  /><col /><col  /></colgroup>
<tbody>
<tr>
<th scope="col">Package/module</th>
<th scope="col">Advice for users</th>
<th scope="col">Documentation?</th>
<th scope="col">Comments</th></tr>
<tr>
<td>altair-hwsolvers/13.0.213</td>
<td>Please contact the service desk if you wish to use Altair Hyperworks.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>altair-hwsolvers/14.0.210</td>
<td>Please contact the service desk if you wish to use Altair Hyperworks.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>ansys/18.0</td>
<td>Please contact the service desk if you wish to use ANSYS Fluent.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>ansys/19.0</td>
<td>Please contact the service desk if you wish to use ANSYS Fluent.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>autoconf/2.69</p></td>
<td>Please use autoconf/2.71</td>
<td>n/a</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">bison/3.6.4<br /></span></p></td>
<td>Please use bison/3.8.2</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>boost/1.67.0</p></td>
<td>Please use boost/1.84.0</td>
<td>n/a</td>
<td><br /></td></tr>
<tr>
<td>
<p>boost/1.73.0</p></td>
<td>Please use boost/1.84.0</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>cmake/3.17.3</p>
<p>cmake/3.22.1</p></td>
<td>Please use cmake/3.25.2</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>CUnit/2.1.3</p></td>
<td>Please contact the service desk if you wish to use CUnit.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>dolfin/2019.1.0-intel-mpi</p>
<p>dolfin/2019.1.0-mpt</p></td>
<td>Dolfin is no longer supported and will not be replaced.</td>
<td><br /></td>
<td>See also RFC 158</td></tr>
<tr>
<td>
<p>eclipse/2020-09</p></td>
<td>Please contact the service desk if you wish to use Eclipse.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>expat/2.2.9</p></td>
<td>Please use expat/2.6.0</td>
<td>n/a</td>
<td><br /></td></tr>
<tr>
<td>
<p>fenics/2019.1.0-intel-mpi</p>
<p>fenics/2019.1.0-mpt</p></td>
<td>Fenics is no longer supported and will not be replaced.</td>
<td><br /></td>
<td>See also RFC158</td></tr>
<tr>
<td>
<p><span>fftw/3.3.8-gcc8-ompi4</span></p>
<p><span>fftw/3.3.8-intel19</span></p>
<p><span>fftw/3.3.9-ompi4-cuda11-gcc8&nbsp;</span></p>
<p><span>fftw/3.3.8-intel18 &nbsp;&nbsp;</span></p>
<p><span>fftw/3.3.9-impi19-gcc8 &nbsp; </span></p>
<p><span>fftw/3.3.10-intel19-mpt225 &nbsp;&nbsp;</span></p>
<p><span>fftw/3.3.10-ompi4-cuda116-gcc8 </span></p></td>
<td>
<p>Please use one of the following</p>
<p><span>fftw/3.3.10-gcc10.2-mpt2.25</span></p>
<p><span>fftw/3.3.10-gcc10.2-impi20.4</span></p>
<p><span>fftw/3.3.10-gcc10.2-ompi4-cuda11.8</span></p>
<p><span>fftw/3.3.10-gcc12.3-impi20.4</span></p>
<p><span>fftw/3.3.10-intel20.4-impi20.4</span></p></td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p><span>flacs/10.9.1</span></p>
<p><span>flacs-cfd/20.1</span></p>
<p><span>flacs-cfd/20.2</span></p>
<p><span>flacs-cfd/21.1</span></p>
<p><span>flacs-cfd/21.2</span></p>
<p><span>flacs-cfd/22.1</span></p>
<p><br /></p></td>
<td>Please contact the helpdesk if you wish to use FLACS.</td>
<td>REMOVE documentation (but not yet)</td>
<td><br /></td></tr>
<tr>
<td>
<p>forge/22.1.3</p></td>
<td>Please use forge/23.1.1</td>
<td>UPDATE REQUIRED</td>
<td>PENDING</td></tr>
<tr>
<td>
<p class="p1"><span class="s1">gcc/6.2.0<br /></span></p></td>
<td>Please use gcc/8.2.0 or later</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">gcc/6.3.0<br /></span></p></td>
<td>Please use gcc/8.2.0 or later</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">gcc/12.2.0-offload<br /></span></p></td>
<td>Please use gcc/12.3.0-offload</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">gdal/2.1.2-gcc</span></p>
<p class="p1"><span class="s1">gdal/2.1.2-intel&nbsp;</span></p>
<p class="p1"><span class="s1">gdal/2.4.4-gcc</span></p></td>
<td>Please use gcc/3.6.2-gcc</td>
<td>n/a</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">git/2.21.0</span></p></td>
<td>Please use git/2.37.3</td>
<td><br /></td>
<td>No change: automatically loads git/2.37.3 via epcc/utils</td></tr>
<tr>
<td>
<p>gmp/6.2.0-intel&nbsp;</p>
<p>gmp/6.2.1-mpt</p>
<p>gmp/6.3.0-mpt</p></td>
<td>Please use gmp/6.3.0-gcc or gmp/6.3.0-intel&nbsp;</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">gnu-parallel/20200522-gcc6</span></p></td>
<td>Please use gnu-parallel/20240122-gcc10</td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">gromacs/2022.1<br /></span><span class="s1">gromacs/2022.1-gpu<br /></span><span class="s1">gromacs/2022.3-gpu</span></p></td>
<td>
<p>Please use one of:<br />gromacs/2023.4<br />gromacs/2023.4-gpu</p></td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">hdf5parallel/1.10.4-intel18-impi18</span></p></td>
<td>Please use hdf5parallel/1.14.3-intel20-impi20</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">hdf5parallel/1.10.6-gcc6-mpt225</span></p></td>
<td>Please use hdf5parallel/1.14.3-gcc10-mpt225</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">hdf5parallel/1.10.6-intel18-mpt225</span></p></td>
<td>Please use hdf5parallel/1.14.3-intel20-mpt225</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">hdf5parallel/1.10.6-intel19-mpt225</span></p></td>
<td>Please use hdf5parallel/1.14.3-intel20-mpt225</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">hdf5serial/1.10.6-intel18</span></p></td>
<td>Please use hdf5serial/1.14.3-intel20</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">horovod/0.25.0</span></p>
<p class="p1"><span class="s1">horovod/0.25.0-gpu</span></p>
<p class="p1"><span class="s1">horovod/0.26.1-gpu</span></p></td>
<td>Please use one of the pytorch or tensorflow modules</td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">htop/3.1.2&nbsp;</span></p></td>
<td>Please use htop/3.2.1&nbsp;</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>intel 18.0 compilers etc</p></td>
<td>Please use Intel 19.5 or later; or oneAPI</td>
<td>ADD ONEAPI information</td>
<td>Should be moving to oneAPI</td></tr>
<tr>
<td>
<p>intel 19.0 compilers etc</p></td>
<td>Please use Intel 19.5 or later</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>lammps/23Jun2022_intel19_mpt<br />lammps/8Feb2023-gcc8-impi<br />lammps/23Sep2023-gcc8-impi<br />lammps/8Feb2023-gcc8-impi-cuda118<br />lammps/23Sep2023-gcc8-impi-cuda118</p></td>
<td>
<p>Please use one of:</p>
<p>lammps/15Dec2023-gcc10.2-impi20.4<br />lammps-gpu/15Dec2023-gcc10.2-impi20.4-cuda11.8</p></td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>libxkbcommon/1.0.1</p></td>
<td>Please contact the service desk if you wish to use libxkbcommon.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">libnsl/1.3.0&nbsp;</span></p></td>
<td>Please contact the helpdesk if you wish to use libnsl.</td>
<td><br /></td>
<td>Dependancy for STARCCM+.</td></tr>
<tr>
<td>
<p><span>libpng/1.6.30</span></p></td>
<td>This is no longer supported as the central module.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">libtirpc/1.2.6</span></p></td>
<td>Please contact the helpdesk if you wish to use libtirpc.</td>
<td><br /></td>
<td>Dependancy for STARCCM+.</td></tr>
<tr>
<td>
<p class="p1"><span class="s1">libtool/2.4.6<br /></span></p></td>
<td>Please use libtool/2.4.7</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>nco/4.9.3</td>
<td>Please use nco/5.1.9</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>nco/4.9.7</td>
<td>Please use nco/5.1.9</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>ncview/2.1.7</td>
<td>Please use ncview/2.1.10</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">netcdf-parallel/4.6.2-intel18-impi18</span></p></td>
<td>Please use netcdf-parallel/4.9.2-intel20-impi20</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">netcdf-parallel/4.6.2-intel19-mpt225</span></p></td>
<td>Please use netcdf-parallel/4.9.2-intel20-mpt225</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">nvidia/cudnn/</span><span class="s1">8.2.1-cuda-11.6</span></p>
<p class="p1"><span class="s1">nvidia/cudnn/8.2.1-cuda-11.6</span></p>
<p class="p1"><span class="s1">nvidia/cudnn/8.9.4-cuda-11.6</span></p>
<p class="p1"><span class="s1">nvidia/cudnn/8.9.7-cuda-11.6</span></p></td>
<td>
<p>Please use one of the following</p>
<p><span class="s1">nvidia/cudnn/</span>8.6.0-cuda-11.6</p>
<p><span class="s1">nvidia/cudnn/</span>8.6.0-cuda-11.6</p></td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">nvidia/nvhpc/22.11-no-gcc</span></p></td>
<td>Use nvidia/nvhpc/22.11</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">nvidia/tensorrt/7.2.3.4</span></p></td>
<td>Please use <span class="s1">nvidia/tensorrt/</span>8.4.3.1-u2</td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">openfoam/v8.0</span></p></td>
<td>Please consider a later version, e.g., v10.0</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">openfoam/v9.0</span></p></td>
<td>Please consider a later version, e.g, v11.0</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">openfoam/v2006</span></p></td>
<td>Please consider a later version, e.g., v2306</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">openmpi/4.1.2-cuda-11.6</span></p>
<p class="p1"><span class="s1">openmpi/4.1.4</span></p>
<p class="p1"><span class="s1">openmpi/4.1.4-cuda-11.6</span></p>
<p class="p1"><span class="s1">openmpi/4.1.4-cuda-11.6-nvfortran</span></p>
<p class="p1"><span class="s1">openmpi/4.1.4-cuda-11.8</span></p>
<p class="p1"><span class="s1">openmpi/4.1.4-cuda-11.8-nvfortran</span></p>
<p class="p1"><span class="s1">openmpi/4.1.5</span></p>
<p class="p1"><span class="s1">openmpi/4.1.5-cuda-11.6</span></p>
<p class="p1"><br /></p></td>
<td>
<p>Please use one of the following</p>
<p>openmpi/4.1.6</p>
<p>openmpi/4.1.6-cuda-11.6</p>
<p>openmpi/4.1.6-cuda-11.6-nvfortran</p>
<p>openmpi/4.1.6-cuda-11.8</p>
<p>openmpi/4.1.6-cuda-11.8-nvfortran</p>
<p><br /></p></td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">petsc/3.13.2-intel-mpi-18</span></p>
<p class="p1"><span class="s1">petsc/3.13.2-mpt</span></p></td>
<td>Please contact the helpdesk if you require a more recent version of PETSc.</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">pyfr/1.14.0-gpu</span></p></td>
<td>Please use pyfr/1.15.0-gpu</td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">pytorch/1.12.1</span></p>
<p class="p1"><span class="s1">pytorch/1.12.1-gpu</span></p></td>
<td>
<p>Please use one of the following</p>
<p>pytorch/1.13.1</p>
<p>pytorch/1.13.1-gpu</p></td>
<td>TODO</td>
<td>
<p>The PyTorch Lightning packages have been removed from the environments provided by the pytorch 1.13.1 modules. This is too save space. If a user requires those packages they can build their own local environment based on the appropriate pytorch module as explained in the <a href="https://docs.cirrus.ac.uk/user-guide/python/#installing-your-own-python-packages-with-pip">user docs</a>.</p>
<p>For the same reasons, the fastai, pyspark, scikit and opencv-python packages have also been removed.</p></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">quantum-espresso/6.5-intel-19</span></p></td>
<td>Please use QE/6.5-intel-20.4</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p class="p1"><span class="s1">specfem3d</span></p></td>
<td>Please contact the helpdesk if you wish to use SPECFEM3D</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>starccm+/14.04.013-R8</p>
<p class="p1"><span class="s1">starccm+/14.06.013-R8 &rarr; 2019.3.1-R8</span></p>
<p class="p1"><span class="s1">starccm+/15.02.009-R8 &rarr; 2020.1.1-R8&nbsp;</span></p>
<p class="p1"><span class="s1">starccm+/15.04.010-R8 &rarr; 2020.2.1-R8&nbsp;</span></p>
<p class="p1"><span class="s1">starccm+/15.06.008-R8 &rarr; 2020.3.1-R8</span></p>
<p class="p1"><span class="s1">starccm+/16.02.009 &rarr; 2021.1.1</span></p></td>
<td>Please contact the helpdesk if you wish to use STAR-CCM+</td>
<td><br /></td>
<td><br /></td></tr>
<tr>
<td>
<p>tensorflow/2.9.1-gpu</p>
<p>tensorflow/2.10.0</p>
<p>tensorflow/2.11.0-gpu</p></td>
<td>
<p>Please use one of the following</p>
<p>tensorflow/2.15.0</p>
<p>tensorflow/2.15.0-gpu</p></td>
<td>TODO</td>
<td>
<p>The fastai, pyspark, scikit and opencv-python packages have been removed from the environments provided by the tensorflow 2.15.0 modules. This is too save space. If a user requires those packages they can build their own local environment based on the appropriate tensorflow module as explained in the <a href="https://docs.cirrus.ac.uk/user-guide/python/#installing-your-own-python-packages-with-pip">user docs</a>.</p></td></tr>
<tr>
<td>
<p>ucx/1.9.0</p>
<p>ucx/1.9.0-cuda-11.6</p>
<p>ucx/1.9.0-cuda-11.8</p></td>
<td>
<p>Please use one of the following</p>
<p>ucx/1.15.0</p>
<p>ucx/1.15.0-cuda-11.6</p>
<p>ucx/1.15.0-cuda-11.8</p></td>
<td>TODO</td>
<td><br /></td></tr>
<tr>
<td>
<p>vasp-5.4.4-intel19-mpt220</p></td>
<td><br /></td>
<td><br /></td>
<td>NO VASP5 at all?</td></tr>
<tr>
<td>
<p>zlib/1.2.11</p></td>
<td>Please use zlib/1.3.1</td>
<td><br /></td>
<td>nb. /usr/lib64 has 1.2.11</td></tr></tbody></table>

