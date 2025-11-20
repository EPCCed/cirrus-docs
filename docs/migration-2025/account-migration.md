# Migrating your account to Cirrus EX4000

!!! important
    This information was last updated on 12 Nov 2025

This section covers the following questions:

  - When will I be able to access Cirrus EX4000?
  - Has my project has been migrated to Cirrus EX4000?
  - How much resource will my project have on Cirrus EX4000?
  - How do I set up an account on Cirrus EX4000?
  - How do I log into Cirrus EX4000 for the first time?

!!! tip
    If you need help or have questions on this migration process, 
    please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support-access/user-support/)

## When will I be able to access Cirrus EX4000?

We anticipate that users will have access in early December 2025 but this 
date is subject to change based on progress with setting up the new system. We will
update the date on these pages and in emails to all users.

## Has my project been migrated to Cirrus EX4000?

If you have an active Cirrus CPU allocation beyond 31 Dec 2025
then your project will very likely be migrated to Cirrus EX4000. If your project
is migrated to Cirrus EX4000 then it will have the same project code as it had
on old Cirrus.

If your project has been migrated to Cirrus EX4000 then you will
be able to see this on the Project page in SAFE. In particular, you
will have a button labelled "Manage Group Time Allocations for CirrusEX (Allocations on Cirrus (2025 refresh))"
in the "Time Budgets" section on the project page.

## How much resource will my project have on Cirrus EX4000?

As on the old Cirrus CPU partition, the unit of allocation on Cirrus EX4000
is core hours (coreh). Your initial allocations on Cirrus EX4000 will have the 
same number of coreh as old Cirrus allocations.

## How do I set up an Cirrus EX4000 account?

How you setup your account depends on whether you have an existing Cirrus account
in the project you are using for access or if you need a new account.

### Migrate an existing Cirrus account to Cirrus EX4000

1. Login to [EPCC SAFE](https://safe.epcc.ed.ac.uk)
2. Use the "Login accounts" menu to select your existing Cirrus account (this will be in the format `username@eidf`)
3. At the bottom of the account page, click the "Add Machine" button
4. Select "Cirrus: Cirrus 2025 refresh" from the dropdown list
5. Click "Join"

You should now be able to login to Cirrus EX4000 using the existing credentials 
associated with this account.

### Create a new account on Cirrus EX4000

Use the [standard account creation process in SAFE](https://epcced.github.io/safe-docs/safe-for-users/#how-to-request-a-machine-account) and select "Cirrus: Cirrus 2025 refresh"
for the machine to request an account on.

You will need to setup credentials (MFA/TOTP token and SSH key) in the usual way to
be able to login to Cirrus EX4000.

## How do I log into Cirrus EX4000 for the first time?

You will log into Cirrus EX4000 in the same way as you logged in to old Cirrus
using SSH to access `login.cirrus.ac.uk` using an SSH key pair and TOTP. Your SSH
key and TOTP will be the same as it was on old Cirrus. If you have issues, the Cirrus documentation
covers logging from a variety of operating systems along with troubleshooting tips:

   - [Logging in to Cirrus](https://docs.cirrus.ac.uk/user-guide/connecting/)

If you are still having issues after following the documentation and troubleshooting
tips, please [contact the Cirrus service desk](https://www.cirrus.ac.uk/support-access/user-support/) 
