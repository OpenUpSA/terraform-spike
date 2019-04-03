# Secrets:

variable "circleci_token" {
  description = "https://circleci.com/account/api"
}

variable "cloudflare_email" {
  description = "Email Address under https://dash.cloudflare.com/profile"
}

variable "cloudflare_token" {
  description = "Global API key under https://dash.cloudflare.com/profile"
}

variable "codecov_token" {
  description = "https://codecov.io/gh/OpenUpSA/khetha-django/settings"
}

variable "digitalocean_token" {
  description = "https://cloud.digitalocean.com/account/api/tokens"
}

variable "docker_password" {
  description = "Docker password for image uploads"
}

variable "netlify_token" {
  description = "https://app.netlify.com/user/applications#personal-access-tokens"
}

# Configuration:

variable "digitalocean_region" {
  description = "Region to deploy in. https://www.digitalocean.com/docs/platform/availability-matrix/"

  # AMS3 seems like the closest and most functional region for South Africa.
  default = "ams3"
}

variable "docker_username" {
  description = "Docker username for image uploads"

  # XXX: Currently hardcoded in docker-compose.yml
  default = "pjdelport"
}
