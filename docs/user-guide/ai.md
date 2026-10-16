# Use of generative AI with Cirrus

This section provides guidance and useful links for the use of generative AI with the Cirrus service. It covers how use of AI interacts with the Cirrus access and use policies, guidance on rules for AI use with Cirrus, links for AI skills for use with Cirrus.

## AI and access policies

It is your responsibility to ensure that any use of generative AI on Cirrus complies with the terms and conditions of access to Cirrus and all other policies that cover the use of Cirrus as listed at:

- [Cirrus Service Policies](https://www.cirrus.ac.uk/about/policies/)

Breaches of policies by generative AI using your Cirrus account are treated the same as breaches by you.

In particular:

- Cirrus access credentials should never be shared with AI (this includes passwords, SSH keys, MFA shared secrets - e.g passkey/QR code)
- Other people should not be given access to AI that is accessing your Cirrus account
- It is your responsibility to ensure any AI-generated code, scripts or commands running on Cirrus comply with access policies

If you have any concerns or questions about your use of generative AI with Cirrus, [contact the Cirrus Service Desk](https://www.cirrus.ac.uk/support-access/user-support/) to discuss them.

## Key guiding rules and checks for AI use with Cirrus

The guiding principles and key checks from the [top-level Cirrus NCR AI skill](https://skills.cirrus.ac.uk/site/plugins/cirrus/skills/general/SKILL.html) are included here. The easiest way to use these are to use the [Cirrus AI Skills](https://skills.cirrus.ac.uk) when using generative AI with Cirrus.

### Principals

AI should always follow these rules when generating or suggesting code for Cirrus system.

| Principle | Rule |
|---|---|
| **Shared resource respect** | Never generate code that runs heavy workloads directly on login nodes. Do not poll Slurm more frequently than once every minute. |
| **Accurate resource requests** | Always estimate realistic `--time`, `--nodes`, `--tasks-per-node`, `--cpus-per-task` in job scripts |
| **Storage awareness** | Use the correct storage area; never assume data persists after project end |
| **Policy compliance** | All generated code must be consistent with the EIDF Terms and Conditions of Access at: https://edinburgh-international-data-facility.ed.ac.uk/about/policies/terms-and-conditions |
| **Architecture awareness** | Cirrus is an RHEL **x86_64** HPE Cray EX4000 system. More details at: https://docs.cirrus.ac.uk/user-guide/hardware/  |
| **Verify before submit** | Always review AI-generated scripts before `sbatch` — especially resource flags |
| **Do not attempt to escalate privileges** | Never try to use sudo or exploits to gain administrator or root access on Cirrus |

### Responsible AI-generated code checklist

Before submitting any AI-generated code or job script to Cirrus:

- [ ] **Resource requests are realistic** — `--time`, `--nodes` match your actual workload
- [ ] **No heavy computation on the login node** — all intensive work is inside a job script
- [ ] **No intenstive polling of Slurm** — do not poll Slurm more frequently than once every minute
- [ ] **No attempts to escalate privileges** - code does not try to get administrator or root user access using sudo or any other method
- [ ] **Correct storage variable used** — inputs/outputs go to `/epccfs`, not `/home`
- [ ] **Architecture is correct** — code compiles/runs on x86_64
- [ ] **No persistent sessions** — `tmux`/`screen` used only within a job, not left on login nodes
- [ ] **Quota checked** — storage usage is within limits before staging large datasets
- [ ] **Data backed up** — important results are copied off-system; nothing is assumed to persist
- [ ] **Policy compliance** — usage is consistent with the EIDF Terms and Conditions of Access
- [ ] **Job output reviewed** — check `sacct` or output files after a job completes

## AI skill for use with Cirrus

We have produced and are continually updating a set of AI skills for use with Cirrus:

- [AI Skills for use with Cirrus NCR](https://skills.cirrus.ac.uk)

## Getting support

If you have any questions about the use of generative AI with Cirrus, please [contact the Cirrus Service Desk](https://www.cirrus.ac.uk/support-access/user-support/).