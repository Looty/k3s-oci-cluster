[![Wordpress CI](https://github.com/Looty/k3s-oci-cluster/actions/workflows/ci.yml/badge.svg)](https://github.com/Looty/k3s-oci-cluster/actions/workflows/ci.yml)
[![GitHub issues](https://img.shields.io/github/issues/Looty/k3s-oci-cluster)](https://github.com/Looty/k3s-oci-cluster/issues)
![GitHub](https://img.shields.io/github/license/Looty/k3s-oci-cluster)
[![GitHub forks](https://img.shields.io/github/forks/Looty/k3s-oci-cluster)](https://github.com/Looty/k3s-oci-cluster/network)
[![GitHub stars](https://img.shields.io/github/stars/Looty/k3s-oci-cluster)](https://github.com/Looty/k3s-oci-cluster/stargazers)

<p align="center">
  <img src="https://garutilorenzo.github.io/images/k3s-logo-large.png?" alt="k3s Logo"/>
</p>

# OCI K3s cluster

Deploy a Kubernetes cluster for free, using K3s and Oracle [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) resources.

# Table of Contents

- [OCI K3s cluster](#oci-k3s-cluster)
- [Table of Contents](#table-of-contents)
  - [Important notes](#important-notes)
  - [Requirements](#requirements)
  - [Supported OS](#supported-os)
  - [Terraform OCI user creation (Optional)](#terraform-oci-user-creation-optional)
    - [Example RSA key generation](#example-rsa-key-generation)
  - [Project setup](#project-setup)
  - [Oracle provider setup](#oracle-provider-setup)
  - [Pre flight checklist](#pre-flight-checklist)
    - [How to find the availability domain name](#how-to-find-the-availability-domain-name)
    - [How to list all the OS images](#how-to-list-all-the-os-images)
  - [Notes about OCI always free resources](#notes-about-oci-always-free-resources)
  - [Notes about K3s](#notes-about-k3s)
  - [Infrastructure overview](#infrastructure-overview)
  - [Cluster resource deployed](#cluster-resource-deployed)
    - [Nginx ingress controller](#nginx-ingress-controller)
    - [Cert-manager](#cert-manager)
  - [Deploy](#deploy)
    - [Public LB check](#public-lb-check)
    - [Longhorn check](#longhorn-check)
    - [Argocd check](#argocd-check)
  - [Deploy a sample stack](#deploy-a-sample-stack)
  - [Clean up](#clean-up)
  - [Known Bugs](#known-bugs)
    - [409-Conflict](#409-conflict)
    - [kubectl exec failure](#kubectl-exec-failure)

**Note** choose a region with enough ARM capacity

### Important notes

- This is repo shows only how to use terraform with the Oracle Cloud infrastructure and use only the **always free** resources. This examples are **not** for a production environment.
- At the end of your trial period (30 days). All the paid resources deployed will be stopped/terminated
- At the end of your trial period (30 days), if you have a running compute instance it will be stopped/hibernated

### Requirements

To use this repo you will need:

- an Oracle Cloud account. You can register [here](https://cloud.oracle.com)

Once you get the account, follow the _Before you begin_ and _1. Prepare_ step in [this](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm) document.

### Supported OS

This module was tested with:

- Ubuntu 20.04, 22.04 (ubuntu remote user)
- Ubuntu 20.04, 22.04 Minimal (ubuntu remote user)
- Oracle Linux 8, 9 (opc remote user)

### Terraform OCI user creation (Optional)

Is always recommended to create a separate user and group in your preferred [domain](https://cloud.oracle.com/identity/domains) to use with Terraform.
This user must have less privileges possible (Zero trust policy). Below is an example policy that you can [create](https://cloud.oracle.com/identity/policies) allow `terraform-group` to manage all the resources needed by this module:

```markdown
Allow group terraform-group to manage virtual-network-family  in compartment id <compartment_ocid>
Allow group terraform-group to manage instance-family  in compartment id <compartment_ocid>
Allow group terraform-group to manage compute-management-family  in compartment id <compartment_ocid>
Allow group terraform-group to manage volume-family  in compartment id <compartment_ocid>
Allow group terraform-group to manage load-balancers  in compartment id <compartment_ocid>
Allow group terraform-group to manage network-load-balancers  in compartment id <compartment_ocid>
Allow group terraform-group to manage dynamic-groups in compartment id <compartment_ocid>
Allow group terraform-group to manage policies in compartment id <compartment_ocid>
Allow group terraform-group to read network-load-balancers  in compartment id <compartment_ocid>
Allow group terraform-group to manage dynamic-groups in tenancy
```

See [how](#oracle-provider-setup) to find the compartment ocid. The user and the group have to be manually created before using this module.
To create the user go to **Identity & Security -> Users**, then create the group in **Identity & Security -> Groups** and associate the newly created user to the group. The last step is to create the policy in **Identity & Security -> Policies**.

#### Example RSA key generation

To use terraform with the Oracle Cloud infrastructure you need to generate an RSA key. Generate the rsa key with:

```markdown
openssl genrsa -out ~/.oci/<your_name>-oracle-cloud.pem 4096
chmod 600 ~/.oci/<your_name>-oracle-cloud.pem
openssl rsa -pubout -in ~/.oci/<your_name>-oracle-cloud.pem -out ~/.oci/<your_name>-oracle-cloud_public.pem
```

replace `<your_name>` with your name or a string you prefer.

**NOTE**: `~/.oci/<your_name>-oracle-cloud_public.pem` will be used in `terraform.tfvars` by the Oracle provider plugin, so please take note of this string.

### Project setup

Clone this repo and go in the `example/` directory:

```markdown
git clone https://github.com/garutilorenzo/k3s-oci-cluster.git
cd k3s-oci-cluster/example/
```

Now you have to edit the `main.tf` file and you have to create the `terraform.tfvars` file. For more detail see [Oracle provider setup](#oracle-provider-setup) and [Pre flight checklist](#pre-flight-checklist).

Or if you prefer you can create an new empty directory in your workspace and create this three files:

- `terraform.tfvars` - More details in [Oracle provider setup](#oracle-provider-setup)
- `main.tf`
- `provider.tf`

The `terragrunt.hcl` file will look like:
```markdown
terraform {
    source = "./modules//k3s-cluster"
}

// Error : 409 - Conflict fix
retry_max_attempts       = 2
retry_sleep_interval_sec = 10
retryable_errors = [
  "(?m).*409-Conflict*",
]

// Indicate the input values to use for the variables of the module.
inputs = {
    # Addons
    install_certmanager          = false
    install_longhorn             = false
    install_argocd_image_updater = false
    install_argocd               = true
    install_kubevela             = true
    install_crossplane           = true
  
    # Options
    expose_kubeapi          = true // expose only for my_public_ip
    expose_argocd_nodeport  = true
    load_cluster_kubeconfig = true
    k3s_extra_worker_node   = true // creates the 3rd worker node
    unique_tag_value        = basename(get_terragrunt_dir())

    # Set the values below - by editing or setting env vars..
    tenancy_ocid        = get_env("OCI_TENANCY_OCID")
    compartment_ocid    = get_env("OCI_COMPARTMENT_OCID")
    region              = get_env("OCI_REGION")
    os_image_id         = get_env("OCI_OS_IMAGE_ID")
    availability_domain = get_env("OCI_AVAILABILITY_DOMAIN")
    user_ocid           = get_env("OCI_USER_OCID")
    private_key_path    = get_env("OCI_PRIVATE_KEY_PATH")
    public_key_path     = get_env("OCI_PUBLIC_KEY_PATH")
    fingerprint         = get_env("OCI_FINGERPRINT", "")
}
```

For all the possible variables see [Pre flight checklist](#pre-flight-checklist)

The `provider.tf` will look like:

```markdown
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}
```

Now we can init terraform with:

```markdown
terraform init

terraform init
Initializing modules...
Downloading git::https://github.com/garutilorenzo/k3s-oci-cluster.git for k3s_cluster...
- k3s_cluster in .terraform/modules/k3s_cluster

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/oci from the dependency lock file
- Reusing previous version of hashicorp/template from the dependency lock file
- Using previously-installed hashicorp/template v2.2.0
- Using previously-installed hashicorp/oci v4.64.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Oracle provider setup

In the `example/` directory of this repo you need to create a `terraform.tfvars` file, the file will look like:

```markdown
fingerprint      = "<rsa_key_fingerprint>"
private_key_path = "~/.oci/<your_name>-oracle-cloud.pem"
user_ocid        = "<user_ocid>"
tenancy_ocid     = "<tenency_ocid>"
compartment_ocid = "<compartment_ocid>"
```

To find your `tenency_ocid` in the Ocacle Cloud console go to: **Governance and Administration > Tenency details**, then copy the OCID.

To find you `user_ocid` in the Ocacle Cloud console go to **User setting** (click on the icon in the top right corner, then click on User settings), click your username and then copy the OCID.

The `compartment_ocid` is the same as `tenency_ocid`.

The fingerprint is the fingerprint of your RSA key, you can find this vale under **User setting > API Keys**.

### Pre flight checklist

Once you have created the terraform.tfvars file edit the `main.tf` file (always in the `example/` directory) and set the following variables: