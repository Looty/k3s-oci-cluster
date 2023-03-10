resource "oci_core_default_security_list" "default_security_list" {
  compartment_id             = var.compartment_ocid
  manage_default_resource_id = oci_core_vcn.default_oci_core_vcn.default_security_list_id

  display_name = "Default security list"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = 1 # icmp
    source   = local.my_public_ip

    description = "Allow icmp from ${local.my_public_ip}"
  }

  dynamic "ingress_security_rules" {
    iterator = port
    for_each = (var.expose_argocd_nodeport ?
      [for v in var.default_security_list_tcp_with_argo : { minport = v.minport, maxport = v.maxport, name = v.name }] :
      [for v in var.default_security_list_tcp : { minport = v.minport, maxport = v.maxport, name = v.name }]
    )
    content {
      protocol    = 6 # tcp
      source      = local.my_public_ip
      description = "Allow ${port.value.name} from ${local.my_public_ip}"
      tcp_options {
        // These values correspond to the destination port range.
        min = port.value.minport
        max = port.value.maxport
      }
    }
  }

  ingress_security_rules {
    protocol = "all"
    source   = var.oci_core_vcn_cidr

    description = "Allow all from vcn subnet"
  }

  freeform_tags = {
    "provisioner"           = "terraform"
    "environment"           = "${var.environment}"
    "${var.unique_tag_key}" = "${var.unique_tag_value}"
  }
}
