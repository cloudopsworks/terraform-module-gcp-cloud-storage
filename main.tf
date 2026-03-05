##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  clean_name  = var.name != "" ? var.name : (var.short_system_name == true ? "${var.name_prefix}-${local.system_name_short}" : "${var.name_prefix}-${local.system_name}")
  bucket_name = var.random_bucket_suffix == false ? local.clean_name : "${local.clean_name}-${random_string.random[0].result}"

  versioning_config = try(var.bucket_config.versioning, false) ? {
    enabled = true
    } : {
    enabled = false
  }

  lifecycle_rules = try(var.bucket_config.lifecycle_rules, [])

  website_config = try(var.bucket_config.website, null) != null ? {
    main_page_suffix = try(var.bucket_config.website.main_page_suffix, null)
    not_found_page   = try(var.bucket_config.website.not_found_page, null)
  } : null

  cors_config = try(var.bucket_config.cors, [])

  encryption_config = try(var.bucket_config.encryption, null) != null ? {
    default_kms_key_id = var.bucket_config.encryption.default_kms_key_name
  } : null

  logging_config = try(var.bucket_config.logging, null) != null ? {
    log_bucket        = var.bucket_config.logging.log_bucket
    log_object_prefix = try(var.bucket_config.logging.log_object_prefix, null)
  } : null

  retention_policy = try(var.bucket_config.retention_policy, null) != null ? {
    is_locked        = try(var.bucket_config.retention_policy.is_locked, false)
    retention_period = var.bucket_config.retention_policy.retention_period
  } : null

  soft_delete_policy = try(var.bucket_config.soft_delete_policy, null) != null ? {
    retention_duration_seconds = try(var.bucket_config.soft_delete_policy.retention_duration_seconds, 604800)
    effective_time             = try(var.bucket_config.soft_delete_policy.effective_time, null)
    } : {
    retention_duration_seconds = 604800
  }

  custom_placement_config = try(var.bucket_config.custom_placement_config, null) != null ? {
    data_locations = var.bucket_config.custom_placement_config.data_locations
  } : null

  hierarchical_namespace = try(var.bucket_config.hierarchical_namespace, null) != null ? {
    enabled = try(var.bucket_config.hierarchical_namespace.enabled, false)
  } : null

  iam_configuration = {
    public_access_prevention    = try(var.bucket_config.iam_configuration.public_access_prevention, try(var.bucket_config.public_access_prevention, "inherited"))
    uniform_bucket_level_access = try(var.bucket_config.iam_configuration.uniform_bucket_level_access, try(var.bucket_config.uniform_bucket_level_access, true))
  }

  location = try(var.bucket_config.location, "US")

  storage_class        = try(var.bucket_config.storage_class, "STANDARD")
  force_destroy        = try(var.bucket_config.force_destroy, false)
  public_policy_blocks = try(var.bucket_config.public_policy_blocks, true)
}

resource "random_string" "random" {
  count   = var.random_bucket_suffix ? 1 : 0
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric = true
}

resource "google_storage_bucket" "this" {
  name          = local.bucket_name
  location      = local.location
  storage_class = local.storage_class
  force_destroy = local.force_destroy

  versioning {
    enabled = local.versioning_config.enabled
  }

  dynamic "lifecycle_rule" {
    for_each = local.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = try(lifecycle_rule.value.action.storage_class, null)
      }
      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)
        created_before             = try(lifecycle_rule.value.condition.created_before, null)
        with_state                 = try(lifecycle_rule.value.condition.is_live, null) ? "LIVE" : (lifecycle_rule.value.condition.is_live == false ? "ARCHIVED" : null)
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)
        custom_time_before         = try(lifecycle_rule.value.condition.custom_time_before, null)
        days_since_custom_time     = try(lifecycle_rule.value.condition.days_since_custom_time, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null)
        noncurrent_time_before     = try(lifecycle_rule.value.condition.noncurrent_time_before, null)
        matches_prefix             = try(lifecycle_rule.value.condition.matches_prefix, null)
        matches_suffix             = try(lifecycle_rule.value.condition.matches_suffix, null)
      }
    }
  }

  dynamic "website" {
    for_each = local.website_config != null ? [local.website_config] : []
    content {
      main_page_suffix = website.value.main_page_suffix
      not_found_page   = website.value.not_found_page
    }
  }

  dynamic "cors" {
    for_each = local.cors_config
    content {
      origin          = try(cors.value.origin, [])
      method          = try(cors.value.method, [])
      response_header = try(cors.value.response_header, [])
      max_age_seconds = try(cors.value.max_age_seconds, null)
    }
  }

  dynamic "encryption" {
    for_each = local.encryption_config != null ? [local.encryption_config] : []
    content {
      default_kms_key_name = encryption.value.default_kms_key_id
    }
  }

  dynamic "logging" {
    for_each = local.logging_config != null ? [local.logging_config] : []
    content {
      log_bucket        = logging.value.log_bucket
      log_object_prefix = logging.value.log_object_prefix
    }
  }

  dynamic "retention_policy" {
    for_each = local.retention_policy != null ? [local.retention_policy] : []
    content {
      is_locked        = retention_policy.value.is_locked
      retention_period = retention_policy.value.retention_period
    }
  }

  dynamic "soft_delete_policy" {
    for_each = [local.soft_delete_policy]
    content {
      retention_duration_seconds = soft_delete_policy.value.retention_duration_seconds
      effective_time             = soft_delete_policy.value.effective_time
    }
  }

  dynamic "custom_placement_config" {
    for_each = local.custom_placement_config != null ? [local.custom_placement_config] : []
    content {
      data_locations = custom_placement_config.value.data_locations
    }
  }

  dynamic "hierarchical_namespace" {
    for_each = local.hierarchical_namespace != null ? [local.hierarchical_namespace] : []
    content {
      enabled = hierarchical_namespace.value.enabled
    }
  }

  labels = merge(try(var.bucket_config.labels, {}), local.all_tags)
}
