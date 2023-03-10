variable "region" {
  type        = string
  description = "OCI region based on your needs"
}

variable "availability_domain" {
  type        = string
  description = "Availability domain"
}

variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment ocid"
}

variable "environment" {
  type        = string
  description = "Current work environment (Example: staging/dev/prod). This value is used for tag all the deployed resources"
  default     = "staging"
}

variable "cluster_name" {
  type        = string
  description = "Name of your K3s cluster"
  default     = "k3s-cluster"
}

variable "os_image_id" {
  type        = string
  description = "Image id to use"
}

variable "k3s_version" {
  type    = string
  default = "latest"
}

variable "k3s_subnet" {
  type        = string
  description = "Subnet where K3s will be exposed. Rquired if the subnet is different from the default gw subnet (Eg. 192.168.1.0/24)"
  default     = "default_route_table"
}

variable "fault_domains" {
  type    = list(any)
  default = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]
}

variable "public_key_path" {
  type        = string
  description = "Path to your public workstation SSH key"
}

variable "private_key_path" {
  type        = string
  description = "Path to your private OCI RSA key"
}
variable "fingerprint" {
  type        = string
  description = "(Optional) The fingerprint for the user's RSA key. This can be found in user settings in the Oracle Cloud Infrastructure console. Required if auth is set to 'ApiKey', ignored otherwise.)"
}

variable "compute_shape" {
  type        = string
  description = "Compute shape to use. NOTE Is mandatory to use this compute shape for provision 4 always free VMs"
  default     = "VM.Standard.A1.Flex"
}

variable "public_lb_shape" {
  type        = string
  description = "LB shape for the public LB. NOTE is mandatory to use this kind of shape to provision two always free LB (public and private)"
  default     = "flexible"
}

variable "oci_identity_dynamic_group_name" {
  type        = string
  description = "Dynamic group name. This dynamic group will contains all the instances of this specific compartment"
  default     = "Compute_Dynamic_Group"
}

variable "oci_identity_policy_name" {
  type        = string
  description = "Policy name. This policy will allow dynamic group 'oci_identity_dynamic_group_name' to read OCI api without auth"
  default     = "Compute_To_Oci_Api_Policy"
}

variable "oci_core_vcn_dns_label" {
  type        = string
  description = "VCN DNS label"
  default     = "defaultvcn"
}

variable "oci_core_subnet_dns_label10" {
  type        = string
  description = "	First subnet DNS label"
  default     = "defaultsubnet10"
}

variable "oci_core_subnet_dns_label11" {
  type        = string
  description = "Second subnet DNS label"
  default     = "defaultsubnet11"
}

variable "oci_core_vcn_cidr" {
  type        = string
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "oci_core_subnet_cidr10" {
  type        = string
  description = "	First subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "oci_core_subnet_cidr11" {
  type        = string
  description = "Second subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "kube_api_port" {
  type        = number
  description = "Kube-API default port"
  default     = 6443
}

variable "k3s_load_balancer_name" {
  type        = string
  description = "Internal LB name"
  default     = "k3s internal load balancer"
}

variable "public_load_balancer_name" {
  type        = string
  description = "Public LB name"
  default     = "K3s public LB"
}

variable "http_lb_port" {
  type        = number
  description = "HTTP port used by the public LB"
  default     = 80
}

variable "https_lb_port" {
  type        = number
  description = "HTTPS port used by the public LB"
  default     = 443
}

variable "ingress_controller_http_nodeport" {
  type        = number
  description = "NodePort where nginx ingress will listen for http traffic"
  default     = 30080
}

variable "ingress_controller_https_nodeport" {
  type        = number
  description = "NodePort where nginx ingress will listen for https traffic"
  default     = 30443
}

variable "k3s_server_pool_size" {
  type        = number
  description = "Number of k3s servers deployed"
  default     = 1
}

variable "k3s_worker_pool_size" {
  type        = number
  description = "Number of k3s workers deployed"
  default     = 2
}

variable "k3s_extra_worker_node" {
  type        = bool
  description = "Deploy the third worker nodes. The node will be deployed outside the worker instance pools. Using OCI always free account you can't create instance pools with more than two servers. This workaround solve this problem."
  default     = true
}

variable "unique_tag_key" {
  type        = string
  description = "Unique tag name used for tagging all the deployed resources"
  default     = "k3s-provisioner"
}

variable "unique_tag_value" {
  type        = string
  description = "Unique value used with unique*tag_key"
  default     = ""
}

variable "my_public_ip_cidr" {
  type        = string
  description = "Your public ip in CIDR format: (Example: xxx.xxx.xxx.xxx/32)"
  default     = ""
}

variable "istio_release" {
  type    = string
  default = "1.16.1"
}

variable "disable_ingress" {
  type        = bool
  description = "Disable all ingress controllers"
  default     = false
}

variable "ingress_controller" {
  type        = string
  description = "Define the ingress controller to use"
  default     = "default"
  validation {
    condition     = contains(["default", "nginx", "traefik2", "istio"], var.ingress_controller)
    error_message = "Supported ingress controllers are: default, nginx, traefik2, istio"
  }
}

variable "nginx_ingress_release" {
  type        = string
  description = "NGINX ingress release"
  default     = "v1.5.1"
}

variable "install_certmanager" {
  type        = bool
  description = "Install cert manager 'Cloud native certificate management'"
  default     = false
}

variable "certmanager_release" {
  type        = string
  description = "Cert manager release"
  default     = "v1.11.0"
}

variable "certmanager_email_address" {
  type        = string
  description = "Email address used for signing https certificates"
  default     = "changeme@example.com"
}

variable "install_longhorn" {
  type        = bool
  description = "install longhorn 'Cloud native distributed block storage for Kubernetes'. To use longhorn set the k3s_version < v1.25.x Ref"
  default     = false
}

variable "longhorn_release" {
  type        = string
  description = "Longhorn release"
  default     = "v1.4.0"
}

variable "install_argocd" {
  type        = bool
  description = "install Argo CD: A declarative, GitOps continuous delivery tool for Kubernetes"
  default     = false
}

variable "argocd_release" {
  type        = string
  description = "Argo CD release"
  default     = "v2.6.3"
}

variable "expose_argocd_nodeport" {
  type        = bool
  description = "Expose or not the ArgoCD server to my_public_ip_cidr"
  default     = false
}

variable "default_security_list_tcp" {
  description = "all the ports for security list - for tcp rules"
  default = [
    { name    = "SSH"
      minport = 22
      maxport = 22
    },
    { name    = "6443"
      minport = 6443
      maxport = 6443
    }
  ]
}

variable "default_security_list_tcp_with_argo" {
  description = "all the ports for security list + argocd - for tcp rules"
  default = [
    { name    = "SSH"
      minport = 22
      maxport = 22
    },
    { name    = "6443"
      minport = 6443
      maxport = 6443
    },
    { name    = "ArgoCD"
      minport = 31000
      maxport = 31000
    }
  ]
}

variable "install_argocd_image_updater" {
  type        = bool
  description = "Install Argo CD Image Updater: A tool to automatically update the container images of Kubernetes workloads that are managed by Argo CD"
  default     = false
}

variable "argocd_image_updater_release" {
  type        = string
  description = "Argo CD release Image Updater"
  default     = "v0.12.0"
}

variable "kubevela_release" {
  type        = string
  description = "Kubevela release"
  default     = "1.7.5"
}

variable "install_kubevela" {
  type        = bool
  description = "Install KubeVela: Make shipping applications more enjoyable"
  default     = false
}

variable "crossplane_release" {
  type        = string
  description = "Crossplane release"
  default     = "1.11.2"
}

variable "install_crossplane" {
  type        = bool
  description = "Install Crossplane: Build control planes without needing to write code. Crossplane has a highly extensible backend that enables you to orchestrate applications and infrastructure no matter where they run, and a highly configurable frontend that lets you define the declarative API it offers"
  default     = false
}

variable "expose_kubeapi" {
  type        = bool
  description = "Expose or not the kubeapi server to the internet. Access is granted only from _my_public_ip_cidr* for security reasons"
  default     = false
}

variable "kubeconfig_location" {
  type        = string
  description = "Kubeconfig default location"
  default     = "~/.kube/config"
}

variable "load_cluster_kubeconfig" {
  type        = bool
  description = "Enable to access cluster locally - overwriting var.kubeconfig_location content!!!!"
  default     = false
}
