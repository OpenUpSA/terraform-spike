# https://github.com/mrolla/terraform-provider-circleci

provider "circleci" {
  api_token    = "${var.circleci_token}"
  organization = "OpenUpSA"
  vcs_type     = "github"
}

variable "circleci_project" {
  # https://circleci.com/gh/OpenUpSA/khetha-django
  default = "khetha-django"
}

# https://circleci.com/gh/OpenUpSA/khetha-django/edit#env-vars

# XXX (Pi): Why is this not being picked up automatically?
resource "circleci_environment_variable" "codecov_token" {
  project = "${var.circleci_project}"
  name    = "CODECOV_TOKEN"
  value   = "${var.codecov_token}"
}

resource "circleci_environment_variable" "docker_username" {
  project = "${var.circleci_project}"
  name    = "DOCKER_USERNAME"
  value   = "${var.docker_username}"
}

resource "circleci_environment_variable" "docker_password" {
  project = "${var.circleci_project}"
  name    = "DOCKER_PASSWORD"
  value   = "${var.docker_password}"
}

# See: .circleci/config.yml
resource "circleci_environment_variable" "deploy_host_staging" {
  project = "${var.circleci_project}"
  name    = "DEPLOY_HOST_STAGING"
  value   = "${digitalocean_floating_ip.khetha-ip.ip_address}"
}

# XXX: Deployment keys not supported yet.
# https://circleci.com/gh/OpenUpSA/khetha-django/edit#ssh
# https://circleci.com/docs/2.0/add-ssh-key/
#
# See manually-generated key under secrets, generated with:
# ssh-keygen -t rsa -f secrets/id_rsa -C "Khetha CircleCI deploy key $(date -I)"
#
# See also digitalocean.tf

