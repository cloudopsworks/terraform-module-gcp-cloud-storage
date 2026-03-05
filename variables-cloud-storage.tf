##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name" {
  # (Optional) The name of the Cloud Storage bucket.
  # If not provided, a unique name will be generated using name_prefix and system_name.
  # Must be globally unique across all GCS buckets.
  # Constraints: 3-63 characters, lowercase letters, numbers, hyphens, and periods.
  # Cannot begin or end with hyphen or period.
  # Default: "" (empty string, triggers auto-generation)
  description = "The name of the Cloud Storage bucket"
  type        = string
  default     = ""
  nullable    = false
}

variable "name_prefix" {
  # (Required) The prefix to use when generating a unique bucket name.
  # Combined with system_name (or system_name_short if short_system_name is true) and optional random suffix.
  # Example: "myapp-storage" + "dev" + "a1b2c3d4" = "myapp-storage-dev-a1b2c3d4"
  # Constraints: Must follow GCS naming conventions when combined with other parts.
  # Default: "" (empty string)
  description = "Creates a unique bucket name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = ""
  nullable    = false
}

variable "random_bucket_suffix" {
  # (Optional) Whether to append a random 8-character string to the bucket name.
  # When true, appends a random alphanumeric string (e.g., "a1b2c3d4") to ensure global uniqueness.
  # When false, uses only the clean name (name_prefix + system_name).
  # Useful for environments requiring predictable bucket names.
  # Default: true
  description = "Creates a unique bucket name with a random 8 character string appended to the end. Defaults to true, for clean names set to false"
  type        = bool
  default     = true
  nullable    = false
}

variable "short_system_name" {
  # (Optional) Whether to use the short system name local variable instead of the full system name.
  # When true, uses local.system_name_short in the bucket name generation.
  # When false, uses local.system_name (full name).
  # Useful for environments with strict naming length constraints.
  # Default: false
  description = "Force the use of the short system name local variable, defaults to false."
  type        = bool
  default     = false
  nullable    = false
}

## configurations for the GCS bucket - YAML format
##
## bucket_config:
##   # (Optional) The location of the bucket. If not specified, defaults to "US".
##   # Valid values include: US, EU, asia-northeast1, asia-southeast1, europe-west1, us-central1, us-east1, etc.
##   # For multi-region: US, EU, ASIA
##   # For dual-region: US-EAST1, US-WEST1, EUROPE-WEST1, etc.
##   # For single region: any valid GCP region
##   location: "US"
##
##   # (Optional) The storage class of the bucket. Defaults to "STANDARD".
##   # Valid values: STANDARD, NEARLINE, COLDLINE, ARCHIVE
##   # - STANDARD: Frequently accessed data
##   # - NEARLINE: Accessed once a month
##   # - COLDLINE: Accessed once a year
##   # - ARCHIVE: Accessed less than once a year
##   storage_class: "STANDARD"
##
##   # (Optional) Whether to force destroy the bucket when deleting. Defaults to false.
##   # When true, allows deletion of bucket even if it contains objects.
##   force_destroy: false
##
##   # (Optional) Prevents public access to the bucket. Defaults to "inherited".
##   # Valid values: enforced, inherited
##   # - enforced: Blocks all public access to the bucket
##   # - inherited: Inherits public access settings from organization policy
##   public_access_prevention: "inherited"
##
##   # (Optional) Enables uniform bucket-level access. Defaults to true.
##   # When true, disables ACLs and uses only IAM policies for access control.
##   uniform_bucket_level_access: true
##
##   # (Optional) Enables versioning on the bucket. Defaults to false.
##   # When true, keeps old versions of objects when updated or deleted.
##   versioning: false
##
##   # (Optional) Lifecycle rules for managing objects in the bucket. Defaults to [].
##   # Each rule consists of an action and condition.
##   lifecycle_rules: []
##     # Example lifecycle rule:
##     # - action:
##     #     # (Required) The type of action to take.
##     #     # Valid values: Delete, SetStorageClass, AbortIncompleteMultipartUpload
##     #     type: "Delete"
##     #     # (Optional) The storage class to set. Only used when type is SetStorageClass.
##     #     storage_class: "ARCHIVE"
##     #   condition:
##     #     # (Optional) Age of the object in days.
##     #     age: 365
##     #     # (Optional) Date in YYYY-MM-DD format. Objects created before this date match.
##     #     created_before: "2023-01-01"
##     #     # (Optional) Whether to match live objects (true), archived objects (false), or both (null).
##     #     is_live: true
##     #     # (Optional) Number of newer versions to retain.
##     #     num_newer_versions: 3
##     #     # (Optional) Date for custom time-based conditions.
##     #     custom_time_before: "2023-01-01"
##     #     # (Optional) Days since custom time.
##     #     days_since_custom_time: 90
##     #     # (Optional) Days since noncurrent time.
##     #     days_since_noncurrent_time: 365
##     #     # (Optional) Noncurrent time before date.
##     #     noncurrent_time_before: "2023-01-01"
##     #     # (Optional) List of object name prefixes to match.
##     #     matches_prefix: ["logs/", "temp/"]
##     #     # (Optional) List of object name suffixes to match.
##     #     matches_suffix: [".log", ".tmp"]
##
##   # (Optional) Website configuration for static website hosting. Defaults to {}.
##   website: {}
##     # main_page_suffix: "index.html"  # (Optional) Default page for website root
##     # not_found_page: "404.html"      # (Optional) Error page for 404 responses
##
##   # (Optional) CORS configuration for cross-origin resource sharing. Defaults to [].
##   cors: []
##     # Example CORS configuration:
##     # - origin: ["https://example.com", "https://app.example.com"]  # (Optional) Allowed origins
##     #   method: ["GET", "PUT", "POST", "DELETE", "HEAD"]            # (Optional) Allowed HTTP methods
##     #   response_header: ["Content-Type", "Authorization"]          # (Optional) Allowed response headers
##     #   max_age_seconds: 3600                                       # (Optional) Cache duration in seconds
##
##   # (Optional) Encryption configuration using Cloud KMS. Defaults to {}.
##   encryption: {}
##     # default_kms_key_name: "projects/PROJECT_ID/locations/REGION/keyRings/KEY_RING/cryptoKeys/KEY_NAME"  # (Required) KMS key resource ID
##
##   # (Optional) Logging configuration for access logs. Defaults to {}.
##   logging: {}
##     # log_bucket: "my-access-logs-bucket"  # (Required) Bucket to store access logs
##     # log_object_prefix: "access-logs/"    # (Optional) Prefix for log object names
##
##   # (Optional) Retention policy configuration. Defaults to {}.
##   retention_policy: {}
##     # is_locked: false                        # (Optional) If true, policy cannot be removed. Defaults to false.
##     # retention_period: 2592000               # (Required) Retention period in seconds (30 days)
##
##   # (Optional) Soft delete policy configuration. Defaults to {}.
##   soft_delete_policy: {}
##     # retention_duration_seconds: 604800      # (Optional) Duration to retain deleted objects. Defaults to 604800 (7 days).
##     # effective_time: "2024-01-01T00:00:00Z"  # (Optional) RFC3339 timestamp when policy takes effect
##
##   # (Optional) Custom placement configuration for dual-region buckets. Defaults to {}.
##   custom_placement_config: {}
##     # data_locations: ["US-EAST1", "US-WEST1"]  # (Required) List of two regions for dual-region placement
##
##   # (Optional) Hierarchical namespace configuration. Defaults to {}.
##   hierarchical_namespace: {}
##     # enabled: false  # (Optional) Enable hierarchical namespace (HNS). Defaults to false.
##
##   # (Optional) IAM configuration. Can override top-level public_access_prevention and uniform_bucket_level_access. Defaults to {}.
##   iam_configuration: {}
##     # public_access_prevention: "inherited"   # (Optional) Same as top-level. Defaults to "inherited".
##     # uniform_bucket_level_access: true       # (Optional) Same as top-level. Defaults to true.
##
##   # (Optional) Additional labels to apply to the bucket. Defaults to {}.
##   labels: {}
##     # environment: "production"
##     # team: "platform"
##     # cost_center: "engineering"
variable "bucket_config" {
  # (Optional) The configuration object for the Cloud Storage bucket.
  # Accepts a map with various bucket settings. See YAML documentation above for full structure.
  # All fields within bucket_config are optional with sensible defaults.
  # Default: {} (empty map, uses all defaults)
  #
  # Key configuration options:
  # - location: Bucket location (default: "US")
  # - storage_class: Storage class (default: "STANDARD")
  # - force_destroy: Force destruction (default: false)
  # - versioning: Enable versioning (default: false)
  # - lifecycle_rules: Object lifecycle management (default: [])
  # - website: Static website hosting (default: {})
  # - cors: CORS configuration (default: [])
  # - encryption: KMS encryption (default: {})
  # - logging: Access logging (default: {})
  # - retention_policy: Object retention (default: {})
  # - soft_delete_policy: Soft delete (default: {})
  # - custom_placement_config: Dual-region placement (default: {})
  # - hierarchical_namespace: HNS enablement (default: {})
  # - iam_configuration: IAM settings (default: {})
  # - labels: Additional labels (default: {})
  description = "The configuration for the Cloud Storage bucket"
  type        = any
  default     = {}
}
