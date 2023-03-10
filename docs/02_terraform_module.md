<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | 2.3.2 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.9.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.2.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | 4.110.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.3.2 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.2.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.110.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.crossplane](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.kubevela](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [local_sensitive_file.load_cluster_kubeconfig](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/sensitive_file) | resource |
| [oci_core_default_route_table.default_oci_core_default_route_table](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_default_route_table) | resource |
| [oci_core_default_security_list.default_security_list](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_default_security_list) | resource |
| [oci_core_instance.k3s_extra_worker_node](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance) | resource |
| [oci_core_instance_configuration.k3s_server_template](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_configuration) | resource |
| [oci_core_instance_configuration.k3s_worker_template](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_configuration) | resource |
| [oci_core_instance_pool.k3s_servers](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_pool) | resource |
| [oci_core_instance_pool.k3s_workers](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_pool) | resource |
| [oci_core_internet_gateway.default_oci_core_internet_gateway](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_internet_gateway) | resource |
| [oci_core_network_security_group.lb_to_instances_http](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group.lb_to_instances_kubeapi](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group.public_lb_nsg](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.allow_http_from_all](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.allow_https_from_all](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.allow_kubeapi_from_all](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.nsg_to_instances_http](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.nsg_to_instances_https](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.nsg_to_instances_kubeapi](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_subnet.default_oci_core_subnet10](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_subnet) | resource |
| [oci_core_subnet.oci_core_subnet11](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_subnet) | resource |
| [oci_core_vcn.default_oci_core_vcn](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_vcn) | resource |
| [oci_identity_dynamic_group.compute_dynamic_group](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.compute_dynamic_group_policy](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/identity_policy) | resource |
| [oci_load_balancer_backend.k3s_kube_api_backend](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_backend) | resource |
| [oci_load_balancer_backend_set.k3s_kube_api_backend_set](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_backend_set) | resource |
| [oci_load_balancer_listener.k3s_kube_api_listener](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_listener) | resource |
| [oci_load_balancer_load_balancer.k3s_load_balancer](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_load_balancer) | resource |
| [oci_network_load_balancer_backend.k3s_http_backend](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend) | resource |
| [oci_network_load_balancer_backend.k3s_http_backend_extra_node](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend) | resource |
| [oci_network_load_balancer_backend.k3s_https_backend](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend) | resource |
| [oci_network_load_balancer_backend.k3s_https_backend_extra_node](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend) | resource |
| [oci_network_load_balancer_backend.k3s_kubeapi_backend](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend) | resource |
| [oci_network_load_balancer_backend_set.k3s_http_backend_set](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend_set) | resource |
| [oci_network_load_balancer_backend_set.k3s_https_backend_set](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend_set) | resource |
| [oci_network_load_balancer_backend_set.k3s_kubeapi_backend_set](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend_set) | resource |
| [oci_network_load_balancer_listener.k3s_http_listener](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_listener) | resource |
| [oci_network_load_balancer_listener.k3s_https_listener](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_listener) | resource |
| [oci_network_load_balancer_listener.k3s_kubeapi_listener](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_listener) | resource |
| [oci_network_load_balancer_network_load_balancer.k3s_public_lb](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_network_load_balancer) | resource |
| [random_password.k3s_token](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [ssh_resource.get_kube_master_config](https://registry.terraform.io/providers/loafoe/ssh/2.6.0/docs/resources/resource) | resource |
| [cloudinit_config.k3s_server_tpl](https://registry.terraform.io/providers/hashicorp/cloudinit/2.3.2/docs/data-sources/config) | data source |
| [cloudinit_config.k3s_worker_tpl](https://registry.terraform.io/providers/hashicorp/cloudinit/2.3.2/docs/data-sources/config) | data source |
| [http_http.my_public_ip](https://registry.terraform.io/providers/hashicorp/http/3.2.1/docs/data-sources/http) | data source |
| [oci_core_instance.k3s_servers_instances_ips](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance) | data source |
| [oci_core_instance.k3s_workers_instances_ips](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance) | data source |
| [oci_core_instance_pool_instances.k3s_servers_instances](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance_pool_instances) | data source |
| [oci_core_instance_pool_instances.k3s_workers_instances](https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance_pool_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_image_updater_release"></a> [argocd\_image\_updater\_release](#input\_argocd\_image\_updater\_release) | Argo CD release Image Updater | `string` | `"v0.12.0"` | no |
| <a name="input_argocd_release"></a> [argocd\_release](#input\_argocd\_release) | Argo CD release | `string` | `"v2.6.3"` | no |
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability domain | `string` | n/a | yes |
| <a name="input_certmanager_email_address"></a> [certmanager\_email\_address](#input\_certmanager\_email\_address) | Email address used for signing https certificates | `string` | `"changeme@example.com"` | no |
| <a name="input_certmanager_release"></a> [certmanager\_release](#input\_certmanager\_release) | Cert manager release | `string` | `"v1.11.0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of your K3s cluster | `string` | `"k3s-cluster"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Compartment ocid | `string` | n/a | yes |
| <a name="input_compute_shape"></a> [compute\_shape](#input\_compute\_shape) | Compute shape to use. NOTE Is mandatory to use this compute shape for provision 4 always free VMs | `string` | `"VM.Standard.A1.Flex"` | no |
| <a name="input_crossplane_release"></a> [crossplane\_release](#input\_crossplane\_release) | Crossplane release | `string` | `"1.11.2"` | no |
| <a name="input_default_security_list_tcp"></a> [default\_security\_list\_tcp](#input\_default\_security\_list\_tcp) | all the ports for security list - for tcp rules | `list` | <pre>[<br>  {<br>    "maxport": 22,<br>    "minport": 22,<br>    "name": "SSH"<br>  },<br>  {<br>    "maxport": 6443,<br>    "minport": 6443,<br>    "name": "6443"<br>  }<br>]</pre> | no |
| <a name="input_default_security_list_tcp_with_argo"></a> [default\_security\_list\_tcp\_with\_argo](#input\_default\_security\_list\_tcp\_with\_argo) | all the ports for security list + argocd - for tcp rules | `list` | <pre>[<br>  {<br>    "maxport": 22,<br>    "minport": 22,<br>    "name": "SSH"<br>  },<br>  {<br>    "maxport": 6443,<br>    "minport": 6443,<br>    "name": "6443"<br>  },<br>  {<br>    "maxport": 31000,<br>    "minport": 31000,<br>    "name": "ArgoCD"<br>  }<br>]</pre> | no |
| <a name="input_disable_ingress"></a> [disable\_ingress](#input\_disable\_ingress) | Disable all ingress controllers | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Current work environment (Example: staging/dev/prod). This value is used for tag all the deployed resources | `string` | `"staging"` | no |
| <a name="input_expose_argocd_nodeport"></a> [expose\_argocd\_nodeport](#input\_expose\_argocd\_nodeport) | Expose or not the ArgoCD server to my\_public\_ip\_cidr | `bool` | `false` | no |
| <a name="input_expose_kubeapi"></a> [expose\_kubeapi](#input\_expose\_kubeapi) | Expose or not the kubeapi server to the internet. Access is granted only from \_my\_public\_ip\_cidr* for security reasons | `bool` | `false` | no |
| <a name="input_fault_domains"></a> [fault\_domains](#input\_fault\_domains) | n/a | `list(any)` | <pre>[<br>  "FAULT-DOMAIN-1",<br>  "FAULT-DOMAIN-2",<br>  "FAULT-DOMAIN-3"<br>]</pre> | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | (Optional) The fingerprint for the user's RSA key. This can be found in user settings in the Oracle Cloud Infrastructure console. Required if auth is set to 'ApiKey', ignored otherwise.) | `string` | n/a | yes |
| <a name="input_http_lb_port"></a> [http\_lb\_port](#input\_http\_lb\_port) | HTTP port used by the public LB | `number` | `80` | no |
| <a name="input_https_lb_port"></a> [https\_lb\_port](#input\_https\_lb\_port) | HTTPS port used by the public LB | `number` | `443` | no |
| <a name="input_ingress_controller"></a> [ingress\_controller](#input\_ingress\_controller) | Define the ingress controller to use | `string` | `"default"` | no |
| <a name="input_ingress_controller_http_nodeport"></a> [ingress\_controller\_http\_nodeport](#input\_ingress\_controller\_http\_nodeport) | NodePort where nginx ingress will listen for http traffic | `number` | `30080` | no |
| <a name="input_ingress_controller_https_nodeport"></a> [ingress\_controller\_https\_nodeport](#input\_ingress\_controller\_https\_nodeport) | NodePort where nginx ingress will listen for https traffic | `number` | `30443` | no |
| <a name="input_install_argocd"></a> [install\_argocd](#input\_install\_argocd) | install Argo CD: A declarative, GitOps continuous delivery tool for Kubernetes | `bool` | `false` | no |
| <a name="input_install_argocd_image_updater"></a> [install\_argocd\_image\_updater](#input\_install\_argocd\_image\_updater) | Install Argo CD Image Updater: A tool to automatically update the container images of Kubernetes workloads that are managed by Argo CD | `bool` | `false` | no |
| <a name="input_install_certmanager"></a> [install\_certmanager](#input\_install\_certmanager) | Install cert manager 'Cloud native certificate management' | `bool` | `false` | no |
| <a name="input_install_crossplane"></a> [install\_crossplane](#input\_install\_crossplane) | Install Crossplane: Build control planes without needing to write code. Crossplane has a highly extensible backend that enables you to orchestrate applications and infrastructure no matter where they run, and a highly configurable frontend that lets you define the declarative API it offers | `bool` | `false` | no |
| <a name="input_install_kubevela"></a> [install\_kubevela](#input\_install\_kubevela) | Install KubeVela: Make shipping applications more enjoyable | `bool` | `false` | no |
| <a name="input_install_longhorn"></a> [install\_longhorn](#input\_install\_longhorn) | install longhorn 'Cloud native distributed block storage for Kubernetes'. To use longhorn set the k3s\_version < v1.25.x Ref | `bool` | `false` | no |
| <a name="input_istio_release"></a> [istio\_release](#input\_istio\_release) | n/a | `string` | `"1.16.1"` | no |
| <a name="input_k3s_extra_worker_node"></a> [k3s\_extra\_worker\_node](#input\_k3s\_extra\_worker\_node) | Deploy the third worker nodes. The node will be deployed outside the worker instance pools. Using OCI always free account you can't create instance pools with more than two servers. This workaround solve this problem. | `bool` | `true` | no |
| <a name="input_k3s_load_balancer_name"></a> [k3s\_load\_balancer\_name](#input\_k3s\_load\_balancer\_name) | Internal LB name | `string` | `"k3s internal load balancer"` | no |
| <a name="input_k3s_server_pool_size"></a> [k3s\_server\_pool\_size](#input\_k3s\_server\_pool\_size) | Number of k3s servers deployed | `number` | `1` | no |
| <a name="input_k3s_subnet"></a> [k3s\_subnet](#input\_k3s\_subnet) | Subnet where K3s will be exposed. Rquired if the subnet is different from the default gw subnet (Eg. 192.168.1.0/24) | `string` | `"default_route_table"` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | n/a | `string` | `"latest"` | no |
| <a name="input_k3s_worker_pool_size"></a> [k3s\_worker\_pool\_size](#input\_k3s\_worker\_pool\_size) | Number of k3s workers deployed | `number` | `2` | no |
| <a name="input_kube_api_port"></a> [kube\_api\_port](#input\_kube\_api\_port) | Kube-API default port | `number` | `6443` | no |
| <a name="input_kubeconfig_location"></a> [kubeconfig\_location](#input\_kubeconfig\_location) | Kubeconfig default location | `string` | `"~/.kube/config"` | no |
| <a name="input_kubevela_release"></a> [kubevela\_release](#input\_kubevela\_release) | Kubevela release | `string` | `"1.7.5"` | no |
| <a name="input_load_cluster_kubeconfig"></a> [load\_cluster\_kubeconfig](#input\_load\_cluster\_kubeconfig) | Enable to access cluster locally - overwriting var.kubeconfig\_location content!!!! | `bool` | `false` | no |
| <a name="input_longhorn_release"></a> [longhorn\_release](#input\_longhorn\_release) | Longhorn release | `string` | `"v1.4.0"` | no |
| <a name="input_my_public_ip_cidr"></a> [my\_public\_ip\_cidr](#input\_my\_public\_ip\_cidr) | Your public ip in CIDR format: (Example: xxx.xxx.xxx.xxx/32) | `string` | `""` | no |
| <a name="input_nginx_ingress_release"></a> [nginx\_ingress\_release](#input\_nginx\_ingress\_release) | NGINX ingress release | `string` | `"v1.5.1"` | no |
| <a name="input_oci_core_subnet_cidr10"></a> [oci\_core\_subnet\_cidr10](#input\_oci\_core\_subnet\_cidr10) | First subnet CIDR | `string` | `"10.0.0.0/24"` | no |
| <a name="input_oci_core_subnet_cidr11"></a> [oci\_core\_subnet\_cidr11](#input\_oci\_core\_subnet\_cidr11) | Second subnet CIDR | `string` | `"10.0.1.0/24"` | no |
| <a name="input_oci_core_subnet_dns_label10"></a> [oci\_core\_subnet\_dns\_label10](#input\_oci\_core\_subnet\_dns\_label10) | First subnet DNS label | `string` | `"defaultsubnet10"` | no |
| <a name="input_oci_core_subnet_dns_label11"></a> [oci\_core\_subnet\_dns\_label11](#input\_oci\_core\_subnet\_dns\_label11) | Second subnet DNS label | `string` | `"defaultsubnet11"` | no |
| <a name="input_oci_core_vcn_cidr"></a> [oci\_core\_vcn\_cidr](#input\_oci\_core\_vcn\_cidr) | VCN CIDR | `string` | `"10.0.0.0/16"` | no |
| <a name="input_oci_core_vcn_dns_label"></a> [oci\_core\_vcn\_dns\_label](#input\_oci\_core\_vcn\_dns\_label) | VCN DNS label | `string` | `"defaultvcn"` | no |
| <a name="input_oci_identity_dynamic_group_name"></a> [oci\_identity\_dynamic\_group\_name](#input\_oci\_identity\_dynamic\_group\_name) | Dynamic group name. This dynamic group will contains all the instances of this specific compartment | `string` | `"Compute_Dynamic_Group"` | no |
| <a name="input_oci_identity_policy_name"></a> [oci\_identity\_policy\_name](#input\_oci\_identity\_policy\_name) | Policy name. This policy will allow dynamic group 'oci\_identity\_dynamic\_group\_name' to read OCI api without auth | `string` | `"Compute_To_Oci_Api_Policy"` | no |
| <a name="input_os_image_id"></a> [os\_image\_id](#input\_os\_image\_id) | Image id to use | `string` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Path to your private OCI RSA key | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to your public workstation SSH key | `string` | n/a | yes |
| <a name="input_public_lb_shape"></a> [public\_lb\_shape](#input\_public\_lb\_shape) | LB shape for the public LB. NOTE is mandatory to use this kind of shape to provision two always free LB (public and private) | `string` | `"flexible"` | no |
| <a name="input_public_load_balancer_name"></a> [public\_load\_balancer\_name](#input\_public\_load\_balancer\_name) | Public LB name | `string` | `"K3s public LB"` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region based on your needs | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | n/a | `string` | n/a | yes |
| <a name="input_unique_tag_key"></a> [unique\_tag\_key](#input\_unique\_tag\_key) | Unique tag name used for tagging all the deployed resources | `string` | `"k3s-provisioner"` | no |
| <a name="input_unique_tag_value"></a> [unique\_tag\_value](#input\_unique\_tag\_value) | Unique value used with unique*tag\_key | `string` | `""` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argo_instructions"></a> [argo\_instructions](#output\_argo\_instructions) | n/a |
| <a name="output_k3s_servers_ips"></a> [k3s\_servers\_ips](#output\_k3s\_servers\_ips) | n/a |
| <a name="output_k3s_workers_ips"></a> [k3s\_workers\_ips](#output\_k3s\_workers\_ips) | n/a |
| <a name="output_public_lb_ip"></a> [public\_lb\_ip](#output\_public\_lb\_ip) | n/a |
| <a name="output_ssh_instructions"></a> [ssh\_instructions](#output\_ssh\_instructions) | n/a |
<!-- END_TF_DOCS -->