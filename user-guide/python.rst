Using Python
============

Python on Cirrus is provided by the `Anaconda <https://www.continuum.io/>`__
distribution. The Python 3 version of the distribution is
available.

The central installation provides many of the most common packges used for
scientific computation and data analysis.

If the packages you require are not included in the central Anaconda Python
distribution, then the simplest way to make these available is often to install
your own version of `Miniconda <https://conda.io/miniconda.html>`__  and add the
packages you need. We provide  instructions on how to do this below.

An alternative way to provide your own packages (and to make them available more
generally to other people in your project and beyond) would be to use a Singularity
container, see the :doc:`singularity` chapter of this User Guide for more information
on this topic.

Accessing the Cirrus Anaconda Modules
-------------------------------------

Users have the standard system Python available by default. To setup your environment
to use the Anaconda distributions you should use:

::

    module load anaconda/python3

for Python 3 (v3.9.7).

You can verify the current version of Python with:

::

   [user@cirrus-login1 ~]$ module load anaconda/python3
   [user@cirrus-login1 ~]$ python3 --version
   Python 3.9.7 :: Anaconda, Inc.

Full details on the Anaconda distributions can be found on the Continuum website at:

* http://docs.continuum.io/anaconda/index.html

Packages included in Anaconda distributions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can list the packages currently available in the distribution you have loaded with the command conda list:

::

   [user@cirrus-login1 ~]$ module load anaconda
   [user@cirrus-login1 ~]$ conda list
   # packages in environment at /scratch/sw/anaconda/anaconda3-2021.11:
   #
   # Name                    Version                   Build  Channel
   _ipyw_jlab_nb_ext_conf    0.1.0            py39h06a4308_0  
   _libgcc_mutex             0.1                        main  
   _openmp_mutex             4.5                       1_gnu  
   alabaster                 0.7.12             pyhd3eb1b0_0  
   anaconda                  2021.11                  py39_0  
   anaconda-client           1.9.0            py39h06a4308_0  
   anaconda-navigator        2.1.1                    py39_0  
   anaconda-project          0.10.1             pyhd3eb1b0_0  
   anyio                     2.2.0            py39h06a4308_1  
   appdirs                   1.4.4              pyhd3eb1b0_0  
   argh                      0.26.2           py39h06a4308_0  
   argon2-cffi               20.1.0           py39h27cfd23_1  
   ...


Adding packages to the Anaconda distribution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Packages cannot be added to the central Anaconda distribution by users.
If you wish to have additional packages, we recommend installing your
own local version of Miniconda and adding the packages you need. This
approach is described in the next section.

Custom Environments
-------------------

To setup a custom Python environment including packages that are not in the
central installation, the simplest method is to install Miniconda locally within
your home directory.

Installing Miniconda
~~~~~~~~~~~~~~~~~~~~

First, you should download Miniconda. You can use ``wget`` to do this.

::

   [user@cirrus-login1 ~]$ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

You can find links to the various miniconda versions on the Miniconda website.

* https://conda.io/miniconda.html

For Cirrus, you should use the Linux 64-bit installer.

Once you have downloaded the installer, you can run it via ``bash``.

::

   [user@cirrus-login1 ~]$ bash Miniconda3-latest-Linux-x86_64.sh 


Note that the installer will prompt you for a number of choices which
include the license agreement to which you must answer `yes`.

::

  Do you accept the license terms? [yes|no]
  [no] >>> yes

The installer will prompt for the install location, the default
being your home directory, to install in /scratch or /work please
change the install location here.

::

  Miniconda3 will now be installed into this location:
  /home/t01/t01/user/miniconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

  [/home/t01/t01/user/miniconda3] >>> /work/t01/t01/user/miniconda3

The final question will be about initialization. If you wish to use only
Miniconda and no other python environments (such as the central Anaconda
modules), you may want to answer `yes` at this point, otherwise we would
suggest answering `no`.

::

  Do you wish the installer to initialize Miniconda3
  by running conda init? [yes|no]
  [no] >>> no
  
  You have chosen to not have conda modify your shell scripts at all.
  To activate conda's base environment in your current shell session:
  
  eval "$(/work/t01/t01/user/miniconda3/bin/conda shell.YOUR_SHELL_NAME hook)" 
  
  To install conda's shell functions for easier access, first activate, then:
  
  conda init
  
  If you'd prefer that conda's base environment not be activated on startup, 
     set the auto_activate_base parameter to false: 
  
  conda config --set auto_activate_base false
  
  Thank you for installing Miniconda3!


If you have answered `no`, the instructions above should be followed
to activate the base conda environment. This can be done in a number of
ways.

* Perform the shell ``eval`` command manually as required.

::

  $ eval "$(/work/t01/t01/user/miniconda3/bin/conda shell.bash hook)"

* Add the shell ``eval`` command to a script, which can then be invoked
  when required, e.g., ``source ~/miniconda-init.sh``.

Answering `yes` to the initialization question will mean that the shell
command is effectively injected into your ``.bashrc`` file, and will be
executed whenever you login to your Cirrus account. In this case, you may
at a later date wish to issue a command that prevents the conda base
environment from being activated at login.

::

  $ conda config --set auto_activate_base false

If not activated automatically at login, the conda base environment can
instead be activated in the usual way.

::

  [user@cirrus-login1 ~]$ conda activate
  (base) [user@cirrus-login1 ~]$ conda list
  # packages in environment at /work/t01/t01/user/miniconda3:
  #
  # Name                    Version                   Build  Channel
  _libgcc_mutex             0.1                        main  
  _openmp_mutex             4.5                       1_gnu  
  brotlipy                  0.7.0         py39h27cfd23_1003  
  ca-certificates           2021.7.5             h06a4308_1  
  certifi                   2021.5.30        py39h06a4308_0  
  cffi                      1.14.6           py39h400218f_0  
  chardet                   4.0.0         py39h06a4308_1003  
  conda                     4.10.3           py39h06a4308_0
  ...
  (base) [user@cirrus-login1 ~]$  conda deactivate
  [user@cirrus-login1 ~]$ 

Installing packages into Miniconda
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once you have installed Miniconda and setup your environment to access it,
you can then add whatever packages you wish to the installation using the
``conda install ...`` command, see below for two examples.

::

   [user@cirrus-login1 ~]$ conda install numpy
   Collecting package metadata (current_repodata.json): done
   Solving environment: done
   
   ... package details omitted ...
   
   Proceed ([y]/n)? y

   ...
   
   [user@cirrus-login0 ~]$ conda list
   # packages in environment at /work/t01/t01/user/miniconda3:
   #
   # Name                    Version                   Build  Channel
   _libgcc_mutex             0.1                 conda_forge    conda-forge
   _openmp_mutex             4.5                      1_llvm    conda-forge
   blas                      1.0                         mkl  
   brotlipy                  0.7.0         py39h27cfd23_1003  
   ca-certificates           2021.10.8            ha878542_0    conda-forge
   cairo                     1.16.0            ha00ac49_1009    conda-forge
   certifi                   2021.10.8        py39hf3d152e_1    conda-forge
   cffi                      1.15.0           py39h4bc2ebd_0    conda-forge
   chardet                   4.0.0         py39h06a4308_1003  
   conda                     4.10.3           py39hf3d152e_3    conda-forge
   conda-package-handling    1.7.3            py39h27cfd23_1  
   cryptography              3.4.7            py39hd23ed53_0  
   font-ttf-dejavu-sans-mono 2.37                 hab24e00_0    conda-forge
   font-ttf-inconsolata      3.000                h77eed37_0    conda-forge
   font-ttf-source-code-pro  2.038                h77eed37_0    conda-forge
   font-ttf-ubuntu           0.83                 hab24e00_0    conda-forge
   fontconfig                2.13.1            hba837de_1005    conda-forge
   fonts-conda-ecosystem     1                             0    conda-forge
   fonts-conda-forge         1                             0    conda-forge
   freetype                  2.10.4               h0708190_1    conda-forge
   gettext                   0.19.8.1          h73d1719_1008    conda-forge
   icu                       69.1                 h9c3ff4c_0    conda-forge
   idna                      2.10               pyhd3eb1b0_0  
   intel-openmp              2021.4.0          h06a4308_3561  
   ld_impl_linux-64          2.36.1               hea4e1c9_2    conda-forge
   libffi                    3.4.2                h9c3ff4c_4    conda-forge
   libgcc-ng                 11.2.0              h1d223b6_11    conda-forge
   libgirepository           1.70.0               hb520f89_1    conda-forge
   libglib                   2.70.0               h174f98d_1    conda-forge
   libiconv                  1.16                 h516909a_0    conda-forge
   libpng                    1.6.37               h21135ba_2    conda-forge
   libstdcxx-ng              11.2.0              he4da1e4_11    conda-forge
   libuuid                   2.32.1            h7f98852_1000    conda-forge
   libxcb                    1.13              h7f98852_1003    conda-forge
   libxml2                   2.9.12               h885dcf4_1    conda-forge
   libzlib                   1.2.11            h36c2ea0_1013    conda-forge
   llvm-openmp               12.0.1               h4bd325d_1    conda-forge
   mkl                       2021.4.0           h06a4308_640  
   mkl-service               2.4.0            py39h7f8727e_0  
   mkl_fft                   1.3.1            py39hd3c417c_0  
   mkl_random                1.2.2            py39h51133e4_0  
   ncurses                   6.2                  he6710b0_1  
   numpy                     1.21.2           py39h20f2e39_0  
   numpy-base                1.21.2           py39h79a1101_0
   ...


For some package installations it may also be necessary to specify a channel
such as conda-forge. For example, the following command installs the pygobject
module.

::

   [user@cirrus-login1 ~]$ conda install -c conda-forge pygobject 


Note on Default Python
----------------------

System versions of python occur in the default PATH if no action
has been taken.

::

  [user@cirrus-login1]$ which python2

  [user@cirrus-login1]$ which python3
  /usr/bin/python3

These should not be used. Use either an Anaconda or a Miniconda version.

Using JupyterLab on Cirrus
--------------------------

It is possible to view and run JupyterLab on both the login and compute
nodes of Cirrus. Please note, you can test notebooks on the login nodes, but
please don’t attempt to run any computationally intensive work (such jobs will
be killed should they reach the login node CPU limit).

If you want to run your JupyterLab on a compute node, you will need to
enter an `interactive session <batch.html#interactive-jobs>`_; otherwise
you can start from a login node prompt.
 
1. As described above, load the Anaconda module on Cirrus using
   ``module load anaconda/python3``.

2. Run ``export JUPYTER_RUNTIME_DIR=$(pwd)``.

3. Start the JupyterLab server by running ``jupyter lab --ip=0.0.0.0 --no-browser``
   - once it’s started, you will see some lines resembling the following ouput.

  ::

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0.0.0.0:8888/?token=<string>

  You will need the URL shown above for step 6.

4. Please skip this step if you are connecting from Windows. If you are
   connecting from Linux or macOS, open a new terminal window, and run the
   following command.

   ::
     
     ssh <username>@login.cirrus.ac.uk -L<port_number>:<node_id>:<port_number>

   where <username> is your username, <port_number> is as shown in the URL from
   the Jupyter output and <node_id> is the name of the node we’re currently on.
   On a login node, this will be ``cirrus-login1``, or similar; on a compute node,
   it will be a mix of numbers and letters such as ``r2i5n5``.

   .. note::
     If, when you connect in the new terminal, you see a message of the
     form `channel_setup_fwd_listener_tcpip: cannot listen to port: 8888`,
     it means port 8888 is already in use.
     You need to go back to step 3 (kill the existing jupyter lab) and retry
     with a new explicit port number by adding the ``--port=N`` option.
     The port number ``N`` can be in the range 5000-65535. You should
     then use the same port number in place of 8888.

5. Please skip this step if you are connecting from Linux or macOS. If you are
   connecting from Windows, you should use MobaXterm to configure an SSH tunnel
   as follows.

   i. Click on the ``Tunnelling`` button above the MobaXterm terminal. Create a
      new tunnel by clicking on ``New SSH tunnel`` in the window that opens.

   ii. In the new window that opens, make sure the ``Local port forwarding`` radio
       button is selected.

   iii. In the ``forwarded port`` text box on the left under ``My computer with
        MobaXterm``, enter the port number indicated in the Jupyter server output.

   iv. In the three text boxes on the bottom right under ``SSH server`` enter
       ``login.cirrus.ac.uk``, your Cirrus username, and then ``22``.

   v. At the top right, under ``Remote server``, enter the name of the Cirrus
      login or compute node that you noted earlier followed by the port number (e.g. `8888`).

   vi. Click on the ``Save`` button.

   vii. In the tunnelling window, you will now see a new row for the settings you
        just entered. If you like, you can give a name to the tunnel in the
        leftmost column to identify it. Click on the small key icon close to the
        right for the new connection to tell MobaXterm which SSH private key to
        use when connecting to Cirrus. You should tell it to use the same
        ``.ppk`` private key that you normally use.

   viii. The tunnel should now be configured. Click on the small start button
         (like a play ``>`` icon) for the new tunnel to open it. You'll be asked
         to enter your Cirrus password -- please do so.

6. Now, if you open a browser window on your local machine, you should be able to
   navigate to the URL from step 3, and this should display the JupyterLab server.

   - Please note, you will get a connection error if you haven't used the
     correct node name in step 4 or 5.

If you are on a compute node, the JupyterLab server will be available for the length of
the interactive session you have requested.
