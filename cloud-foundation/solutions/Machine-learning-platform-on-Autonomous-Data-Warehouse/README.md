# Oracle Cloud Foundation Terraform Solution - Machine learning platform on Autonomous Data Warehouse


## Table of Contents
1. [Overview](#overview)
1. [Deliverables](#deliverables)
1. [Architecture](#Architecture-Diagram)
1. [Executing Instructions](#instructions)
    1. [Deploy Using Oracle Resource Manager](#Deploy-Using-Oracle-Resource-Manager)
    1. [Deploy Using the Terraform CLI](#Deploy-Using-the-Terraform-CLI)
1. [Documentation](#documentation)
1. [The Team](#team)
1. [Feedback](#feedback)
1. [Known Issues](#known-issues)
1. [Contribute](#CONTRIBUTING.md)


## <a name="overview"></a>Overview
To keep pace with rapidly changing information needs, organizations are looking for every opportunity to quickly train, deploy, and manage machine learning (ML) models.

With Oracle Autonomous Data Warehouse (ADW) you have all the necessary built-in tools to load data and prepare data, and to train, deploy, and manage machine learning models. These services are included with Autonomous Data Warehouse, but you also have the flexibility to mix and match other tools to best fit your organization’s needs.

For details of the architecture, see [_Machine learning platform on Autonomous Data Warehouse_](https://docs.oracle.com/en/solutions/ml-platform-on-adw/index.html).

## <a name="deliverables"></a>Deliverables
 This repository encloses one deliverable:

- A reference implementation written in Terraform HCL (Hashicorp Language) that provisions fully functional resources in an OCI tenancy.

## <a name="architecture"></a>Architecture-Diagram
The diagram below shows services that are deployed:

![](https://docs.oracle.com/en/solutions/ml-platform-on-adw/img/ml-adw-architecture.png)


## <a name="instructions"></a>Executing Instructions

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `nat-gateways`, `route-tables`, `subnets`, `service-gateways`, `security-lists`, `data catalog`, `object storage`, `autonomous database`, `Analytics Cloud`, and `data integration`.
- Quota to create the following resources: 1 ADW database instance and 1 Oracle Analytics Cloud (OAC) instance, 1 Data Catalog, 1 Data Integration Service, 1 object storage, and 1 data catalog.
If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

# <a name="Deploy-Using-Oracle-Resource-Manager"></a>Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-oracle-cloud-foundation/releases/download/v1.0.0/Machine-learning-platform-on-Autonomous-Data-Warehouse-RM.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.
3. Select the region where you want to deploy the stack.
4. Follow the on-screen prompts and instructions to create the stack.
5. After creating the stack, click **Terraform Actions**, and select **Plan**.
6. Wait for the job to be completed, and review the plan.
    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.
7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 


# <a name="Deploy-Using-the-Terraform-CLI"></a>Deploy Using the Terraform CLI

## Clone the Module
Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/oracle-devrel/terraform-oci-oracle-cloud-foundation.git
    cd terraform-oci-oracle-cloud-foundation/cloud-foundation/solutions/Machine-learning-platform-on-Autonomous-Data-Warehouse
    ls

## Deployment

- Follow the instructions from Prerequisites links in order to install terraform.
- Download the terraform version suitable for your operating system.
- Unzip the archive.
- Add the executable to the PATH.
- You will have to generate an API signing key (public/private keys) and the public key should be uploaded in the OCI console, for the iam user that will be used to create the resources. Also, you should make sure that this user has enough permissions to create resources in OCI. In order to generate the API Signing key, follow the steps from: https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/apisigningkey.htm#How
  The API signing key will generate a fingerprint in the OCI console, and that fingerprint will be used in a terraform file described below.
- You will also need to generate an OpenSSH public key pair. Please store those keys in a place accessible like your user home .ssh directory.

## Prerequisites

- Install Terraform v0.13 or greater: https://www.terraform.io/downloads.html
- Install Python 3.6: https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-local-programming-environment-on-centos-7
- Generate an OCI API Key
- Create your config under \$home*directory/.oci/config (run \_oci setup config* and follow the steps)
- Gather Tenancy related variables (tenancy_id, user_id, local path to the oci_api_key private key, fingerprint of the oci_api_key_public key, and region)

### Installing Terraform

Go to [terraform.io](https://www.terraform.io/downloads.html) and download the proper package for your operating system and architecture. Terraform is distributed as a single binary.
Install Terraform by unzipping it and moving it to a directory included in your system's PATH. You will need the latest version available.

### Prepare Terraform Provider Values

**variables.tf** is located in the root directory. This file is used in order to be able to make API calls in OCI, hence it will be needed by all terraform automations.

In order to populate the **variables.tf** file, you will need the following:

- Tenancy OCID
- User OCID
- Local Path to your private oci api key
- Fingerprint of your public oci api key
- Region

#### **Getting the Tenancy and User OCIDs**

You will have to login to the [console](https://console.us-ashburn-1.oraclecloud.com) using your credentials (tenancy name, user name and password). If you do not know those, you will have to contact a tenancy administrator.

In order to obtain the tenancy ocid, after logging in, from the menu, select Administration -> Tenancy Details. The tenancy OCID, will be found under Tenancy information and it will be similar to **ocid1.tenancy.oc1..aaa…**

In order to get the user ocid, after logging in, from the menu, select Identity -> Users. Find your user and click on it (you will need to have this page open for uploading the oci_api_public_key). From this page, you can get the user OCID which will be similar to **ocid1.user.oc1..aaaa…**

#### **Creating the OCI API Key Pair and Upload it to your user page**

Create an oci_api_key pair in order to authenticate to oci as specified in the [documentation](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#How):

Create the .oci directory in the home of the current user

`$ mkdir ~/.oci`

Generate the oci api private key

`$ openssl genrsa -out ~/.oci/oci_api_key.pem 2048`

Make sure only the current user can access this key

`$ chmod go-rwx ~/.oci/oci_api_key.pem`

Generate the oci api public key from the private key

`$ openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem`

You will have to upload the public key to the oci console for your user (go to your user page -> API Keys -> Add Public Key and paste the contents in there) in order to be able to do make API calls.

After uploading the public key, you can see its fingerprint into the console. You will need that fingerprint for your variables.tf file.
You can also get the fingerprint from running the following command on your local workstation by using your newly generated oci api private key.

`$ openssl rsa -pubout -outform DER -in ~/.oci/oci_api_key.pem | openssl md5 -c`

#### **Generating an SSH Key Pair on UNIX or UNIX-Like Systems Using ssh-keygen**

- Run the ssh-keygen command.

`ssh-keygen -b 2048 -t rsa`

- The command prompts you to enter the path to the file in which you want to save the key. A default path and file name are suggested in parentheses. For example: /home/user_name/.ssh/id_rsa. To accept the default path and file name, press Enter. Otherwise, enter the required path and file name, and then press Enter.
- The command prompts you for a passphrase. Enter a passphrase, or press ENTER if you don't want to havea passphrase.
  Note that the passphrase isn't displayed when you type it in. Remember the passphrase. If you forget the passphrase, you can't recover it. When prompted, enter the passphrase again to confirm it.
- The command generates an SSH key pair consisting of a public key and a private key, and saves them in the specified path. The file name of the public key is created automatically by appending .pub to the name of the private key file. For example, if the file name of the SSH private key is id_rsa, then the file name of the public key would be id_rsa.pub.
  Make a note of the path where you've saved the SSH key pair.
  When you create instances, you must provide the SSH public key. When you log in to an instance, you must specify the corresponding SSH private key and enter the passphrase when prompted.

#### **Getting the Region**

Even though, you may know your region name, you will needs its identifier for the variables.tf file (for example, US East Ashburn has us-ashburn-1 as its identifier).
In order to obtain your region identifier, you will need to Navigate in the OCI Console to Administration -> Region Management
Select the region you are interested in, and save the region identifier.

#### **Prepare the variables.tf file**

You will have to modify the **variables.tf** file to reflect the values that you’ve captured.

```
variable "tenancy_ocid" {
  type = string
  default = "" (tenancy ocid, obtained from OCI console - Profile -> Tenancy)
}

variable "region" {
    type = string
    default = "" (the region used for deploying the infrastructure - ex: eu-frankfurt-1)
}

variable "compartment_id" {
  type = string
  default = "" (the compartment used for deploying the solution - ex: compartment1)
}

variable "user_ocid" {
    type = string
    default = "" (user ocid, obtained from OCI console - Profile -> User Settings)
}

variable "fingerprint" {
    type = string
    default = "" (fingerprint obtained after setting up the API public key in OCI console - Profile -> User Settings -> API Keys -> Add Public Key)
}

variable "private_key_path" {
    type = string
    default = ""  (the path of your local oci api key - ex: /root/.ssh/oci_api_key.pem)
}
```

## Repository files

* **modules(folder)** - ( this folder will be pressent only for the Resource Manager zipped files) Contains folders with subsystems and modules for each section of the project: networking, autonomous database, analytics cloud, etc.
* **CONTRIBUTING.md** - Contributing guidelines, also called Contribution guidelines, the CONTRIBUTING.md file, or software contribution guidelines, is a text file which project managers include in free and open-source software packages or other open media packages for the purpose of describing how others may contribute user-generated content to the project.The file explains how anyone can engage in activities such as formatting code for submission or submitting patches
* **LICENSE** - The Universal Permissive License (UPL), Version 1.0 
* **local.tf** - Local values can be helpful to avoid repeating the same values or expressions multiple times in a configuration, but if overused they can also make a configuration hard to read by future maintainers by hiding the actual values used.Here is the place where all the resources are defined.
* **main.tf** - Main Terraform script used for instantiating the Oracle Cloud Infrastructure provider and all subsystems modules
* **outputs.tf** - Defines project's outputs that you will see after the code runs successfuly
* **provider.tf** - The terraform provider that will be used (OCI)
* **README.md** - This file
* **schema.yaml** - Schema documents are recommended for Terraform configurations when using Resource Manager. Including a schema document allows you to extend pages in the Oracle Cloud Infrastructure Console. Facilitate variable entry in the Create Stack page by surfacing SSH key controls and by naming, grouping, dynamically prepopulating values, and more. Define text in the Application Information tab of the stack detail page displayed for a created stack.
* **tags.tf** - A file that will add tags for all the resouces as ArchitectureCenterTagNamespace convention.
* **variables.tf** - Project's global variables


Secondly, populate the `terraform.tf` file with the disared configuration following the information:


# Autonomous Data Warehouse

The ADW subsystem / module is able to create ADW/ATP databases.

* Parameters:
    * __db_name__ - The database name. The name must begin with an alphabetic character and can contain a maximum of 14 alphanumeric characters. Special characters are not permitted. The database name must be unique in the tenancy.
    * __db_password__ - The password must be between 12 and 30 characters long, and must contain at least 1 uppercase, 1 lowercase, and 1 numeric character. It cannot contain the double quote symbol (") or the username "admin", regardless of casing. The password is mandatory if source value is "BACKUP_FROM_ID", "BACKUP_FROM_TIMESTAMP", "DATABASE" or "NONE".
    * __db_compute_model__ - The compute model of the Autonomous Database. This is required if using the computeCount parameter. If using cpuCoreCount then it is an error to specify computeModel to a non-null value.
    * __db_compute_count__ - The compute amount available to the database. Minimum and maximum values depend on the compute model and whether the database is on Shared or Dedicated infrastructure. For an Autonomous Database on Shared infrastructure, the 'ECPU' compute model requires values in multiples of two. Required when using the computeModel parameter. When using cpuCoreCount parameter, it is an error to specify computeCount to a non-null value.
    * __db_size_in_tbs__ - The size, in gigabytes, of the data volume that will be created and attached to the database. This storage can later be scaled up if needed. The maximum storage value is determined by the infrastructure shape. See Characteristics of Infrastructure Shapes for shape details.
    * __db_workload__ - The Autonomous Database workload type. The following values are valid:
        - OLTP - indicates an Autonomous Transaction Processing database
        - DW - indicates an Autonomous Data Warehouse database
        - AJD - indicates an Autonomous JSON Database
        - APEX - indicates an Autonomous Database with the Oracle APEX Application Development workload type. *Note: db_workload can only be updated from AJD to OLTP or from a free OLTP to AJD.
    * __db_version__ - A valid Oracle Database version for Autonomous Database.db_workload AJD and APEX are only supported for db_version 19c and above.
    * __db_enable_auto_scaling__ - Indicates if auto scaling is enabled for the Autonomous Database OCPU core count. The default value is FALSE.
    * __db_is_free_tier__ - Indicates if this is an Always Free resource. The default value is false. Note that Always Free Autonomous Databases have 1 CPU and 20GB of memory. For Always Free databases, memory and CPU cannot be scaled. When db_workload is AJD or APEX it cannot be true.
    * __db_license_model__ - The Oracle license model that applies to the Oracle Autonomous Database. Bring your own license (BYOL) allows you to apply your current on-premises Oracle software licenses to equivalent, highly automated Oracle PaaS and IaaS services in the cloud. License Included allows you to subscribe to new Oracle Database software licenses and the Database service. Note that when provisioning an Autonomous Database on dedicated Exadata infrastructure, this attribute must be null because the attribute is already set at the Autonomous Exadata Infrastructure level. When using shared Exadata infrastructure, if a value is not specified, the system will supply the value of BRING_YOUR_OWN_LICENSE. It is a required field when db_workload is AJD and needs to be set to LICENSE_INCLUDED as AJD does not support default license_model value BRING_YOUR_OWN_LICENSE.
    * __db_data_safe_status__ - (Updatable) Status of the Data Safe registration for this Autonomous Database. Could be REGISTERED or NOT_REGISTERED.
    * __db_operations_insights_status__ - (Updatable) Status of Operations Insights for this Autonomous Database. Values supported are ENABLED and NOT_ENABLED
    * __db_database_management_status__ - Status of Database Management for this Autonomous Database. Values supported are ENABLED and NOT_ENABLED

Below is an example:

```

variable "db_name" {
  type    = string
  default = "ADWIPML"
}

variable "db_password" {
  type = string
  default = "<enter-password-here>"
}

variable "db_compute_model" {
  type    = string
  default = "ECPU"
}

variable "db_compute_count" {
  type = number
  default = 4
}

variable "db_size_in_tbs" {
  type = number
  default = 1
}

variable "db_workload" {
  type = string
  default = "DW"
}

variable "db_version" {
  type = string
  default = "19c"
}

variable "db_enable_auto_scaling" {
  type = bool
  default = true
}

variable "db_is_free_tier" {
  type = bool
  default = false
}

variable "db_license_model" {
  type = string
  default = "LICENSE_INCLUDED"
}

variable "db_data_safe_status" {
  type = string
  default = "NOT_REGISTERED"
  # default = "REGISTERED"
}

variable "db_operations_insights_status" {
  type = string
  default = "NOT_ENABLED"
  # default = "ENABLED"
}

variable "db_database_management_status" {
  type = string
  default = "NOT_ENABLED"
  # default = "ENABLED"
}
```

# Oracle Analytics Cloud
This resource provides the Analytics Instance resource in Oracle Cloud Infrastructure Analytics service.
Create a new AnalyticsInstance in the specified compartment. The operation is long-running and creates a new WorkRequest.

* Parameters
    * __analytics_instance_feature_set__ - Analytics feature set: ENTERPRISE_ANALYTICS or SELF_SERVICE_ANALYTICS set
    * __analytics_instance_license_type__ - The license used for the service: LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE
    * __analytics_instance_hostname__ - The name of the Analytics instance. This name must be unique in the tenancy and cannot be changed.
    * __analytics_instance_idcs_access_token__ - IDCS access token identifying a stripe and service administrator user. THe IDCS access token can be obtained from OCI console - Menu -> Identity & Security -> Federation -> OracleIdentityCloudService -  and now click on the Oracle Identity Cloud Service Console)
    Access Oracle Identity Cloud Service console, click the avatar icon on the top-right corner, and then click My Access Tokens. 
    You can download an access token in the following ways:
    Select Invokes Identity Cloud Service APIs to specify the available administrator roles that are assigned to you. The APIs from the specified administrator roles will be included in the token.
    Select Invokes other APIs to select confidential applications that are assigned to the user account.
    Click Select an Application to add a configured confidential resource application. On the Select an Application window, the list of assigned confidential applications displays.
    Click applications to select them, and then click Add. The My Access Tokens page lists the added applications.
    In the Token Expires in (Mins) field, select or enter how long (in minutes) the access token you're generating can be used before it expires. You can choose to keep the default number or specify between 1 and 527,040.
    Click Download Token. The access token is generated and downloaded to your local machine as a tokens.tok file.
    * __analytics_instance_capacity_capacity_type__ - The capacity model to use. Accepted values are: OLPU_COUNT, USER_COUNT . Values are case-insensitive.
    * __analytics_instance_capacity_value__ - The capacity value selected (OLPU count, number of users, …etc…). This parameter affects the number of CPUs, amount of memory or other resources allocated to the instance.
    * __analytics_instance_network_endpoint_details_network_endpoint_type__ - The type of network endpoint public or private
    * __whitelisted_ips__ and __analytics_instance_network_endpoint_details_whitelisted_ips__ - If the network_endpoint_type is public you need to put the Source IP addresses or IP address ranges igress rules.


Below is an example:
```
variable "analytics_instance_feature_set" {
    type    = string
    default = "ENTERPRISE_ANALYTICS"
}

variable "analytics_instance_license_type" {
    type    = string
    default = "LICENSE_INCLUDED"
}

variable "analytics_instance_hostname" {
    type    = string
    default = "AnalyicSD"
}

variable "analytics_instance_idcs_access_token" {
    type    = string
    default = "copy-paste your token instead"
}

variable "analytics_instance_capacity_capacity_type" {
    type    = string
    default = "OLPU_COUNT"
}

variable "analytics_instance_capacity_value" {
    type    = number
    default = 1
}

variable "analytics_instance_network_endpoint_details_network_endpoint_type" {
    type    = string
    default = "public"
}

variable "whitelisted_ips" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "analytics_instance_network_endpoint_details_whitelisted_ips" {
  type = list(string)
  default = ["0.0.0.0/0"]
} 
```

# Object Storage
This resource provides the Bucket resource in Oracle Cloud Infrastructure Object Storage service.
Creates a bucket in the given namespace with a bucket name and optional user-defined metadata. Avoid entering confidential information in bucket names.

* Parameters:
    * __bucket_name__ - The name of the bucket. Valid characters are uppercase or lowercase letters, numbers, hyphens, underscores, and periods. Bucket names must be unique within an Object Storage namespace. Avoid entering confidential information. example: Example: my-new-bucket1
    * __bucket_access_type__ - The type of public access enabled on this bucket. A bucket is set to NoPublicAccess by default, which only allows an authenticated caller to access the bucket and its contents. When ObjectRead is enabled on the bucket, public access is allowed for the GetObject, HeadObject, and ListObjects operations. When ObjectReadWithoutList is enabled on the bucket, public access is allowed for the GetObject and HeadObject operations.
    * __bucket_storage_tier__ - The type of storage tier of this bucket. A bucket is set to 'Standard' tier by default, which means the bucket will be put in the standard storage tier. When 'Archive' tier type is set explicitly, the bucket is put in the Archive Storage tier. The 'storageTier' property is immutable after bucket is created.
    * __bucket_events_enabled__ - Whether or not events are emitted for object state changes in this bucket. By default, objectEventsEnabled is set to false. Set objectEventsEnabled to true to emit events for object state changes. For more information about events, see Overview of Events.
     

Below is an example:
```
variable "bucket_name" {
    type    = string
    default = "BucketOnee"
}

variable "bucket_access_type" {
    type    = string
    default  = "NoPublicAccess"
}

variable "bucket_storage_tier" {
    type    = string
    default = "Standard"
}
  
variable "bucket_events_enabled" {
    type    = bool
    default = false
}
```

# Data Catalog
This resource provides the Catalog resource in Oracle Cloud Infrastructure Data Catalog service.
Creates a new data catalog instance that includes a console and an API URL for managing metadata operations. For more information, please see the documentation.

* Parameters:
    * __datacatalog_display_name__ - Data catalog identifier. 


Below is an example:
```
variable "datacatalog_display_name" {
    type    = string
    default = "DataCatalogIP"
}
```

# Oracle Cloud Infrastructure Data Integration service
This resource provides the Workspace resource in Oracle Cloud Infrastructure Data Integration service.
Creates a new Data Integration workspace ready for performing data integration tasks.

* Parameters:
    * __odi_display_name__ - A user-friendly display name for the workspace. Does not have to be unique, and can be modified. Avoid entering confidential information.
    * __odi_description__ - A user defined description for the workspace.


Below is an example:
```
variable "odi_display_name" {
    type    = string
    default = "odi_workspace"
}

variable "odi_description" {
    type    = string
    default  = "odi_workspace"
}
```

# Network
This resource provides the Vcn resource in Oracle Cloud Infrastructure Core service anso This resource provides the Subnet resource in Oracle Cloud Infrastructure Core service.
The solution will create 1 VCN in your compartment, 2 subnets ( one public and one private so the analytics cloud instance can be public or private ), 2 route tables for incomming and outoing traffic, 2 Network Security Groups for ingress and egress traffic, 1 internet gateway, 2 route tables for each subnet, dhcp service, NAT Gateway and a Service Gateway.

* Parameters
    * __service_name__ - The names of all compute and network resources will begin with this prefix. It can only contain letters or numbers and must begin with a letter.
    * __vcn_cidr__ - The list of one or more IPv4 CIDR blocks for the VCN that meet the following criteria:
        The CIDR blocks must be valid.  
        They must not overlap with each other or with the on-premises network CIDR block.
        The number of CIDR blocks must not exceed the limit of CIDR blocks allowed per VCN. It is an error to set both cidrBlock and cidrBlocks. Note: cidr_blocks update must be restricted to one operation at a time (either add/remove or modify one single cidr_block) or the operation will be declined.
    * __vcn_name__ - A user-friendly name. Does not have to be unique, and it's changeable. Avoid entering confidential information.
    * __public_subnet_cidr__ - The CIDR IP address range of the subnet. The CIDR must maintain the following rules - a. The CIDR block is valid and correctly formatted. b. The new range is within one of the parent VCN ranges. This is the cidr for the public subnet.
    * __private_subnet_cidr__ - The CIDR IP address range of the subnet. The CIDR must maintain the following rules - a. The CIDR block is valid and correctly formatted. b. The new range is within one of the parent VCN ranges. This is the cidr for the private subnet.


Below is an example:
```
variable "service_name" {
  type        = string
  default     = "servicename"
  description = "prefix for stack resources"
}

variable "vcn_cidr" {
  default = "172.0.0.0/16"
  description = "CIDR for new virtual cloud network"
}

variable "vcn_name" {
  default     = "vcn"
  description = "Name of new virtual cloud network"
}

variable "public_subnet_cidr" {
  default = "172.0.0.128/27"
  description = "CIDR for bastion subnet"
}

variable "private_subnet_cidr" {
  default = "172.0.0.32/27"
}
```
Don't modify any other variables in the variable.tf file - it may cause that the solution will not work propertly.

## Running the code

```
# Run init to get terraform modules
$ terraform init

# Create the infrastructure
$ terraform apply --auto-approve

# If you are done with this infrastructure, take it down
$ terraform destroy --auto-approve
```


## <a name="documentation"></a>Documentation

[Autonomous Databases Overview](https://docs.oracle.com/en-us/iaas/Content/Database/Concepts/adboverview.htm)

[Analytics Cloud Overview](https://docs.oracle.com/en-us/iaas/analytics-cloud/index.html)

[Object Storage Overview](https://docs.oracle.com/en-us/iaas/Content/Object/Concepts/objectstorageoverview.htm)

[Data Catalog Overview](https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/data-catalog/using/overview.htm)

[Data Integration Overview](https://docs.oracle.com/en-us/iaas/data-integration/using/overview.htm)

[Network Overview](https://docs.cloud.oracle.com/iaas/Content/Network/Concepts/overview.htm)

[Tagging Overview](https://docs.oracle.com/en-us/iaas/Content/Tagging/Concepts/taggingoverview.htm)

[Terraform Autonomous Databases Resource](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_autonomous_database)

[Terraform Analytics Cloud Resource](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/analytics_analytics_instance)

[Terraform Object Storage Service Resource](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket)

[Terraform Data Catalog Service Resource](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/datacatalog_catalog)

[Terraform Data Integration Service Resource](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/dataintegration_workspace)

[Terraform Vcn resource in Oracle Cloud Infrastructure Core service](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn)

[Terraform Subnet resource in Oracle Cloud Infrastructure Core service](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet)

[Terraform Tag Service Resource](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_namespace)


## <a name="team"></a>The Team
- **Owners**: [Panaitescu Ionel](https://github.com/ionelpanaitescu)

## <a name="feedback"></a>Feedback
We welcome your feedback. To post feedback, submit feature ideas or report bugs, please use the Issues section on this repository.	

## <a name="known-issues"></a>Known Issues
**At the moment, there are no known issues**