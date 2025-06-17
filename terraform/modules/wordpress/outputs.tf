output "wp_password" {
  value     = random_password.wordpress.result
  sensitive = true
}
