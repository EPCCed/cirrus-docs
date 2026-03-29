# Connecting to Cirrus

On the Cirrus system, interactive access can be achieved via SSH, either
directly from a command line terminal or using an SSH client. In
addition data can be transferred to and from the Cirrus system using
`scp` from the command line or by using a file transfer client.

Before following the process below, we assume you have set up an account
on Cirrus through the EPCC SAFE. Documentation on how to do this can be
found at:

[SAFE Guide for  Users](https://epcced.github.io/safe-docs/safe-for-users/)

This section covers the basic connection methods.

!!! tip
    The current login address for Cirrus is `login.cirrus.ac.uk`.

## Access credentials: MFA

To access Cirrus, you need to use two credentials (this is known as
*multi-factor authentication* or *MFA*): your SSH key pair, protected by a
passphrase, **and** a time-based one-time passcode (sometimes
known as a *TOTP code*). You can find more detailed instructions on
how to set up your credentials to access Cirrus from Windows, macOS and Linux
below.

### SSH Key Pairs

You will need to generate an SSH key pair protected by a passphrase to
access Cirrus.

#### Generate SSH key pair

Using a terminal (the command line), set up a key pair that contains
your e-mail address and enter a passphrase you will use to unlock the
key:

```bash
$ ssh-keygen -t rsa -C "your@email.com"
```

```output
Generating public/private rsa key pair.
Enter file in which to save the key (/Home/user/.ssh/id_rsa): [Enter]
Enter passphrase (empty for no passphrase): [Passphrase]
Enter same passphrase again: [Passphrase]
Your identification has been saved in /Home/user/.ssh/id_rsa.
Your public key has been saved in /Home/user/.ssh/id_rsa.pub.
The key fingerprint is:
03:d4:c4:6d:58:0a:e2:4a:f8:73:9a:e8:e3:07:16:c8 your@email.com
The key's randomart image is:
+--[ RSA 2048]----+
|    . ...+o++++. |
| . . . =o..      |
|+ . . .......o o |
|oE .   .         |
|o =     .   S    |
|.    +.+     .   |
|.  oo            |
|.  .             |
| ..              |
+-----------------+
```

(remember to replace "<your@email.com>" with your e-mail address).

#### Upload public part of key pair to SAFE

You should now upload the public part of your SSH key pair to the SAFE
by following the instructions at:

[Login to SAFE](https://safe.epcc.ed.ac.uk/). Then:

 1.  Go to the Menu *Login accounts* and select the Cirrus account you
     want to add the SSH key to
 2.  On the subsequent Login account details page click the *Add Credential*
     button
 3.  Select *SSH public key* as the Credential Type and click *Next*
 4.  Either copy and paste the public part of your SSH key into the
     *SSH Public key* box or use the button to select the public key file
     on your computer.
 5.  Click *Add* to associate the public SSH key part with your account

Once you have done this, your SSH key will be added to your Cirrus
account.

!!! Tip
    You can upload multiple public keys to SAFE to associate with your
    login account. This can be helpful if you want to log into Cirrus
    from multiple machines - you can have a different SSH key pair on
    each machine.

### Time-based one-time passcode (TOTP code)

Remember, you will need to use both an SSH key and time-based one-time
passcode (TOTP code) to log into Cirrus so you will
also need to [set up a method for generating a TOTP code](https://epcced.github.io/safe-docs/safe-for-users/#how-to-turn-on-mfa-on-your-machine-account)
before you can log into Cirrus. 

<!--

### First login: password required

!!! Important
    You will **not** use your password when logging on to Cirrus after the first login for a new account.

As an additional security measure, you will also need to use a password from SAFE for your first login to Cirrus
with a new account. When you log into Cirrus for the first time with a new account, you will be prompted to change
your initial password. This is a three step process:

1.  When promoted to enter your *ldap password*: Enter the password  which you [retrieve from SAFE](https://epcced.github.io/safe-docs/safe-for-users/#how-can-i-pick-up-my-password-for-the-service-machine)
2.  When prompted to enter your new password: type in a new password
3.  When prompted to re-enter the new password: re-enter the new password

Your password has now been changed. You will no longer need this password to log into Cirrus from this point
forwards, you will use your SSH key and TOTP code as described above.

-->

## SSH Clients

Interaction with Cirrus is done remotely, over an encrypted
communication channel, Secure Shell version 2 (SSH-2). This allows
command-line access to one of the login nodes of a Cirrus, from which
you can run commands or use a command-line text editor to edit files.

Linux distributions, MacOS and Windows each come installed with a terminal
application that can be use for SSH access to the login nodes.

*Linux users* will have different terminals depending on their distribution and
window manager (e.g. GNOME Terminal in GNOME, Konsole in KDE). Consult
your Linux distribution's documentation for details on how to load a
terminal.

*MacOS users* can use the Terminal application, located in the Utilities
folder within the Applications folder.

*Windows users* can use Powershell (which has an SSH client installed)
or a WSL2 terminal.

## Logging in

You can use the following command from the terminal window to login into
Cirrus:

```
ssh username@login.cirrus.ac.uk
```

You will first be prompted for the passphrase associated with your SSH
key pair. Once you have entered your passphrase successfully, you will
then be prompted for your MFA TOTP. You need to enter both correctly to
be able to access Cirrus.


!!! Note

    If your SSH key pair is not stored in the default location (usually
    `~/.ssh/id_rsa`) on your local system, you may need to specify the
    path to the private part of the key with the `-i` option to `ssh`.
    For example, if your key is in a file called `keys/id_rsa_cirrus`
    you would use the command `ssh -i keys/id_rsa_cirrus username@login.cirrus.ac.uk` to log in.

!!! Tip
    If you logged into Cirrus with your account before the change to Cirrus EX4000, you
    may see a warning such as:

    ```
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the ED25519 key sent by the remote host is
    SHA256:WX5NbmOOYZdcm0HN3KgSkkI67+cSudpll0E1R6n9nto.
    Please contact your system administrator.
    Add correct host key in /Users/auser/.ssh/known_hosts to get rid of this message.
    Offending ECDSA key in /Users/auser/.ssh/known_hosts:2
    Host key for login.cirrus.ac.uk has changed and you have requested strict checking.
    Host key verification failed.
    ```

    If you see this, you should delete the offending host key from your ~/.ssh/known_hosts file
    (in the example above the offending line is line #2)

<!-- X is unntested
To allow remote programs, especially graphical applications to control
your local display, such as being able to open up a new GUI window (such
as for a debugger), use:

```
ssh -X username@login.cirrus.ac.uk
```

Some sites recommend using the `-Y` flag. While this can fix some
compatibility issues, the `-X` flag is more secure.

Current MacOS systems do not have an X window system. Users should
install the XQuartz package to allow for SSH with X11 forwarding on
MacOS systems:

- [XQuartz website](http://www.xquartz.org/)

-->

## Host Keys

Adding the host keys to your SSH configuration file provides an extra
level of security for your connections to Cirrus. The host keys are
checked against the login nodes when you login to Cirrus and if the
remote server key does not match the one in the configuration file,
the connection will be refused. This provides protection against potential
malicious servers masquerading as the Cirrus login nodes.

### login.cirrus.ac.uk

```
login.cirrus.ac.uk ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFBvqlziPNvqf4DRbTMi5RsdJB6x7sw6zNZKxAE0klnchuWvX3feLslEteKazfQ6NmtJ/bOanbtxAOLXR/Fv9+E=

login.cirrus.ac.uk ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEtumDZQYQFczLoAUOQRCkt+93mFEyTGtJLtOh8DXunogsQsc1S98XlaJMwn6j5LpAvUBzpdnqyDCOX3ksS+B6VvFc5A73c9SNt8Xvl+V8cW7V57fu/tK7PCWliboIF3WmL+cWTh5QGfbjLiOY6MZSjEBvJOPOZ+jS0K9jyUIIFuHOGGDpjq16n8FQTLcU/NXr5H1AJN61WCFWTdg4P5mcjwpVrbEes9gC6e5ecFXX616aLwAiSf4wTepVPy0YGCm5/QKpsbyRcAG6QA30+3SllvvC2sdOK0jqUnAFhBbeWaqBk51CmERek1+mwxjU/w0zs7ezDumhdbI40r2zHcfheT65k5NFhJkLoV7JxHxW2zOZoEAxIvt8cNojeMmZcYiBow0KWzfOdT80uoQySXsC1VWke1Nyw1a3gmDJ8HS8zhLBo+J840JIFjdGDDXLlp5+3oZAbv6whLab6lXRC2CkEtWKbzJmo0PDPadqjVChg3+ApCOuEgEOYsGj/vbPBDk=

login.cirrus.ac.uk ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0Rb8J6LEilTRiglRytJRw3+Ak2t1JTFcMsF5NBucPe

```

Host key verification can fail if this key is out of date, a problem
which can be fixed by removing the offending entry in `~/.ssh/known_hosts`
and replacing it with the new key published here.  We recommend users
should check this page for any key updates and not just accept a new key
from the server without confirmation.

## Making access more convenient using the SSH configuration file

Typing in the full command to login or transfer data to Cirrus can
become tedious as it often has to be repeated many times. You can use
the SSH configuration file, usually located on your local machine at
`.ssh/config` to make things a bit more convenient.

Each remote site (or group of sites) can have an entry in this file
which may look something like:

```
Host cirrus
    HostName login.cirrus.ac.uk
    User username
```

(remember to replace `username` with your actual username!).

The `Host cirrus` line defines a short name for the entry. In this case,
instead of typing `ssh username@login.cirrus.ac.uk` to access the Cirrus
login nodes, you could use `ssh cirrus` instead. The remaining lines
define the options for the `cirrus` host.

- `Hostname login.cirrus.ac.uk` - defines the full address of the host
- `User username` - defines the username to use by default for this host
  (replace `username` with your own username on the remote host)

Now you can use SSH to access Cirrus without needing to enter your
username or the full hostname every time:

```bash
$ ssh cirrus
```

You can set up as many of these entries as you need in your local
configuration file. Other options are available. See the ssh_config man
page (or `man ssh_config` on any machine with SSH installed) for a
description of the SSH configuration file. You may find the
`IdentityFile` option useful if you have to manage multiple SSH key
pairs for different systems as this allows you to specify which SSH key
to use for each system.

!!! Note

    There is a known bug with Windows ssh-agent. If you get the error message:
    `Warning:  agent returned different signature type ssh-rsa (expected rsa-sha2-512)`,
    you will need to either specify the path to your ssh key in the command
    line (using the `-i` option as described above) or add the path to your
    SSH config file by using the `IdentityFile` option.

## Accessing Cirrus from more than 1 machine

It is common for users to want to access Cirrus from more than one local
machine (e.g. a desktop linux, and a laptop) - this can be achieved
by adding multiple public keys to your account through SAFE
as described above.

## SSH forwarding (to use Cirrus from a second remote machine)

If you want to access Cirrus from a machine you already access remotely
(e.g. to copy data from Cirrus onto a different cluster), you can
*forward* your local Cirrus SSH keys so that you don't need to create a
new key pair on the intermediate machine.

If your local machine is MacOS or Linus, add your Cirrus SSH key to the
SSH Agent:

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa

(If you created your key with a different name, replace `id_rsa` in the
command with the name of your private key file). You will be prompted
for your SSH key's passphrase.

You can then use the `-A` flag when connecting to your intermediate
cluster:

    ssh -A <user>@<host>

Once on the intermediate cluster, you should be able to SSH to Cirrus
directly:

    ssh <user>@login.cirrus.ac.uk

## SSH debugging tips

If you find you are unable to connect via SSH there are a number of ways
you can try and diagnose the issue. Some of these are collected below -
if you are having difficulties connecting we suggest trying these before
contacting the Cirrus service desk.

### Can you connect to the login node?

Try the command `ping -c 3 login.cirrus.ac.uk`. If you successfully
connect to the login node, the output should include:

    --- login.dyn.cirrus.ac.uk ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 38ms

(the ping time '38ms' is not important). If not all packets are received
there could be a problem with your internet connection, or the login
node could be unavailable.

### SSH key

If you get the error message `Permission denied (publickey)` this can
indicate a problem with your SSH key. Some things to check:

- Have you uploaded the key to SAFE? Please note that if the same key
   is reuploaded SAFE will not map the "new" key to cirrus. If for some
  reason this is required, please delete the key first, then reupload.

- Is ssh using the correct key? You can check which keys are being
  found and offered by ssh using `ssh -vvv`. If your private key has a
  non-default name you can use the `-i` flag to provide it to ssh,
   i.e. `ssh -i path/to/key username@login.cirrus.ac.uk`.

- Are you entering the passphrase correctly? You will be asked for
   your private key's passphrase first. If you enter it incorrectly you
   will usually be asked to enter it again, and usually up to three
   times in total, after which ssh will fail with
   `Permission denied (publickey)`. If you would like to confirm your
   passphrase without attempting to connect, you can use
   `ssh-keygen -y -f /path/to/private/key`. If successful, this command
  will print the corresponding public key. You can also use this to
   check it is the one uploaded to SAFE.

- Are permissions correct on the ssh key? One common issue is that the
   permissions are incorrect on the either the key file, or the
   directory it's contained in. On Linux/MacOS for example, if your
   private keys are held in `~/.ssh/` you can check this with
   `ls -al ~/.ssh`. This should give something similar to the following
   output:

```bash
    $ ls -al ~/.ssh/
    drwx------.  2 user group    48 Jul 15 20:24 .
    drwx------. 12 user group  4096 Oct 13 12:11 ..
    -rw-------.  1 user group   113 Jul 15 20:23 authorized_keys
    -rw-------.  1 user group 12686 Jul 15 20:23 id_rsa
    -rw-r--r--.  1 user group  2785 Jul 15 20:23 id_rsa.pub
    -rw-r--r--.  1 user group  1967 Oct 13 14:11 known_hosts
```

   The important section here is the string of letters and dashes at
   the start, for the lines ending in `.`, `id_rsa`, and `id_rsa.pub`,
   which indicate permissions on the containing directory, private key,
   and public key respectively. If your permissions are not correct,
   they can be set with `chmod`. Consult the table below for the
   relevant `chmod` command. On Windows, permissions are handled
   differently but can be set by right-clicking on the file and
   selecting Properties \> Security \> Advanced. The user, SYSTEM, and
   Administrators should have `Full control`, and no other permissions
   should exist for both public and private key files, and the
   containing folder.

| Target      |	Permissions |	chmod Code |
| ---         | ---        | ---          |
| Directory   |	drwx------ |	700    |
| Private Key |	-rw------- |	600    |
| Public Key  |	-rw-r--r-- |	644    |

`chmod` can be used to set permissions on the target in the following
way: `chmod <code> <target>`. So for example to set correct permissions
on the private key file `id_rsa_cirrus` one would use the command
`chmod 600 id_rsa_cirrus`.

!!! Note

    Unix file permissions can be understood in the following way.
    There are three groups that can have file permissions: (owning)
    *users*, (owning) *groups*, and *others*. The available
    permissions are *read*, *write*, and *execute*. 
    
    The first character indicates whether the target is a file `-`,
    or directory `d`. The next three characters indicate the owning
    user's permissions. The first character is `r` if they have read
    permission, `-` if they don't, the second character is `w` if
    they have write permission, `-` if they don't, the third character
    is `x` if they have execute permission, `-` if they don't. This
    pattern is then repeated for *group*, and *other* permissions. 
    
    For example the pattern `-rw-r--r--` indicates that the owning
    user can read and write the file, members of the owning group
    can read it, and anyone else can also read it. The `chmod` codes
    are constructed by treating the user, group, and owner permission
    strings as binary numbers, then converting them to decimal. For
    example the permission string `-rwx------` becomes `111 000 000` -\> `700`.


### MFA

If your TOTP passcode is being consistently rejected, you can
[remove MFA from your account](https://epcced.github.io/safe-docs/safe-for-users/#mfa_off)
and then [re-enable it](https://epcced.github.io/safe-docs/safe-for-users/#mfa).


### SSH verbose output

Verbose debugging output from `ssh` can be very useful for diagnosing
the issue. In particular, it can be used to distinguish between problems
with the SSH key and password - further details are given below. To
enable verbose output add the `-vvv` flag to your SSH command. For
example:

    ssh -vvv username@login.cirrus.ac.uk

The output is lengthy, but somewhere in there you should see lines
similar to the following:

    debug1: Next authentication method: publickey
    debug1: Offering public key: RSA SHA256:<key-hash> <path_to_private_key>
    debug3: send_pubkey_test
    debug3: send packet: type 50
    debug2: we sent a publickey packet, wait for reply
    debug3: receive packet: type 60
    debug1: Server accepts key: pkalg ssh-rsa vlen 2071
    debug2: input_userauth_pk_ok: fp SHA256:<key-hash>
    debug3: sign_and_send_pubkey: RSA SHA256:<key-hash>
    Enter passphrase for key '<path_to_private_key>':
    debug3: send packet: type 50
    debug3: receive packet: type 51
    Authenticated with partial success.

Most importantly, you can see which files ssh has checked for private
keys, and you can see if any key is accepted. The line
`Authenticated with partial success` indicates that the SSH key has been
accepted, and you will next be asked for your password. By default ssh
will go through a list of standard private key files, as well as any you
have specified with `-i` or a config file. This is fine, as long as one
of the files mentioned is the one that matches the public key uploaded
to SAFE.

If you do not see `Authenticated with partial success` anywhere in the
verbose output, consider the suggestions under *SSH key* above. If you
do, but are unable to connect, consider the suggestions under *Password*
above.

The equivalent information can be obtained in PuTTY or MobaXterm by
enabling all logging in settings.

## Default shell environment

Usually, when a new login shell is created, the commands on
`$HOME/.bashrc` are executed. This tipically includes setting
user-defined alias, changing environment variables, and, in the case of
an HPC system, loading modules.

Cirrus does not currently read the `$HOME/.bashrc` file, but it does
read the `$HOME/.bash_profile` file, so, if you wish to read a
`$HOME/.bashrc` file, you can add the following to your
`$HOME/.bash_profile` file (or create one, if it doesn't exist):

```bash
$ $HOME/.bash_profile
$ load $HOME/.bashrc, if it exists
if [ -f $HOME/.bashrc ]; then
        . $HOME/.bashrc
fi
```
