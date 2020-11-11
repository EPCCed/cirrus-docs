Using Python
============

Python on Cirrus is provided by the `Anaconda <https://www.continuum.io/>`__
distribution. Both Python 3 and Python 2 versions of the distributions are
available; we recommend using Python 3 as Python 2 will no longer be supported
in the future.

The central installation provides many of the most common packges used for
scientific computation and data analysis.

If the packages you require are not included in the central Anaconda Python
distribution, then the simplest way to make these available is often to install
your own version of `Miniconda <https://conda.io/miniconda.html>`__  and add the packages you need. We provide 
instructions on how to do this below.

An alternative way to provide your own
packages (and to make them available more generally to other people in your
project and beyond) would be to use a Singularity container, see the :doc:`singularity`
chapter of this User Guide for more information on this topic.

Accessing central Anaconda Python
---------------------------------

Users have the standard system Python available by default. To setup your environment
to use the Anaconda distributions you should use:

::

    module load anaconda/python3

for Python 3, or:

::

    module load anaconda/python2

for Python 2.

You can verify the current version of Python with:

::

   [user@cirrus-login0 ~]$ module load anaconda/python3
   [user@cirrus-login0 ~]$ python3 --version
   Python 3.6.4 :: Anaconda, Inc.

Full details on the Anaconda distributions can be found on the Continuum website at:

* http://docs.continuum.io/anaconda/index.html

Packages included in Anaconda distributions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can list the packages currently available in the distribution you have loaded with the command conda list:

::

   [user@cirrus-login0 ~]$ module load anaconda
   [user@cirrus-login0 ~]$ conda list
   # packages in environment at /lustre/sw/anaconda/anaconda3-5.1.0:
   #
   # Name                    Version                   Build  Channel
   _ipyw_jlab_nb_ext_conf    0.1.0            py36he11e457_0  
   alabaster                 0.7.10           py36h306e16b_0  
   anaconda                  5.1.0                    py36_2  
   anaconda-client           1.6.9                    py36_0  
   anaconda-navigator        1.7.0                    py36_0  
   anaconda-project          0.8.2            py36h44fb852_0  
   asn1crypto                0.24.0                   py36_0  
   astroid                   1.6.1                    py36_0  
   astropy                   2.0.3            py36h14c3975_0  
   ...


Adding packages to the Anaconda distribution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Packages cannot be added to the central Anaconda distribution by users.
If you wish to have additional packages, we recommend installing your
own local version of Miniconda and adding the packages you need. This
approach is described in Custom Environment below.

Custom Environments
-------------------

To setup a custom Python environment including packages that are not in the
central installation, the simplest
approach is the install Miniconda locally in your own directories.

Installing Miniconda
~~~~~~~~~~~~~~~~~~~~

First, you should download Miniconda. You can use ``wget`` to do this, for example:

::

   $ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

You can find links to the various miniconda versions on the Miniconda website:

* https://conda.io/miniconda.html

For Cirrus, you should use the Linux 64-bit (bash installer).

Once you have downloaded the installer, you can run it via ``bash``, e.g.:

::

   [user@cirrus-login0 ~]$ bash Miniconda3-latest-Linux-x86_64.sh 


Note that the installer will prompt you for a number of choices which
include the license agreement, to which you must answer

::

  Do you accept the license terms? [yes|no]
  [no] >>> yes

The installer will prompt for the install location, the default
being you home directory (you can just hit return to accept the default):

::

  Miniconda3 will now be installed into this location:
  /lustre/home/t01/user/miniconda3
  
    - Press ENTER to confirm the location
    - Press CTRL-C to abort the installation
    - Or specify a different location below
  
    [/lustre/home/t01/user/miniconda3] >>> 

The final question will be about initialisation. If you wish to use only
Miniconda, and no other python environments (such as the central Anaconda
modules), you may want to answer `yes` at this point, otherwise we would
suggest answering `no`.

::

  Do you wish the installer to initialize Miniconda3
  by running conda init? [yes|no]
  [no] >>> no
  
  You have chosen to not have conda modify your shell scripts at all.
  To activate conda's base environment in your current shell session:
  
  eval "$(/lustre/home/z04/kevin/miniconda3/bin/conda shell.YOUR_SHELL_NAME hook)" 
  
  To install conda's shell functions for easier access, first activate, then:
  
  conda init
  
  If you'd prefer that conda's base environment not be activated on startup, 
     set the auto_activate_base parameter to false: 
  
  conda config --set auto_activate_base false
  
  Thank you for installing Miniconda3!


If you have answered "no", then the instructions above should be followed
to activate the base conda environment. This can be done in a number of
ways:


* Perform the shell ``eval`` command manually as required (which can become
  tedious if used a lot)

::

  $ eval "$(/lustre/home/t01/user/miniconda3/bin/conda shell.bash hook)

* Add the shell ``eval`` command to a script, which can then be invoked
  when required, e.g., in a script ``miniconda-init.sh`` in your home
  directory and then

::

  $ source ~/miniconda-init.sh

If you have answered "yes" at the installation question, the shell command is
effectively injected into you ``.bashrc`` file, and will be executed at
login. In this case, you may still wish to issue the command

::

  $ conda config --set auto_activate_base false

to prevent the conda base environment being activated automatically
at the point of login.


If not activated automatically at login, the conda base environment is
activated in the usual way:

::

  [user@cirrus]$ conda activate
  (base) [user@cirrus]$ conda list
  # packages in environment at /lustre/home/t01/user/miniconda3:
  #
  # Name                    Version                   Build  Channel
  _libgcc_mutex             0.1                        main  
  ca-certificates           2020.1.1                      0  
  certifi                   2020.4.5.1               py37_0  
  cffi                      1.14.0           py37he30daa8_1  
  chardet                   3.0.4                 py37_1003  
  conda                     4.8.3                    py37_0  
  ...

Installing packages into Miniconda
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once you have installed Miniconda and setup your environment to access it,
you can then add whatever packages you wish to the installation using the
``conda install ...`` command. For example:

::

   [user@cirrus-login0 ~]$ conda install numpy
   Collecting package metadata (current_repodata.json): done
   Solving environment: done
   
   ... package details omitted ...
   
   Proceed ([y]/n)? y
   ...
   
   [user@cirrus-login0 ~]$ conda list
   # packages in environment at /lustre/home/z04/kevin/miniconda3:
   #
   # Name                    Version                   Build  Channel
   _libgcc_mutex             0.1                        main  
   blas                      1.0                         mkl  
   ca-certificates           2020.1.1                      0  
   certifi                   2020.6.20                py37_0  
   cffi                      1.14.0           py37he30daa8_1  
   chardet                   3.0.4                 py37_1003  
   conda                     4.8.3                    py37_0  
   conda-package-handling    1.6.1            py37h7b6447c_0  
   cryptography              2.9.2            py37h1ba5d50_0  
   idna                      2.9                        py_1  
   intel-openmp              2020.1                      217  
   ld_impl_linux-64          2.33.1               h53a641e_7  
   libedit                   3.1.20181209         hc058e9b_0  
   libffi                    3.3                  he6710b0_1  
   libgcc-ng                 9.1.0                hdf63c60_0  
   libgfortran-ng            7.3.0                hdf63c60_0  
   libstdcxx-ng              9.1.0                hdf63c60_0  
   mkl                       2020.1                      217  
   mkl-service               2.3.0            py37he904b0f_0  
   mkl_fft                   1.1.0            py37h23d657b_0  
   mkl_random                1.1.1            py37h0573a6f_0  
   ncurses                   6.2                  he6710b0_1  
   numpy                     1.18.5           py37ha1c710e_0  
   numpy-base                1.18.5           py37hde5b4d6_0  
   ...


For some package installations it may also be necessary to specify a channel
such as conda-forge.
For example, the following command installs the pygobject module.

::

   [user@cirrus-login0 ~]$ conda install -c conda-forge pygobject 


Note on Default Python
----------------------

System versions of python occur in the default PATH if no action
has been taken:

::

  [user@cirrus-login0]$ which python2
  /usr/bin/python2
  [user@cirrus-login0]$ which python3
  /usr/bin/python3

These should not be used. Use either an Anaconda or a Miniconda version.

Using Jupyter Notebooks on Cirrus
---------------------------------

It is possible to view and run Jupyter notebooks that are on both login nodes and computer nodes of Cirrus (note: you can test these on the login nodes, but please don’t attempt to run any computationally intensive jobs on them. Jobs get killed once they hit a CPU limit on login nodes).
 
1. As described above, load the ``anaconda`` module on Cirrus (modules aren't automatically available): ``module load anaconda\python3``
    - If you want to run your Jupyter Notebook on a compute node, you will need to enter an `interactive session <batch.html#interactive-jobs>`_
2. We can now start Jupyter using ``jupyter notebook --ip=0.0.0.0`` - once it’s started, you will see a URL printed in the terminal window of the form ``http://0.0.0.0:8888?token=<string>`` - we'll need this URL in step 4
3. Open a new terminal window, and run the following command: ``ssh <username>@login.cirrus.ac.uk -L8888:<node_id>:8888`` where <username> is your username, and <node_id> is the node id we’re currently on (on a login node, this will be ``cirrus-login0``, or similar; on a compute node, it will be a mix of numbers and letters)
4. Now, if you open a browser window locally, you should now be able to navigate to the URL from step 2, and this should display the Jupyter Notebook server
    - if you haven't selected the correct node id, you will get a connection error



If you are on a compute node, the Notebook will be available for the length of the interactive session you have requested.
