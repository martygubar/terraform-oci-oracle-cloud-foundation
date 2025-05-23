# # Copyright © 2025, Oracle and/or its affiliates.
# # All rights reserved. Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "null_resource" "sqlcl-create-usr" {

        provisioner "local-exec" {
             command = <<-EOT

                chmod 777 ./scripts/

                echo 'Run hybridRAG-IN-A-BOX_ADMIN_v2.0.sql script with creating new user and privileges'
                sql -cloudconfig wallet_${var.db_name}.zip admin/${var.db_password}@'${local.conn_db}' @./scripts/hybridRAG-IN-A-BOX_ADMIN_v2.0.sql ${var.riab_user} ${var.riab_password}

                echo 'Creating the APEX WORKSPACE and APEX USER running hybridRAG-IN-A-BOX_APEX_ADMIN_v2.0.sql'
                sql -cloudconfig wallet_${var.db_name}.zip admin/${var.db_password}@'${local.conn_db}' @./scripts/hybridRAG-IN-A-BOX_APEX_ADMIN_v2.0.sql ${var.apex_workspace} ${var.riab_user} ${var.apex_user} ${var.apex_password} ${var.apex_password} 

                echo 'Start running hybridRAG-IN-A-BOX_USER_v2.3.sql script'
                sql -cloudconfig wallet_${var.db_name}.zip ${var.riab_user}/${var.riab_password}@'${local.conn_db}' @./scripts/hybridRAG-IN-A-BOX_USER_v2.3.sql

                echo 'Start running hybridRAG-IN-A-BOX_USER_CREDS_v1.1.sql script'
                sql -cloudconfig wallet_${var.db_name}.zip ${var.riab_user}/${var.riab_password}@'${local.conn_db}' @./scripts/hybridRAG-IN-A-BOX_USER_CREDS_v1.1.sql ${var.apex_user} ${var.user_ocid} ${var.tenancy_ocid} "${local.final_bucket_url}" "${var.private_key}" ${var.fingerprint} ${var.compartment_id} ${var.llm_region}

                echo 'Install the APEX APP in a box application running hybridRAG-IN-A-BOX_APEX_USER_v2.0.sql'
                sql -cloudconfig wallet_${var.db_name}.zip ${var.riab_user}/${var.riab_password}@'${local.conn_db}' @./scripts/hybridRAG-IN-A-BOX_APEX_USER_v2.0.sql ${var.apex_workspace} ${var.riab_user} ./scripts/hybridRAG-IN-A-BOX_f101_v1.3.sql

            EOT
        }
depends_on = [module.adb]
}

resource "null_resource" "upload_files_to_object_storage" {

        provisioner "local-exec" {
             command = <<-EOT
              oci os object put -ns ${data.oci_objectstorage_namespace.this.namespace} -bn ${var.bucket_name} --force --file sampledata.txt
            EOT
        }
depends_on = [module.adb, module.os]
}


resource "null_resource" "delete_files_from_object_storage" {
triggers = {
      bucket_name = var.bucket_name
      db_name = var.db_name
  }
provisioner "local-exec" {
    when = destroy
    command = "oci os object delete --bucket-name ${self.triggers.bucket_name} --force --object-name sampledata.txt"
    environment = {
      bucket_name = self.triggers.bucket_name
      db_name = self.triggers.db_name
    }
  }
}


