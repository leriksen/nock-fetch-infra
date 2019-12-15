output "subscriptions" {
    value = "${local.subscriptions}"
}

output "subscription" {
    value = "${local.env_sub_mapping[var.environment]}"
}

output "env_sub_mappings" {
    value = "${local.env_sub_mapping}"
}

output "locations" {
    value = "${local.locations}"
}

output "location" {
    value = "${local.locations[var.environment]}"
}

output "kv_rw" {
  value = "${local.kv_rw[var.environment]}"
}

output "kv_ro" {
  value = "${local.kv_ro[var.environment]}"
}
