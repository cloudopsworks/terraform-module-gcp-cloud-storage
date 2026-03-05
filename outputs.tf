##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "bucket_id" {
  description = "The ID of the Cloud Storage bucket"
  value       = google_storage_bucket.this.id
}

output "bucket_name" {
  description = "The name of the Cloud Storage bucket"
  value       = google_storage_bucket.this.name
}

output "bucket_self_link" {
  description = "The URI of the created Cloud Storage bucket"
  value       = google_storage_bucket.this.self_link
}

output "bucket_url" {
  description = "The base URL of the Cloud Storage bucket"
  value       = "gs://${google_storage_bucket.this.name}"
}

output "bucket_location" {
  description = "The location of the Cloud Storage bucket"
  value       = google_storage_bucket.this.location
}

output "bucket_storage_class" {
  description = "The storage class of the Cloud Storage bucket"
  value       = google_storage_bucket.this.storage_class
}

output "bucket_project" {
  description = "The project ID of the Cloud Storage bucket"
  value       = google_storage_bucket.this.project
}

output "bucket_website_endpoint" {
  description = "The website endpoint of the Cloud Storage bucket (if configured)"
  value       = try(google_storage_bucket.this.website[0].main_page_suffix, null) != null ? "http://storage.googleapis.com/${google_storage_bucket.this.name}/${google_storage_bucket.this.website[0].main_page_suffix}" : null
}

output "bucket_versioning_enabled" {
  description = "Whether versioning is enabled on the Cloud Storage bucket"
  value       = try(google_storage_bucket.this.versioning[0].enabled, false)
}
