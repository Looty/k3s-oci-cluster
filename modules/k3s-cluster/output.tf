output "k3s_servers_ips" {
  depends_on = [
    data.oci_core_instance_pool_instances.k3s_servers_instances,
  ]
  value = data.oci_core_instance.k3s_servers_instances_ips.*.public_ip
}

output "k3s_workers_ips" {
  depends_on = [
    data.oci_core_instance_pool_instances.k3s_workers_instances,
  ]
  value = data.oci_core_instance.k3s_workers_instances_ips.*.public_ip
}

output "public_lb_ip" {
  value = oci_network_load_balancer_network_load_balancer.k3s_public_lb.ip_addresses
}

output "ssh_instructions" {
  value = <<-EOT
    To connect to a master node, run:
    ssh -i ${replace(var.public_key_path, ".pub", "")} ubuntu@${data.oci_core_instance.k3s_servers_instances_ips[0].public_ip}
EOT
}

output "argo_instructions" {
  value = (var.expose_argocd_nodeport ? <<-EOT
    ArgoCD dashboard can be found at: ${data.oci_core_instance.k3s_servers_instances_ips[0].public_ip}:31000
    Password = (kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
EOT
  : "")
}
