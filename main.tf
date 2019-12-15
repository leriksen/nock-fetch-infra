terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "leriksen-npm"

    workspaces {
      prefix = "nock-fetch-"
    }
  }
}

module "global" {
  source = "./const/global"
}

module "environment" {
  source = "./const/environment"
  environment = "${var.TERRAFORM_WORKSPACE}"
}

provider "azurerm" {
  tenant_id       = "${module.global.tenant_id}"
  subscription_id = "${module.environment.subscription}"
  version         = "~> 1.38.0"
}

resource "azurerm_resource_group" "workspace_rg" {
  location = "${module.environment.location}"
  name     = "${module.global.prefix}-${var.TERRAFORM_WORKSPACE}"
  tags     = "${module.global.tags}"
}

resource "azurerm_key_vault" "nock_fetch_kv" {
  name                        = "nockvault-${random_string.kv_suffix.result}"
  location                    = "${azurerm_resource_group.workspace_rg.location}"
  resource_group_name         = "${azurerm_resource_group.workspace_rg.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${module.global.tenant_id}"

  sku_name = "standard"

  tags = "${module.global.tags}"
}

resource "azurerm_key_vault_access_policy" "rw" {
    count = "${length(module.environment.kv_rw)}"
    key_vault_id = "${azurerm_key_vault.nock_fetch_kv.id}"

    tenant_id = "${module.global.tenant_id}"
    object_id = "${element(module.environment.kv_rw, count.index)}"

    key_permissions = []
    secret_permissions = [
        "backup",
        "delete",
        "get",
        "list",
        "purge",
        "recover",
        "restore",
        "set",
    ]
}

resource "azurerm_key_vault_access_policy" "ro" {
    count = "${length(module.environment.kv_ro)}"
    key_vault_id = "${azurerm_key_vault.nock_fetch_kv.id}"

    tenant_id = "${module.global.tenant_id}"
    object_id = "${element(module.environment.kv_ro, count.index)}"

    key_permissions = []
    secret_permissions = [
        "get",
        "list",
    ]
}

resource "random_string" "kv_suffix" {
  length  = "4"
  upper   = false
  special = false
  number  = false
}