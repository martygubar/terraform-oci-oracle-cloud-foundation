# Copyright © 2023, Oracle and/or its affiliates.
# All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.

# Autonomous Database Outputs:

output "Adb_db_connection" {
  value = module.adb.db_connection
}

output "Adb_endpoint_ip" {
  value = module.adb.private_endpoint_ip
}

output "Database_Actions" {
  value = module.adb.url
}

output "graph_studio_url" {
  value = module.adb.graph_studio_url
}

output "machine_learning_user_management_url" {
  value = module.adb.machine_learning_user_management_url
}

output "database_fully_qualified_name" {
  value = module.adb.database_fully_qualified_name
}

output "ADW_LOGIN" {
  value = "Please use the ADW URL to login by using the user admin and the password that you have provided."
}

output "Analytics_URL" {
  value = module.oac.Analytics_URL
}

output "DataCatalog" {
  value = module.datacatalog.datacatalog
}

output "api_gateways" {
  value = module.api-gateway.gateways
}

output "api_deployments" {
  value = module.api-gateway.deployments
}

output "api_endpoints" {
  value = module.api-gateway.routes
}

output "Bastion_compute_linux_instances" {
  value = module.bastion.linux_instances
}

output "Bastion_all_private_ips" {
  value = module.bastion.all_private_ips
}

output "ODI_compute_linux_instances" {
  value = module.odi.linux_instances
}

output "ODI_all_private_ips" {
  value = module.odi.all_private_ips
}

output "public_VNC" {
  value = "ODI_INSTANCE_PUBLIC_IP:1"
}

output "private_VNC" {
  value = "ODI_INSTANCE_PRIVATE_IP:1"
}

output "generated_ssh_private_key_for_bastion" {
  value = nonsensitive(module.keygen.OPCPrivateKey["private_key_pem"])
}

resource "local_file" "private_key" {
    content  = module.keygen.OPCPrivateKey["private_key_pem"]
    filename = "private_key.pem"
    file_permission = 0600
}