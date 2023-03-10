resource "helm_release" "kubevela" {
  count      = var.install_kubevela ? 1 : 0
  name       = "kubevela"
  chart      = "vela-core"
  repository = "https://charts.kubevela.net/core"
  version    = var.kubevela_release

  namespace        = "vela-system"
  create_namespace = true

  depends_on = [
    data.cloudinit_config.k3s_server_tpl
  ]
}

# HIGHLY!! unresponsive.. have a tendency to hang
resource "helm_release" "crossplane" {
  count      = var.install_crossplane ? 1 : 0
  name       = "crossplane-stable"
  chart      = "crossplane"
  repository = "https://charts.crossplane.io/stable"
  version    = var.crossplane_release

  namespace        = "crossplane-system"
  create_namespace = true

  depends_on = [
    data.cloudinit_config.k3s_server_tpl
  ]
}
