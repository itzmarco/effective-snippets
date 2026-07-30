# vSphere IPAM Terraform

A practical Terraform/Terragrunt example for managing vSphere infrastructure in two related steps: IP allocation and VM provisioning. It can work as-is for small setups, but the main idea is to use it as a backbone for creating VMs for a Kubernetes cluster.

## Table of Contents

- [vSphere IPAM Terraform](#vsphere-ipam-terraform)
  - [Table of Contents](#table-of-contents)
  - [What this snippet is for](#what-this-snippet-is-for)
  - [Requirements](#requirements)
  - [Structure](#structure)
  - [How to use it](#how-to-use-it)
  - [Terragrunt workflow](#terragrunt-workflow)
  - [Assumptions](#assumptions)
  - [Notes on safety and reuse](#notes-on-safety-and-reuse)

## What this snippet is for

This folder is useful when you want a simple but structured way to:

- allocate IPs for infrastructure resources
- define VM resources for a cluster or environment
- keep shared values in one place and reuse them across modules
- generate metadata and cloud-init style configuration from templates

It is especially handy for labs, experiments, and small internal setups where you want a clear workflow without over-engineering the solution.

## Requirements

Before using this example, make sure you have:

- Terraform installed and available in your PATH
- Terragrunt installed if you want to use the provided Terragrunt entrypoints
- access to a vSphere environment and the necessary credentials
- a working network layout with the required IP ranges, VM templates, and datastore availability
- familiarity with Terraform variables, provider configuration, and Terragrunt conventions

## Structure

- [ips](ips): contains the IP allocation logic, provider configuration, variables, outputs, and the Terragrunt entrypoint
- [vms](vms): contains the VM definitions, including Kubernetes master/worker resources, tags, and templates; it also depends on the outputs from [ips](ips)
- [shared](shared): contains shared values such as [shared/variables.hcl](shared/variables.hcl) that can be reused across the stack

## How to use it

1. Review [ips](ips) to understand how address allocation is modeled.
2. Review [vms](vms) to see how those resources are used to build VM definitions.
3. Check [shared/variables.hcl](shared/variables.hcl) for values that affect both parts.
4. Replace the example values with your own environment-specific settings before applying anything.
5. Use the provided `secrets.example.tfvars` files as a template for your own local `secrets.tfvars` files, and keep the real values local and out of version control.

## Terragrunt workflow

A typical Terragrunt workflow for this layout is:

1. Define or adjust shared values in [shared/variables.hcl](shared/variables.hcl).
2. Create local `secrets.tfvars` files in [ips](ips) and [vms](vms) based on the provided `secrets.example.tfvars` examples.
3. Run the terragrunt workflow

   ```bash
    # from the parent directory, run the full dependency-aware workflow
    terragrunt run --all plan
    terragrunt run --all apply
    ```

    This will first retrieve and assign free IPs from the IPAM and then create the VMs with the correct IPs.
4. Review the generated templates and metadata before provisioning anything.

If you prefer to work more explicitly, this layout also supports reviewing the two layers separately, but the parent-directory Terragrunt flow is the simplest way to handle the dependency chain.

## Assumptions

This snippet assumes that:

- you already have a vSphere environment available
- you are comfortable working with Terraform and Terragrunt concepts
- the target environment already has the necessary networks and permissions
- you will supply your own values for credentials, hostnames, IP ranges, cluster-specific settings etc.

## Notes on safety and reuse

- This is an example workflow, so it may need adjustments for your environment
- Keep sensitive values out of version control
- Treat this as a reference point rather than a drop-in solution
