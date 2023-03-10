<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
<head>
  <meta charset="utf-8" />
  <meta name="generator" content="pandoc" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
  <title>01_introduction</title>
  <style>
    code{white-space: pre-wrap;}
    span.smallcaps{font-variant: small-caps;}
    span.underline{text-decoration: underline;}
    div.column{display: inline-block; vertical-align: top; width: 50%;}
    div.hanging-indent{margin-left: 1.5em; text-indent: -1.5em;}
    ul.task-list{list-style: none;}
  </style>
</head>
<body>
<p><a href="https://github.com/Looty/k3s-oci-cluster/actions/workflows/ci.yml"><img src="https://github.com/Looty/k3s-oci-cluster/actions/workflows/ci.yml/badge.svg" alt="Wordpress CI" /></a> <a href="https://github.com/Looty/k3s-oci-cluster/issues"><img src="https://img.shields.io/github/issues/Looty/k3s-oci-cluster" alt="GitHub issues" /></a> <img src="https://img.shields.io/github/license/Looty/k3s-oci-cluster" alt="GitHub" /> <a href="https://github.com/Looty/k3s-oci-cluster/network"><img src="https://img.shields.io/github/forks/Looty/k3s-oci-cluster" alt="GitHub forks" /></a> <a href="https://github.com/Looty/k3s-oci-cluster/stargazers"><img src="https://img.shields.io/github/stars/Looty/k3s-oci-cluster" alt="GitHub stars" /></a></p>
<p align="center">
  <img src="https://garutilorenzo.github.io/images/k3s-logo-large.png?" alt="k3s Logo"/>
</p>

<h1 id="oci-k3s-cluster">OCI K3s cluster</h1>
<p>Deploy a Kubernetes cluster for free, using K3s and Oracle <a href="https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm">always free</a> resources.</p>
<h1 id="table-of-contents">Table of Contents</h1>
<ul>
<li><a href="#oci-k3s-cluster">OCI K3s cluster</a></li>
<li><a href="#table-of-contents">Table of Contents</a>
<ul>
<li><a href="#important-notes">Important notes</a></li>
<li><a href="#requirements">Requirements</a></li>
<li><a href="#supported-os">Supported OS</a></li>
<li><a href="#terraform-oci-user-creation-optional">Terraform OCI user creation (Optional)</a>
<ul>
<li><a href="#example-rsa-key-generation">Example RSA key generation</a></li>
</ul></li>
<li><a href="#project-setup">Project setup</a></li>
<li><a href="#oracle-provider-setup">Oracle provider setup</a></li>
<li><a href="#pre-flight-checklist">Pre flight checklist</a>
<ul>
<li><a href="#how-to-find-the-availability-domain-name">How to find the availability domain name</a></li>
<li><a href="#how-to-list-all-the-os-images">How to list all the OS images</a></li>
</ul></li>
<li><a href="#notes-about-oci-always-free-resources">Notes about OCI always free resources</a></li>
<li><a href="#notes-about-k3s">Notes about K3s</a></li>
<li><a href="#infrastructure-overview">Infrastructure overview</a></li>
<li><a href="#cluster-resource-deployed">Cluster resource deployed</a>
<ul>
<li><a href="#nginx-ingress-controller">Nginx ingress controller</a></li>
<li><a href="#cert-manager">Cert-manager</a></li>
</ul></li>
<li><a href="#deploy">Deploy</a>
<ul>
<li><a href="#public-lb-check">Public LB check</a></li>
<li><a href="#longhorn-check">Longhorn check</a></li>
<li><a href="#argocd-check">Argocd check</a></li>
</ul></li>
<li><a href="#deploy-a-sample-stack">Deploy a sample stack</a></li>
<li><a href="#clean-up">Clean up</a></li>
<li><a href="#known-bugs">Known Bugs</a>
<ul>
<li><a href="#409-conflict">409-Conflict</a></li>
<li><a href="#kubectl-exec-failure">kubectl exec failure</a></li>
</ul></li>
</ul></li>
</ul>
<p><strong>Note</strong> choose a region with enough ARM capacity</p>
<h3 id="important-notes">Important notes</h3>
<ul>
<li>This is repo shows only how to use terraform with the Oracle Cloud infrastructure and use only the <strong>always free</strong> resources. This examples are <strong>not</strong> for a production environment.</li>
<li>At the end of your trial period (30 days). All the paid resources deployed will be stopped/terminated</li>
<li>At the end of your trial period (30 days), if you have a running compute instance it will be stopped/hibernated</li>
</ul>
<h3 id="requirements">Requirements</h3>
<p>To use this repo you will need:</p>
<ul>
<li>an Oracle Cloud account. You can register <a href="https://cloud.oracle.com">here</a></li>
</ul>
<p>Once you get the account, follow the <em>Before you begin</em> and <em>1. Prepare</em> step in <a href="https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm">this</a> document.</p>
<h3 id="supported-os">Supported OS</h3>
<p>This module was tested with:</p>
<ul>
<li>Ubuntu 20.04, 22.04 (ubuntu remote user)</li>
<li>Ubuntu 20.04, 22.04 Minimal (ubuntu remote user)</li>
<li>Oracle Linux 8, 9 (opc remote user)</li>
</ul>
<h3 id="terraform-oci-user-creation-optional">Terraform OCI user creation (Optional)</h3>
<p>Is always recommended to create a separate user and group in your preferred <a href="https://cloud.oracle.com/identity/domains">domain</a> to use with Terraform. This user must have less privileges possible (Zero trust policy). Below is an example policy that you can <a href="https://cloud.oracle.com/identity/policies">create</a> allow <code>terraform-group</code> to manage all the resources needed by this module:</p>
<pre class="markdown"><code>Allow group terraform-group to manage virtual-network-family  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage instance-family  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage compute-management-family  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage volume-family  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage load-balancers  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage network-load-balancers  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage dynamic-groups in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage policies in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to read network-load-balancers  in compartment id &lt;compartment_ocid&gt;
Allow group terraform-group to manage dynamic-groups in tenancy
</code></pre>
<p>See <a href="#oracle-provider-setup">how</a> to find the compartment ocid. The user and the group have to be manually created before using this module. To create the user go to <strong>Identity &amp; Security -&gt; Users</strong>, then create the group in <strong>Identity &amp; Security -&gt; Groups</strong> and associate the newly created user to the group. The last step is to create the policy in <strong>Identity &amp; Security -&gt; Policies</strong>.</p>
<h4 id="example-rsa-key-generation">Example RSA key generation</h4>
<p>To use terraform with the Oracle Cloud infrastructure you need to generate an RSA key. Generate the rsa key with:</p>
<pre class="markdown"><code>openssl genrsa -out ~/.oci/&lt;your_name&gt;-oracle-cloud.pem 4096
chmod 600 ~/.oci/&lt;your_name&gt;-oracle-cloud.pem
openssl rsa -pubout -in ~/.oci/&lt;your_name&gt;-oracle-cloud.pem -out ~/.oci/&lt;your_name&gt;-oracle-cloud_public.pem
</code></pre>
<p>replace <code>&lt;your_name&gt;</code> with your name or a string you prefer.</p>
<p><strong>NOTE</strong>: <code>~/.oci/&lt;your_name&gt;-oracle-cloud_public.pem</code> will be used in <code>terraform.tfvars</code> by the Oracle provider plugin, so please take note of this string.</p>
<h3 id="project-setup">Project setup</h3>
<p>Clone this repo and go in the <code>example/</code> directory:</p>
<pre class="markdown"><code>git clone https://github.com/garutilorenzo/k3s-oci-cluster.git
cd k3s-oci-cluster/example/
</code></pre>
<p>Now you have to edit the <code>main.tf</code> file and you have to create the <code>terraform.tfvars</code> file. For more detail see <a href="#oracle-provider-setup">Oracle provider setup</a> and <a href="#pre-flight-checklist">Pre flight checklist</a>.</p>
<p>Or if you prefer you can create an new empty directory in your workspace and create this three files:</p>
<ul>
<li><code>terraform.tfvars</code> - More details in <a href="#oracle-provider-setup">Oracle provider setup</a></li>
<li><code>main.tf</code></li>
<li><code>provider.tf</code></li>
</ul>
<p>The <code>terragrunt.hcl</code> file will look like:</p>
<pre class="markdown"><code>terraform {
    source = &quot;./modules//k3s-cluster&quot;
}

// Error : 409 - Conflict fix
retry_max_attempts       = 2
retry_sleep_interval_sec = 10
retryable_errors = [
  &quot;(?m).*409-Conflict*&quot;,
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
    tenancy_ocid        = get_env(&quot;OCI_TENANCY_OCID&quot;)
    compartment_ocid    = get_env(&quot;OCI_COMPARTMENT_OCID&quot;)
    region              = get_env(&quot;OCI_REGION&quot;)
    os_image_id         = get_env(&quot;OCI_OS_IMAGE_ID&quot;)
    availability_domain = get_env(&quot;OCI_AVAILABILITY_DOMAIN&quot;)
    user_ocid           = get_env(&quot;OCI_USER_OCID&quot;)
    private_key_path    = get_env(&quot;OCI_PRIVATE_KEY_PATH&quot;)
    public_key_path     = get_env(&quot;OCI_PUBLIC_KEY_PATH&quot;)
    fingerprint         = get_env(&quot;OCI_FINGERPRINT&quot;, &quot;&quot;)
}
</code></pre>
<p>For all the possible variables see <a href="#pre-flight-checklist">Pre flight checklist</a></p>
<p>The <code>provider.tf</code> will look like:</p>
<pre class="markdown"><code>provider &quot;oci&quot; {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}
</code></pre>
<p>Now we can init terraform with:</p>
<pre class="markdown"><code>terraform init

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

You may now begin working with Terraform. Try running &quot;terraform plan&quot; to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
</code></pre>
<h3 id="oracle-provider-setup">Oracle provider setup</h3>
<p>In the <code>example/</code> directory of this repo you need to create a <code>terraform.tfvars</code> file, the file will look like:</p>
<pre class="markdown"><code>fingerprint      = &quot;&lt;rsa_key_fingerprint&gt;&quot;
private_key_path = &quot;~/.oci/&lt;your_name&gt;-oracle-cloud.pem&quot;
user_ocid        = &quot;&lt;user_ocid&gt;&quot;
tenancy_ocid     = &quot;&lt;tenency_ocid&gt;&quot;
compartment_ocid = &quot;&lt;compartment_ocid&gt;&quot;
</code></pre>
<p>To find your <code>tenency_ocid</code> in the Ocacle Cloud console go to: <strong>Governance and Administration &gt; Tenency details</strong>, then copy the OCID.</p>
<p>To find you <code>user_ocid</code> in the Ocacle Cloud console go to <strong>User setting</strong> (click on the icon in the top right corner, then click on User settings), click your username and then copy the OCID.</p>
<p>The <code>compartment_ocid</code> is the same as <code>tenency_ocid</code>.</p>
<p>The fingerprint is the fingerprint of your RSA key, you can find this vale under <strong>User setting &gt; API Keys</strong>.</p>
<h3 id="pre-flight-checklist">Pre flight checklist</h3>
<p>Once you have created the terraform.tfvars file edit the <code>main.tf</code> file (always in the <code>example/</code> directory) and set the following variables:</p>
<!-- BEGIN_TF_DOCS -->

<h2 id="requirements-1">Requirements</h2>
<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Version</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><a name="requirement_cloudinit"></a> <a href="#requirement_cloudinit">cloudinit</a></td>
<td>2.3.2</td>
</tr>
<tr class="even">
<td><a name="requirement_helm"></a> <a href="#requirement_helm">helm</a></td>
<td>2.9.0</td>
</tr>
<tr class="odd">
<td><a name="requirement_http"></a> <a href="#requirement_http">http</a></td>
<td>3.2.1</td>
</tr>
<tr class="even">
<td><a name="requirement_local"></a> <a href="#requirement_local">local</a></td>
<td>2.4.0</td>
</tr>
<tr class="odd">
<td><a name="requirement_oci"></a> <a href="#requirement_oci">oci</a></td>
<td>4.110.0</td>
</tr>
<tr class="even">
<td><a name="requirement_random"></a> <a href="#requirement_random">random</a></td>
<td>3.4.3</td>
</tr>
<tr class="odd">
<td><a name="requirement_ssh"></a> <a href="#requirement_ssh">ssh</a></td>
<td>2.6.0</td>
</tr>
</tbody>
</table>
<h2 id="providers">Providers</h2>
<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Version</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><a name="provider_cloudinit"></a> <a href="#provider_cloudinit">cloudinit</a></td>
<td>2.3.2</td>
</tr>
<tr class="even">
<td><a name="provider_helm"></a> <a href="#provider_helm">helm</a></td>
<td>2.9.0</td>
</tr>
<tr class="odd">
<td><a name="provider_http"></a> <a href="#provider_http">http</a></td>
<td>3.2.1</td>
</tr>
<tr class="even">
<td><a name="provider_local"></a> <a href="#provider_local">local</a></td>
<td>2.4.0</td>
</tr>
<tr class="odd">
<td><a name="provider_oci"></a> <a href="#provider_oci">oci</a></td>
<td>4.110.0</td>
</tr>
<tr class="even">
<td><a name="provider_random"></a> <a href="#provider_random">random</a></td>
<td>3.4.3</td>
</tr>
<tr class="odd">
<td><a name="provider_ssh"></a> <a href="#provider_ssh">ssh</a></td>
<td>2.6.0</td>
</tr>
</tbody>
</table>
<h2 id="modules">Modules</h2>
<p>No modules.</p>
<h2 id="resources">Resources</h2>
<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release">helm_release.crossplane</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release">helm_release.kubevela</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/sensitive_file">local_sensitive_file.load_cluster_kubeconfig</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_default_route_table">oci_core_default_route_table.default_oci_core_default_route_table</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_default_security_list">oci_core_default_security_list.default_security_list</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance">oci_core_instance.k3s_extra_worker_node</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_configuration">oci_core_instance_configuration.k3s_server_template</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_configuration">oci_core_instance_configuration.k3s_worker_template</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_pool">oci_core_instance_pool.k3s_servers</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_instance_pool">oci_core_instance_pool.k3s_workers</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_internet_gateway">oci_core_internet_gateway.default_oci_core_internet_gateway</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group">oci_core_network_security_group.lb_to_instances_http</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group">oci_core_network_security_group.lb_to_instances_kubeapi</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group">oci_core_network_security_group.public_lb_nsg</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule">oci_core_network_security_group_security_rule.allow_http_from_all</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule">oci_core_network_security_group_security_rule.allow_https_from_all</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule">oci_core_network_security_group_security_rule.allow_kubeapi_from_all</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule">oci_core_network_security_group_security_rule.nsg_to_instances_http</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule">oci_core_network_security_group_security_rule.nsg_to_instances_https</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_network_security_group_security_rule">oci_core_network_security_group_security_rule.nsg_to_instances_kubeapi</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_subnet">oci_core_subnet.default_oci_core_subnet10</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_subnet">oci_core_subnet.oci_core_subnet11</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/core_vcn">oci_core_vcn.default_oci_core_vcn</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/identity_dynamic_group">oci_identity_dynamic_group.compute_dynamic_group</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/identity_policy">oci_identity_policy.compute_dynamic_group_policy</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_backend">oci_load_balancer_backend.k3s_kube_api_backend</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_backend_set">oci_load_balancer_backend_set.k3s_kube_api_backend_set</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_listener">oci_load_balancer_listener.k3s_kube_api_listener</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/load_balancer_load_balancer">oci_load_balancer_load_balancer.k3s_load_balancer</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend">oci_network_load_balancer_backend.k3s_http_backend</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend">oci_network_load_balancer_backend.k3s_http_backend_extra_node</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend">oci_network_load_balancer_backend.k3s_https_backend</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend">oci_network_load_balancer_backend.k3s_https_backend_extra_node</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend">oci_network_load_balancer_backend.k3s_kubeapi_backend</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend_set">oci_network_load_balancer_backend_set.k3s_http_backend_set</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend_set">oci_network_load_balancer_backend_set.k3s_https_backend_set</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_backend_set">oci_network_load_balancer_backend_set.k3s_kubeapi_backend_set</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_listener">oci_network_load_balancer_listener.k3s_http_listener</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_listener">oci_network_load_balancer_listener.k3s_https_listener</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_listener">oci_network_load_balancer_listener.k3s_kubeapi_listener</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/resources/network_load_balancer_network_load_balancer">oci_network_load_balancer_network_load_balancer.k3s_public_lb</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password">random_password.k3s_token</a></td>
<td>resource</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/loafoe/ssh/2.6.0/docs/resources/resource">ssh_resource.get_kube_master_config</a></td>
<td>resource</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/hashicorp/cloudinit/2.3.2/docs/data-sources/config">cloudinit_config.k3s_server_tpl</a></td>
<td>data source</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/hashicorp/cloudinit/2.3.2/docs/data-sources/config">cloudinit_config.k3s_worker_tpl</a></td>
<td>data source</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/hashicorp/http/3.2.1/docs/data-sources/http">http_http.my_public_ip</a></td>
<td>data source</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance">oci_core_instance.k3s_servers_instances_ips</a></td>
<td>data source</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance">oci_core_instance.k3s_workers_instances_ips</a></td>
<td>data source</td>
</tr>
<tr class="odd">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance_pool_instances">oci_core_instance_pool_instances.k3s_servers_instances</a></td>
<td>data source</td>
</tr>
<tr class="even">
<td><a href="https://registry.terraform.io/providers/oracle/oci/4.110.0/docs/data-sources/core_instance_pool_instances">oci_core_instance_pool_instances.k3s_workers_instances</a></td>
<td>data source</td>
</tr>
</tbody>
</table>
<h2 id="inputs">Inputs</h2>
<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Description</th>
<th>Type</th>
<th>Default</th>
<th style="text-align: center;">Required</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><a name="input_argocd_image_updater_release"></a> <a href="#input_argocd_image_updater_release">argocd_image_updater_release</a></td>
<td>Argo CD release Image Updater</td>
<td><code>string</code></td>
<td><code>"v0.12.0"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_argocd_release"></a> <a href="#input_argocd_release">argocd_release</a></td>
<td>Argo CD release</td>
<td><code>string</code></td>
<td><code>"v2.6.3"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_availability_domain"></a> <a href="#input_availability_domain">availability_domain</a></td>
<td>Availability domain</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="even">
<td><a name="input_certmanager_email_address"></a> <a href="#input_certmanager_email_address">certmanager_email_address</a></td>
<td>Email address used for signing https certificates</td>
<td><code>string</code></td>
<td><code>"changeme@example.com"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_certmanager_release"></a> <a href="#input_certmanager_release">certmanager_release</a></td>
<td>Cert manager release</td>
<td><code>string</code></td>
<td><code>"v1.11.0"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_cluster_name"></a> <a href="#input_cluster_name">cluster_name</a></td>
<td>Name of your K3s cluster</td>
<td><code>string</code></td>
<td><code>"k3s-cluster"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_compartment_ocid"></a> <a href="#input_compartment_ocid">compartment_ocid</a></td>
<td>Compartment ocid</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="even">
<td><a name="input_compute_shape"></a> <a href="#input_compute_shape">compute_shape</a></td>
<td>Compute shape to use. NOTE Is mandatory to use this compute shape for provision 4 always free VMs</td>
<td><code>string</code></td>
<td><code>"VM.Standard.A1.Flex"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_crossplane_release"></a> <a href="#input_crossplane_release">crossplane_release</a></td>
<td>Crossplane release</td>
<td><code>string</code></td>
<td><code>"1.11.2"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_default_security_list_tcp"></a> <a href="#input_default_security_list_tcp">default_security_list_tcp</a></td>
<td>all the ports for security list - for tcp rules</td>
<td><code>list</code></td>
<td><pre>[<br> {<br> "maxport": 22,<br> "minport": 22,<br> "name": "SSH"<br> },<br> {<br> "maxport": 6443,<br> "minport": 6443,<br> "name": "6443"<br> }<br>]</pre></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_default_security_list_tcp_with_argo"></a> <a href="#input_default_security_list_tcp_with_argo">default_security_list_tcp_with_argo</a></td>
<td>all the ports for security list + argocd - for tcp rules</td>
<td><code>list</code></td>
<td><pre>[<br> {<br> "maxport": 22,<br> "minport": 22,<br> "name": "SSH"<br> },<br> {<br> "maxport": 6443,<br> "minport": 6443,<br> "name": "6443"<br> },<br> {<br> "maxport": 31000,<br> "minport": 31000,<br> "name": "ArgoCD"<br> }<br>]</pre></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_disable_ingress"></a> <a href="#input_disable_ingress">disable_ingress</a></td>
<td>Disable all ingress controllers</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_environment"></a> <a href="#input_environment">environment</a></td>
<td>Current work environment (Example: staging/dev/prod). This value is used for tag all the deployed resources</td>
<td><code>string</code></td>
<td><code>"staging"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_expose_argocd_nodeport"></a> <a href="#input_expose_argocd_nodeport">expose_argocd_nodeport</a></td>
<td>Expose or not the ArgoCD server to my_public_ip_cidr</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_expose_kubeapi"></a> <a href="#input_expose_kubeapi">expose_kubeapi</a></td>
<td>Expose or not the kubeapi server to the internet. Access is granted only from _my_public_ip_cidr* for security reasons</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_fault_domains"></a> <a href="#input_fault_domains">fault_domains</a></td>
<td>n/a</td>
<td><code>list(any)</code></td>
<td><pre>[<br> "FAULT-DOMAIN-1",<br> "FAULT-DOMAIN-2",<br> "FAULT-DOMAIN-3"<br>]</pre></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_fingerprint"></a> <a href="#input_fingerprint">fingerprint</a></td>
<td>(Optional) The fingerprint for the user's RSA key. This can be found in user settings in the Oracle Cloud Infrastructure console. Required if auth is set to 'ApiKey', ignored otherwise.)</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="even">
<td><a name="input_http_lb_port"></a> <a href="#input_http_lb_port">http_lb_port</a></td>
<td>HTTP port used by the public LB</td>
<td><code>number</code></td>
<td><code>80</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_https_lb_port"></a> <a href="#input_https_lb_port">https_lb_port</a></td>
<td>HTTPS port used by the public LB</td>
<td><code>number</code></td>
<td><code>443</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_ingress_controller"></a> <a href="#input_ingress_controller">ingress_controller</a></td>
<td>Define the ingress controller to use</td>
<td><code>string</code></td>
<td><code>"default"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_ingress_controller_http_nodeport"></a> <a href="#input_ingress_controller_http_nodeport">ingress_controller_http_nodeport</a></td>
<td>NodePort where nginx ingress will listen for http traffic</td>
<td><code>number</code></td>
<td><code>30080</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_ingress_controller_https_nodeport"></a> <a href="#input_ingress_controller_https_nodeport">ingress_controller_https_nodeport</a></td>
<td>NodePort where nginx ingress will listen for https traffic</td>
<td><code>number</code></td>
<td><code>30443</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_install_argocd"></a> <a href="#input_install_argocd">install_argocd</a></td>
<td>install Argo CD: A declarative, GitOps continuous delivery tool for Kubernetes</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_install_argocd_image_updater"></a> <a href="#input_install_argocd_image_updater">install_argocd_image_updater</a></td>
<td>Install Argo CD Image Updater: A tool to automatically update the container images of Kubernetes workloads that are managed by Argo CD</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_install_certmanager"></a> <a href="#input_install_certmanager">install_certmanager</a></td>
<td>Install cert manager 'Cloud native certificate management'</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_install_crossplane"></a> <a href="#input_install_crossplane">install_crossplane</a></td>
<td>Install Crossplane: Build control planes without needing to write code. Crossplane has a highly extensible backend that enables you to orchestrate applications and infrastructure no matter where they run, and a highly configurable frontend that lets you define the declarative API it offers</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_install_kubevela"></a> <a href="#input_install_kubevela">install_kubevela</a></td>
<td>Install KubeVela: Make shipping applications more enjoyable</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_install_longhorn"></a> <a href="#input_install_longhorn">install_longhorn</a></td>
<td>install longhorn 'Cloud native distributed block storage for Kubernetes'. To use longhorn set the k3s_version &lt; v1.25.x Ref</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_istio_release"></a> <a href="#input_istio_release">istio_release</a></td>
<td>n/a</td>
<td><code>string</code></td>
<td><code>"1.16.1"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_k3s_extra_worker_node"></a> <a href="#input_k3s_extra_worker_node">k3s_extra_worker_node</a></td>
<td>Deploy the third worker nodes. The node will be deployed outside the worker instance pools. Using OCI always free account you can't create instance pools with more than two servers. This workaround solve this problem.</td>
<td><code>bool</code></td>
<td><code>true</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_k3s_load_balancer_name"></a> <a href="#input_k3s_load_balancer_name">k3s_load_balancer_name</a></td>
<td>Internal LB name</td>
<td><code>string</code></td>
<td><code>"k3s internal load balancer"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_k3s_server_pool_size"></a> <a href="#input_k3s_server_pool_size">k3s_server_pool_size</a></td>
<td>Number of k3s servers deployed</td>
<td><code>number</code></td>
<td><code>1</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_k3s_subnet"></a> <a href="#input_k3s_subnet">k3s_subnet</a></td>
<td>Subnet where K3s will be exposed. Rquired if the subnet is different from the default gw subnet (Eg. 192.168.1.0/24)</td>
<td><code>string</code></td>
<td><code>"default_route_table"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_k3s_version"></a> <a href="#input_k3s_version">k3s_version</a></td>
<td>n/a</td>
<td><code>string</code></td>
<td><code>"latest"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_k3s_worker_pool_size"></a> <a href="#input_k3s_worker_pool_size">k3s_worker_pool_size</a></td>
<td>Number of k3s workers deployed</td>
<td><code>number</code></td>
<td><code>2</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_kube_api_port"></a> <a href="#input_kube_api_port">kube_api_port</a></td>
<td>Kube-API default port</td>
<td><code>number</code></td>
<td><code>6443</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_kubeconfig_location"></a> <a href="#input_kubeconfig_location">kubeconfig_location</a></td>
<td>Kubeconfig default location</td>
<td><code>string</code></td>
<td><code>"~/.kube/config"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_kubevela_release"></a> <a href="#input_kubevela_release">kubevela_release</a></td>
<td>Kubevela release</td>
<td><code>string</code></td>
<td><code>"1.7.5"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_load_cluster_kubeconfig"></a> <a href="#input_load_cluster_kubeconfig">load_cluster_kubeconfig</a></td>
<td>Enable to access cluster locally - overwriting var.kubeconfig_location content!!!!</td>
<td><code>bool</code></td>
<td><code>false</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_longhorn_release"></a> <a href="#input_longhorn_release">longhorn_release</a></td>
<td>Longhorn release</td>
<td><code>string</code></td>
<td><code>"v1.4.0"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_my_public_ip_cidr"></a> <a href="#input_my_public_ip_cidr">my_public_ip_cidr</a></td>
<td>Your public ip in CIDR format: (Example: xxx.xxx.xxx.xxx/32)</td>
<td><code>string</code></td>
<td><code>""</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_nginx_ingress_release"></a> <a href="#input_nginx_ingress_release">nginx_ingress_release</a></td>
<td>NGINX ingress release</td>
<td><code>string</code></td>
<td><code>"v1.5.1"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_oci_core_subnet_cidr10"></a> <a href="#input_oci_core_subnet_cidr10">oci_core_subnet_cidr10</a></td>
<td>First subnet CIDR</td>
<td><code>string</code></td>
<td><code>"10.0.0.0/24"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_oci_core_subnet_cidr11"></a> <a href="#input_oci_core_subnet_cidr11">oci_core_subnet_cidr11</a></td>
<td>Second subnet CIDR</td>
<td><code>string</code></td>
<td><code>"10.0.1.0/24"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_oci_core_subnet_dns_label10"></a> <a href="#input_oci_core_subnet_dns_label10">oci_core_subnet_dns_label10</a></td>
<td>First subnet DNS label</td>
<td><code>string</code></td>
<td><code>"defaultsubnet10"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_oci_core_subnet_dns_label11"></a> <a href="#input_oci_core_subnet_dns_label11">oci_core_subnet_dns_label11</a></td>
<td>Second subnet DNS label</td>
<td><code>string</code></td>
<td><code>"defaultsubnet11"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_oci_core_vcn_cidr"></a> <a href="#input_oci_core_vcn_cidr">oci_core_vcn_cidr</a></td>
<td>VCN CIDR</td>
<td><code>string</code></td>
<td><code>"10.0.0.0/16"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_oci_core_vcn_dns_label"></a> <a href="#input_oci_core_vcn_dns_label">oci_core_vcn_dns_label</a></td>
<td>VCN DNS label</td>
<td><code>string</code></td>
<td><code>"defaultvcn"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_oci_identity_dynamic_group_name"></a> <a href="#input_oci_identity_dynamic_group_name">oci_identity_dynamic_group_name</a></td>
<td>Dynamic group name. This dynamic group will contains all the instances of this specific compartment</td>
<td><code>string</code></td>
<td><code>"Compute_Dynamic_Group"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_oci_identity_policy_name"></a> <a href="#input_oci_identity_policy_name">oci_identity_policy_name</a></td>
<td>Policy name. This policy will allow dynamic group 'oci_identity_dynamic_group_name' to read OCI api without auth</td>
<td><code>string</code></td>
<td><code>"Compute_To_Oci_Api_Policy"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_os_image_id"></a> <a href="#input_os_image_id">os_image_id</a></td>
<td>Image id to use</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="even">
<td><a name="input_private_key_path"></a> <a href="#input_private_key_path">private_key_path</a></td>
<td>Path to your private OCI RSA key</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="odd">
<td><a name="input_public_key_path"></a> <a href="#input_public_key_path">public_key_path</a></td>
<td>Path to your public workstation SSH key</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="even">
<td><a name="input_public_lb_shape"></a> <a href="#input_public_lb_shape">public_lb_shape</a></td>
<td>LB shape for the public LB. NOTE is mandatory to use this kind of shape to provision two always free LB (public and private)</td>
<td><code>string</code></td>
<td><code>"flexible"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_public_load_balancer_name"></a> <a href="#input_public_load_balancer_name">public_load_balancer_name</a></td>
<td>Public LB name</td>
<td><code>string</code></td>
<td><code>"K3s public LB"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_region"></a> <a href="#input_region">region</a></td>
<td>OCI region based on your needs</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="odd">
<td><a name="input_tenancy_ocid"></a> <a href="#input_tenancy_ocid">tenancy_ocid</a></td>
<td>n/a</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
<tr class="even">
<td><a name="input_unique_tag_key"></a> <a href="#input_unique_tag_key">unique_tag_key</a></td>
<td>Unique tag name used for tagging all the deployed resources</td>
<td><code>string</code></td>
<td><code>"k3s-provisioner"</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="odd">
<td><a name="input_unique_tag_value"></a> <a href="#input_unique_tag_value">unique_tag_value</a></td>
<td>Unique value used with unique*tag_key</td>
<td><code>string</code></td>
<td><code>""</code></td>
<td style="text-align: center;">no</td>
</tr>
<tr class="even">
<td><a name="input_user_ocid"></a> <a href="#input_user_ocid">user_ocid</a></td>
<td>n/a</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align: center;">yes</td>
</tr>
</tbody>
</table>
<h2 id="outputs">Outputs</h2>
<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><a name="output_argo_instructions"></a> <a href="#output_argo_instructions">argo_instructions</a></td>
<td>n/a</td>
</tr>
<tr class="even">
<td><a name="output_k3s_servers_ips"></a> <a href="#output_k3s_servers_ips">k3s_servers_ips</a></td>
<td>n/a</td>
</tr>
<tr class="odd">
<td><a name="output_k3s_workers_ips"></a> <a href="#output_k3s_workers_ips">k3s_workers_ips</a></td>
<td>n/a</td>
</tr>
<tr class="even">
<td><a name="output_public_lb_ip"></a> <a href="#output_public_lb_ip">public_lb_ip</a></td>
<td>n/a</td>
</tr>
<tr class="odd">
<td><a name="output_ssh_instructions"></a> <a href="#output_ssh_instructions">ssh_instructions</a></td>
<td>n/a</td>
</tr>
</tbody>
</table>
<!-- END_TF_DOCS -->

<h4 id="how-to-find-the-availability-domain-name">How to find the availability domain name</h4>
<p>To find the list of the availability domains run this command on che Cloud Shell:</p>
<pre class="markdown"><code>oci iam availability-domain list
{
  &quot;data&quot;: [
    {
      &quot;compartment-id&quot;: &quot;&lt;compartment_ocid&gt;&quot;,
      &quot;id&quot;: &quot;ocid1.availabilitydomain.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&quot;,
      &quot;name&quot;: &quot;iAdc:EU-ZURICH-1-AD-1&quot;
    }
  ]
}
</code></pre>
<h4 id="how-to-list-all-the-os-images">How to list all the OS images</h4>
<p>To filter the OS images by shape and OS run this command on che Cloud Shell. You can filter by OS: Canonical Ubuntu or Oracle Linux:</p>
<pre class="markdown"><code>oci compute image list --compartment-id &lt;compartment_ocid&gt; --operating-system &quot;Canonical Ubuntu&quot; --shape &quot;VM.Standard.A1.Flex&quot;
{
  &quot;data&quot;: [
    {
      &quot;agent-features&quot;: null,
      &quot;base-image-id&quot;: null,
      &quot;billable-size-in-gbs&quot;: 2,
      &quot;compartment-id&quot;: null,
      &quot;create-image-allowed&quot;: true,
      &quot;defined-tags&quot;: {},
      &quot;display-name&quot;: &quot;Canonical-Ubuntu-20.04-aarch64-2022.01.18-0&quot;,
      &quot;freeform-tags&quot;: {},
      &quot;id&quot;: &quot;ocid1.image.oc1.eu-zurich-1.aaaaaaaag2uyozo7266bmg26j5ixvi42jhaujso2pddpsigtib6vfnqy5f6q&quot;,
      &quot;launch-mode&quot;: &quot;NATIVE&quot;,
      &quot;launch-options&quot;: {
        &quot;boot-volume-type&quot;: &quot;PARAVIRTUALIZED&quot;,
        &quot;firmware&quot;: &quot;UEFI_64&quot;,
        &quot;is-consistent-volume-naming-enabled&quot;: true,
        &quot;is-pv-encryption-in-transit-enabled&quot;: true,
        &quot;network-type&quot;: &quot;PARAVIRTUALIZED&quot;,
        &quot;remote-data-volume-type&quot;: &quot;PARAVIRTUALIZED&quot;
      },
      &quot;lifecycle-state&quot;: &quot;AVAILABLE&quot;,
      &quot;listing-type&quot;: null,
      &quot;operating-system&quot;: &quot;Canonical Ubuntu&quot;,
      &quot;operating-system-version&quot;: &quot;20.04&quot;,
      &quot;size-in-mbs&quot;: 47694,
      &quot;time-created&quot;: &quot;2022-01-27T22:53:34.270000+00:00&quot;
    },
</code></pre>
<h2 id="notes-about-oci-always-free-resources">Notes about OCI always free resources</h2>
<p>In order to get the maximum resources available within the oracle always free tier, the max amount of the k3s servers and k3s workers must be 2. So the <strong>max value</strong> for <code>k3s_server_pool_size</code> and <code>k3s_worker_pool_size</code> is <code>2</code>.</p>
<p>In this setup we use two LB, one internal LB and one public LB (Layer 7). In order to use two LB using the always free resources, one lb must be a <a href="https://docs.oracle.com/en-us/iaas/Content/NetworkLoadBalancer/introducton.htm#Overview">network load balancer</a> an the other must be a <a href="https://docs.oracle.com/en-us/iaas/Content/Balance/Concepts/balanceoverview.htm">load balancer</a>. The public LB <strong>must</strong> use the <code>flexible</code> shape (<code>public_lb_shape</code> variable).</p>
<h2 id="notes-about-k3s">Notes about K3s</h2>
<p>In this environment the High Availability of the K3s cluster is provided using the Embedded DB. More details <a href="https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/">here</a></p>
<p>The default installation of K3s install <a href="https://docs.k3s.io/networking#traefik-ingress-controller">Traefik</a> as ingress the controller. In this environment Traefik is replaced by <a href="https://kubernetes.github.io/ingress-nginx/">Nginx ingress controller</a>. To install Traefik as the ingress controller set the variable <code>ingress_controller</code> to <code>default</code>. For more details on Nginx ingress controller see the <a href="#nginxingress-controller">Nginx ingress controller</a> section.</p>
<h2 id="infrastructure-overview">Infrastructure overview</h2>
<p>The final infrastructure will be made by:</p>
<ul>
<li>two instance pool:
<ul>
<li>one instance pool for the server nodes named <code>k3s-servers</code></li>
<li>one instance pool for the worker nodes named <code>k3s-workers</code></li>
</ul></li>
<li>one internal load balancer that will route traffic to K3s servers</li>
<li>one external load balancer that will route traffic to K3s workers</li>
</ul>
<p>The other resources created by terraform are:</p>
<ul>
<li>two instance configurations (one for the servers and one for the workers) used by the instance pools</li>
<li>one vcn</li>
<li>two public subnets</li>
<li>two security list</li>
<li>one dynamic group</li>
<li>one identity policy</li>
</ul>
<p><img src="https://garutilorenzo.github.io/images/k3s-oci-always-free.drawio.png?" alt="k3s infra" /></p>
<h2 id="cluster-resource-deployed">Cluster resource deployed</h2>
<p>This setup will automatically install <a href="https://longhorn.io/">longhorn</a>. Longhorn is a <em>Cloud native distributed block storage for Kubernetes</em>. To disable the longhorn deployment set <code>install_longhorn</code> variable to <code>false</code>.</p>
<p><strong>NOTE</strong> to use longhorn set the <code>k3s_version</code> &lt; <code>v1.25.x</code> <a href="https://github.com/longhorn/longhorn/issues/4003">Ref.</a></p>
<h3 id="nginx-ingress-controller">Nginx ingress controller</h3>
<p>In this environment <a href="https://kubernetes.github.io/ingress-nginx/">Nginx ingress controller</a> is used instead of the standard <a href="https://docs.k3s.io/networking#traefik-ingress-controller">Traefik</a> ingress controller.</p>
<p>The installation is the <a href="https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters">bare metal</a> installation, the ingress controller then is exposed via a NodePort Service.</p>
<pre class="yaml"><code>---
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx-controller-loadbalancer
  namespace: ingress-nginx
spec:
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 80
      nodePort: ${ingress_controller_http_nodeport} # default to 30080
    - name: https
      port: 443
      protocol: TCP
      targetPort: 443
      nodePort: ${ingress_controller_https_nodeport} # default to 30443
  type: NodePort
</code></pre>
<p>To get the real ip address of the clients using a public L4 load balancer we need to use the proxy protocol feature of nginx ingress controller:</p>
<pre class="yaml"><code>---
apiVersion: v1
data:
  allow-snippet-annotations: &quot;true&quot;
  enable-real-ip: &quot;true&quot;
  proxy-real-ip-cidr: &quot;0.0.0.0/0&quot;
  proxy-body-size: &quot;20m&quot;
  use-proxy-protocol: &quot;true&quot;
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.1.1
    helm.sh/chart: ingress-nginx-4.0.16
  name: ingress-nginx-controller
  namespace: ingress-nginx
</code></pre>
<p><strong>NOTE</strong> to use nginx ingress controller with the proxy protocol enabled, an external nginx instance is used as proxy (since OCI LB doesn't support proxy protocol at the moment). Nginx will be installed on each worker node and the configuation of nginx will:</p>
<ul>
<li>listen in proxy protocol mode</li>
<li>forward the traffic from port <code>80</code> to <code>ingress_controller_http_nodeport</code> (default to <code>30080</code>) on any server of the cluster</li>
<li>forward the traffic from port <code>443</code> to <code>ingress_controller_https_nodeport</code> (default to <code>30443</code>) on any server of the cluster</li>
</ul>
<p>This is the final result:</p>
<p>Client -&gt; Public L4 LB -&gt; nginx proxy (with proxy protocol enabled) -&gt; nginx ingress (with proxy protocol enabled) -&gt; k3s service -&gt; pod(s)</p>
<h3 id="cert-manager">Cert-manager</h3>
<p><a href="https://cert-manager.io/docs/">cert-manager</a> is used to issue certificates from a variety of supported source. To use cert-manager take a look at <a href="deployments/nginx/nginx-ingress-cert-manager.yml">nginx-ingress-cert-manager.yml</a> and <a href="deployments/nginx/nginx-configmap-cert-manager.yml">nginx-configmap-cert-manager.yml</a> example. To use cert-manager and get the certificate you <strong>need</strong> set on your DNS configuration the public ip address of the load balancer.</p>
<h2 id="deploy">Deploy</h2>
<p>We are now ready to deploy our infrastructure. First we ask terraform to plan the execution with:</p>
<pre class="markdown"><code>terraform plan

...
...
      + id                             = (known after apply)
      + ip_addresses                   = (known after apply)
      + is_preserve_source_destination = false
      + is_private                     = true
      + lifecycle_details              = (known after apply)
      + nlb_ip_version                 = (known after apply)
      + state                          = (known after apply)
      + subnet_id                      = (known after apply)
      + system_tags                    = (known after apply)
      + time_created                   = (known after apply)
      + time_updated                   = (known after apply)
      + reserved_ips {
          + id = (known after apply)
        }
    }

Plan: 27 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + k3s_servers_ips = [
      + (known after apply),
      + (known after apply),
    ]
  + k3s_workers_ips = [
      + (known after apply),
      + (known after apply),
    ]
  + public_lb_ip    = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn&#39;t use the -out option to save this plan, so Terraform can&#39;t guarantee to take exactly these actions if you run &quot;terraform apply&quot; now.
</code></pre>
<p>now we can deploy our resources with:</p>
<pre class="markdown"><code>terraform apply

...
...
      + is_preserve_source_destination = false
      + is_private                     = true
      + lifecycle_details              = (known after apply)
      + nlb_ip_version                 = (known after apply)
      + state                          = (known after apply)
      + subnet_id                      = (known after apply)
      + system_tags                    = (known after apply)
      + time_created                   = (known after apply)
      + time_updated                   = (known after apply)
      + reserved_ips {
          + id = (known after apply)
        }
    }

Plan: 27 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + k3s_servers_ips = [
      + (known after apply),
      + (known after apply),
    ]
  + k3s_workers_ips = [
      + (known after apply),
      + (known after apply),
    ]
  + public_lb_ip    = (known after apply)

  Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only &#39;yes&#39; will be accepted to approve.
  Enter a value: yes

...
...

module.k3s_cluster.oci_network_load_balancer_backend.k3s_kube_api_backend[0]: Still creating... [50s elapsed]
module.k3s_cluster.oci_network_load_balancer_backend.k3s_kube_api_backend[0]: Still creating... [1m0s elapsed]
module.k3s_cluster.oci_network_load_balancer_backend.k3s_kube_api_backend[0]: Creation complete after 1m1s [...]

Apply complete! Resources: 27 added, 0 changed, 0 destroyed.

Outputs:

k3s_servers_ips = [
  &quot;X.X.X.X&quot;,
  &quot;X.X.X.X&quot;,
]
k3s_workers_ips = [
  &quot;X.X.X.X&quot;,
  &quot;X.X.X.X&quot;,
]
public_lb_ip = tolist([
  &quot;X.X.X.X&quot;,
])
</code></pre>
<p>Now on one master node you can check the status of the cluster with:</p>
<pre class="markdown"><code>ssh X.X.X.X -lubuntu

ubuntu@inst-iwlqz-k3s-servers:~$ sudo su -
root@inst-iwlqz-k3s-servers:~# kubectl get nodes

NAME                     STATUS   ROLES                       AGE     VERSION
inst-axdzf-k3s-workers   Ready    &lt;none&gt;                      4m34s   v1.22.6+k3s1
inst-hmgnl-k3s-servers   Ready    control-plane,etcd,master   4m14s   v1.22.6+k3s1
inst-iwlqz-k3s-servers   Ready    control-plane,etcd,master   6m4s    v1.22.6+k3s1
inst-lkvem-k3s-workers   Ready    &lt;none&gt;                      5m35s   v1.22.6+k3s1
</code></pre>
<h4 id="public-lb-check">Public LB check</h4>
<p>We can now test the public load balancer, nginx ingress controller and the security list ingress rules. On your local PC run:</p>
<pre class="markdown"><code>curl -v http://&lt;PUBLIC_LB_IP&gt;

*   Trying PUBLIC_LB_IP:80...
* TCP_NODELAY set
* Connected to PUBLIC_LB_IP (PUBLIC_LB_IP) port 80 (#0)
&gt; GET / HTTP/1.1
&gt; Host: PUBLIC_LB_IP
&gt; User-Agent: curl/7.68.0
&gt; Accept: */*
&gt;
* Mark bundle as not supporting multiuse
&lt; HTTP/1.1 404 Not Found
&lt; Date: Fri, 25 Feb 2022 14:03:09 GMT
&lt; Content-Type: text/html
&lt; Content-Length: 146
&lt; Connection: keep-alive
&lt;
&lt;html&gt;
&lt;head&gt;&lt;title&gt;404 Not Found&lt;/title&gt;&lt;/head&gt;
&lt;body&gt;
&lt;center&gt;&lt;h1&gt;404 Not Found&lt;/h1&gt;&lt;/center&gt;
&lt;hr&gt;&lt;center&gt;nginx&lt;/center&gt;
&lt;/body&gt;
&lt;/html&gt;
* Connection #0 to host PUBLIC_LB_IP left intact
</code></pre>
<p><code>404</code> is a correct response since the cluster is empty. We can test also the https listener/backends:</p>
<pre class="markdown"><code>curl -k -v https://&lt;PUBLIC_LB_IP&gt;

* Trying PUBLIC_LB_IP:443...
* TCP_NODELAY set
* Connected to PUBLIC_LB_IP (PUBLIC_LB_IP) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=IT; ST=Italy; L=Brescia; O=GL Ltd; OU=IT; CN=testlb.domainexample.com; emailAddress=email@you.com
*  start date: Feb 25 10:28:29 2022 GMT
*  expire date: Feb 25 10:28:29 2023 GMT
*  issuer: C=IT; ST=Italy; L=Brescia; O=GL Ltd; OU=IT; CN=testlb.domainexample.com; emailAddress=email@you.com
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
&gt; GET / HTTP/1.1
&gt; Host: PUBLIC_LB_IP
&gt; User-Agent: curl/7.68.0
&gt; Accept: */*
&gt;
* Mark bundle as not supporting multiuse
&lt; HTTP/1.1 404 Not Found
&lt; Date: Fri, 25 Feb 2022 13:48:19 GMT
&lt; Content-Type: text/html
&lt; Content-Length: 146
&lt; Connection: keep-alive
&lt;
&lt;html&gt;
&lt;head&gt;&lt;title&gt;404 Not Found&lt;/title&gt;&lt;/head&gt;
&lt;body&gt;
&lt;center&gt;&lt;h1&gt;404 Not Found&lt;/h1&gt;&lt;/center&gt;
&lt;hr&gt;&lt;center&gt;nginx&lt;/center&gt;
&lt;/body&gt;
&lt;/html&gt;
* Connection #0 to host PUBLIC_LB_IP left intact
</code></pre>
<h4 id="longhorn-check">Longhorn check</h4>
<p>To check if longhorn was successfully installed run on one master nodes:</p>
<pre class="markdown"><code>kubectl get ns
NAME              STATUS   AGE
default           Active   9m40s
kube-node-lease   Active   9m39s
kube-public       Active   9m39s
kube-system       Active   9m40s
longhorn-system   Active   8m52s # longhorn namespace

root@inst-hmgnl-k3s-servers:~# kubectl get pods -n longhorn-system
NAME                                        READY   STATUS    RESTARTS        AGE
csi-attacher-5f46994f7-8w9sg                1/1     Running   0               7m52s
csi-attacher-5f46994f7-qz7d4                1/1     Running   0               7m52s
csi-attacher-5f46994f7-rjqlx                1/1     Running   0               7m52s
csi-provisioner-6ccbfbf86f-fw7q4            1/1     Running   0               7m52s
csi-provisioner-6ccbfbf86f-gwmrg            1/1     Running   0               7m52s
csi-provisioner-6ccbfbf86f-nsf84            1/1     Running   0               7m52s
csi-resizer-6dd8bd4c97-7l67f                1/1     Running   0               7m51s
csi-resizer-6dd8bd4c97-g66wj                1/1     Running   0               7m51s
csi-resizer-6dd8bd4c97-nksmd                1/1     Running   0               7m51s
csi-snapshotter-86f65d8bc-2gcwt             1/1     Running   0               7m50s
csi-snapshotter-86f65d8bc-kczrw             1/1     Running   0               7m50s
csi-snapshotter-86f65d8bc-sjmnv             1/1     Running   0               7m50s
engine-image-ei-fa2dfbf0-6rpz2              1/1     Running   0               8m30s
engine-image-ei-fa2dfbf0-7l5k8              1/1     Running   0               8m30s
engine-image-ei-fa2dfbf0-7nph9              1/1     Running   0               8m30s
engine-image-ei-fa2dfbf0-ndkck              1/1     Running   0               8m30s
instance-manager-e-31a0b3f5                 1/1     Running   0               8m26s
instance-manager-e-37aa4663                 1/1     Running   0               8m27s
instance-manager-e-9cc7cc9d                 1/1     Running   0               8m20s
instance-manager-e-f39d9f2c                 1/1     Running   0               8m29s
instance-manager-r-1364d994                 1/1     Running   0               8m26s
instance-manager-r-c1670269                 1/1     Running   0               8m20s
instance-manager-r-c20ebeb3                 1/1     Running   0               8m28s
instance-manager-r-c54bf9a5                 1/1     Running   0               8m27s
longhorn-csi-plugin-2qj94                   2/2     Running   0               7m50s
longhorn-csi-plugin-4t8jm                   2/2     Running   0               7m50s
longhorn-csi-plugin-ws82l                   2/2     Running   0               7m50s
longhorn-csi-plugin-zmc9q                   2/2     Running   0               7m50s
longhorn-driver-deployer-784546d78d-s6cd2   1/1     Running   0               8m58s
longhorn-manager-l8sd8                      1/1     Running   0               9m1s
longhorn-manager-r2q5c                      1/1     Running   1 (8m30s ago)   9m1s
longhorn-manager-s6wql                      1/1     Running   0               9m1s
longhorn-manager-zrrf2                      1/1     Running   0               9m
longhorn-ui-9fdb94f9-6shsr                  1/1     Running   0               8m59s
</code></pre>
<h4 id="argocd-check">Argocd check</h4>
<p>You can verify that all pods are running:</p>
<pre class="markdown"><code>root@inst-hmgnl-k3s-servers:~# kubectl get pods -n argocd

NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          8m51s
argocd-applicationset-controller-7b74965f8c-mjl97   1/1     Running   0          8m53s
argocd-dex-server-7f75d56bc6-j62hb                  1/1     Running   0          8m53s
argocd-notifications-controller-54dd686846-lggrz    1/1     Running   0          8m53s
argocd-redis-5dff748d9c-s5q2l                       1/1     Running   0          8m52s
argocd-repo-server-5576f8d84b-sgbbt                 1/1     Running   0          8m52s
argocd-server-76cf7d4c7b-jq9qx                      1/1     Running   0          8m52s
</code></pre>
<p>To fetch the initial admin password, to be able to do this you need to expose your kubeapi-server (set <em>expose_kubeapi</em> variable to ture) and fetch the kubeconfig from one of the server nodes, it will be in (/var/lib/rancher/k3s/server/cred/admin.kubeconfig):</p>
<pre class="markdown"><code>kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=&quot;{.data.password}&quot; | base64 -d
</code></pre>
<p>To connect to the UI (make sure to copy the kubeconfig to your local machine first):</p>
<pre class="markdown"><code>kubectl -n argocd port-forward service/argocd-server -n argocd 8080:443
</code></pre>
<p>After that you should be able to visit the ArgoCD UI: <a href="https://localhost:8080">https://localhost:8080</a></p>
<h2 id="deploy-a-sample-stack">Deploy a sample stack</h2>
<p>Finally to test all the components of the cluster we can deploy a sample stack. The stack is composed by the following components:</p>
<ul>
<li>MariaDB</li>
<li>Nginx</li>
<li>Wordpress</li>
</ul>
<p>Each component is made by: one deployment and one service. Wordpress and nginx share the same persistent volume (ReadWriteMany with longhorn storage class). The nginx configuration is stored in four ConfigMaps and the nginx service is exposed by the nginx ingress controller.</p>
<p>Deploy the resources with:</p>
<pre class="markdown"><code>kubectl apply -f https://raw.githubusercontent.com/garutilorenzo/k3s-oci-cluster/master/deployments/mariadb/all-resources.yml
kubectl apply -f https://raw.githubusercontent.com/garutilorenzo/k3s-oci-cluster/master/deployments/wordpress/all-resources.yml
</code></pre>
<p><strong>NOTE</strong> The Wordpress installation is <strong>secured</strong>. To allow external traffic to <code>/wp-admin</code>, <code>/xmlrpc.php</code> and <code>wp-login.php</code> you have to edit the <a href="https://github.com/garutilorenzo/k3s-oci-cluster/blob/master/deployments/nginx/all-resources.yml">deployments/nginx/all-resources.yml</a> and change this line:</p>
<pre class="markdown"><code>- name: SECURE_SUBNET
  value: 8.8.8.8/32 # change-me
</code></pre>
<p>with your public ip address CIDR.</p>
<pre class="markdown"><code>curl -o nginx-all-resources.yml https://raw.githubusercontent.com/garutilorenzo/k3s-oci-cluster/master/deployments/nginx/all-resources.yml

vi nginx-all-resources.yml

change SECURE_SUBNET and save the file

kubectl apply -f nginx-all-resources.yml
</code></pre>
<p>now check the status:</p>
<pre class="markdown"><code>kubectl get deployments
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
mariadb       1/1     1            1           92m
nginx         1/1     1            1           79m
wordpress     1/1     1            1           91m

kubectl get svc
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes        ClusterIP   10.43.0.1       &lt;none&gt;        443/TCP    5h8m
mariadb-svc       ClusterIP   10.43.184.188   &lt;none&gt;        3306/TCP   92m
nginx-svc         ClusterIP   10.43.9.202     &lt;none&gt;        80/TCP     80m
wordpress-svc     ClusterIP   10.43.242.26    &lt;none&gt;        9000/TCP   91m
</code></pre>
<p>Now you are ready to setup WP, open the LB public ip and follow the wizard. <strong>NOTE</strong> nginx and the Kubernetes Ingress rule are configured without virthual host/server name.</p>
<p><img src="https://garutilorenzo.github.io/images/k3s-wp.png?" alt="k3s wp install" /></p>
<p>To clean the deployed resources:</p>
<pre class="markdown"><code>kubectl delete -f https://raw.githubusercontent.com/garutilorenzo/k3s-oci-cluster/master/deployments/mariadb/all-resources.yml
kubectl delete -f https://raw.githubusercontent.com/garutilorenzo/k3s-oci-cluster/master/deployments/nginx/all-resources.yml
kubectl delete -f https://raw.githubusercontent.com/garutilorenzo/k3s-oci-cluster/master/deployments/wordpress/all-resources.yml
</code></pre>
<h2 id="connect-to-the-cluster-automatically-locally">Connect to the cluster automatically locally</h2>
<pre><code>load_cluster_kubeconfig = true
</code></pre>
<h2 id="clean-up">Clean up</h2>
<pre class="markdown"><code>terragrunt destroy
</code></pre>
<h2 id="known-bugs">Known Bugs</h2>
<h3 id="409-conflict">409-Conflict</h3>
<p>If you see this error during the infrastructure destruction:</p>
<pre><code>Error: 409-Conflict, Invalid State Transition of NLB lifeCycle state from Updating to Updating
│ Suggestion: The resource is in a conflicted state. Please retry again or contact support for help with service: Network Load Balancer Listener
│ Documentation: https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_listener
│ API Reference: https://docs.oracle.com/iaas/api/#/en/networkloadbalancer/20200501/Listener/DeleteListener
</code></pre>
<p>re-run <code>terraform destroy</code></p>
<h3 id="kubectl-exec-failure">kubectl exec failure</h3>
<p>The runc version in k3s containerd version 1.6.6 contains a regression that prevents anyone from executing a command and attaching to the container's TTY (exec -it) whenever someone runs systemctl daemon-reload. Alternatively, the user may run into this issue on SELinux-enforced systems. <a href="https://github.com/k3s-io/k3s/issues/6064">Ref</a>.</p>
<pre class="markdown"><code>kubectl exec -it -n kube-system cilium-6lqp9 -- cilium status
Defaulted container &quot;cilium-agent&quot; out of: cilium-agent, mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), wait-for-node-init (init), clean-cilium-state (init)
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec &quot;b67e6e00172071996430dac5c97352e4d0c9fa3b3888e8daece5197c4649b4d1&quot;: OCI runtime exec failed: exec failed: unable to start container process: open /dev/pts/0: operation not permitted: unknown
</code></pre>
<p>To solve this issue downgrade to k3s v1.23</p>
</body>
</html>
