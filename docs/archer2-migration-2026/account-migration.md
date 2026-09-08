# Migrating your account to Cirrus NCR

This section covers the following questions:

  - When will I be able to access Cirrus NCR?
  - Has my project has been assigned resources on Cirrus NCR?
  - How much resource will my project have on Cirrus NCR?
  - How do I set up an account on Cirrus NCR?
  - How do I log into Cirrus NCR for the first time?

!!! tip
    If you need help or have questions on this migration process, 
    please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support-access/user-support/)

## When will I be able to access Cirrus NCR?

This depends on your project but the migration process is starting from 16 Sep 2026
As soon as Cirrus resources have been assigned to the project, you will be able to
request an account and login to Cirrus.

## Has my project been assigned to Cirrus NCR?

UKRI are notifying project leads on which NCRs (if any) their ARCHER2 project is
migrating to. If your project is migrated to Cirrus NCR then it will have the same
project code in SAFE as it had on ARCHER2.

### Checking if your project has been assigned time on Cirrus NCR

A project PI/manager can see if their project has been assigned time on Cirrus NCR
in SAFE:

+ If you are a PI/manager: If your project has been migrated to Cirrus EX4000 then
  you will be able to see this on the Project page in SAFE. In particular, you
  will have a button labelled
  "Manage Group Time Allocations for CirrusEX (Allocations on Cirrus (2025 refresh))"
  in the "Time Budgets" section on the project page.

Users will be informed by their project PI/managers if they have been assigned resources
on Cirrus NCR.

## How much resource will my project have on Cirrus NCR?

UKRI are assigning resources on Cirrus NCR to projects migrating from ARCHER2 and
will set the amount of resource available. You can see the amount of resource 
your account has access to through SAFE as you can for ARCHER2 accounts. 

## How do I set up an Cirrus NCR account?

!!! important "Your Cirrus NCR username must match your ARCHER2 username"
    You must choose the same username on Cirrus NCR as you have in the project on
    ARCHER2. If you try to choose a different username from your ARCHER2 username
    then SAFE will give an error.

Use the [standard account creation process in SAFE](https://epcced.github.io/safe-docs/safe-for-users/#how-to-request-a-machine-account) and select "Cirrus"
for the machine to request an account on. You **must** use the same username you have in 
the project on ARCHER2 for your Cirrus NCR account. 

You will need to setup credentials (MFA/TOTP token and SSH key) in the same way
as you have done for your ARCHER2 account to be able to login to Cirrus NCR. See
[the Access Credentials section of the Cirrus Documentation](https://docs.cirrus.ac.uk/user-guide/connecting/#access-credentials-mfa) for more information on how to do this.

## How do I log into Cirrus NCR for the first time?

You will log into Cirrus  in the same way as you logged in to ARCHER2
using SSH to access `login.cirrus.ac.uk` using an SSH key pair and TOTP.
If you have issues, the Cirrus documentation covers logging from a variety
of operating systems along with troubleshooting tips:

   - [Logging in to Cirrus](https://docs.cirrus.ac.uk/user-guide/connecting/)

If you are still having issues after following the documentation and troubleshooting
tips, please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support-access/user-support/) 
