# https://www.terraform.io/docs/providers/do/index.html

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "pjdelport-personal-2016" {
  name       = "pjdelport@gmail.com-Personal-Z570-2016-12-30"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCywUDd2YrZyZJMrTlSG9DM22GO7a7gRLXMPhpgcYgH9LLbPcqACD+wXcnHqX9gntGMYvbweaGcKelXkXhYk8MjaAsbpwAinBiiJwxOfYufx/OIwZocsA7w3ju4xgB9lHgDMQAtyfkwOPHGKDqRuFg2mQmqiYIWy+hBUTSVvtf52qOv97/LDfRemCZtKDp3wvP9O380V7X9TKnJRAtIHvxQjuiRu4ojkTrCCw4PAI5UioR0epkVJMKi/Hf73ogAeudTpeu2EojARUMTbz7CbhAMRxsIWkL9zcBpYmOQtMlUa+81rJ9tX+xsQPpaPtCezBb1Wrw3+NGkFQfChwcBK9Ub pjdelport@gmail.com-Personal-Z570-2016-12-30"
}

resource "digitalocean_ssh_key" "circleci-deploy" {
  # https://circleci.com/gh/OpenUpSA/khetha-django/edit#ssh
  # See also circleci.tf
  name = "Khetha CircleCI deploy key 2019-03-30"

  public_key = "${file("secrets/id_rsa.pub")}"
}

resource "digitalocean_droplet" "khetha-do-test" {
  # Disable for now.
  count = 0

  image  = "ubuntu-16-04-x64"
  name   = "khetha-do-test"
  region = "${var.digitalocean_region}"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "khetha-do-test-2" {
  # Disable for now.
  count = 0

  image  = "ubuntu-16-04-x64"
  name   = "khetha-do-test-2"
  region = "${var.digitalocean_region}"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_floating_ip" "khetha-ip" {
  region     = "${var.digitalocean_region}"
  ip_address = "178.128.143.69"
  droplet_id = "${digitalocean_droplet.khetha-docker.id}"
}

# K8S cluster:

resource "digitalocean_kubernetes_cluster" "khetha-cluster" {
  # Disable for now.
  count = 0

  name   = "khetha-k8s-${var.digitalocean_region}"
  region = "${var.digitalocean_region}"

  # https://developers.digitalocean.com/documentation/v2/#list-available-regions--node-sizes--and-versions-of-kubernetes
  version = "1.13.5-do.0"

  "node_pool" {
    name = "khetha-k8s-${var.digitalocean_region}-node-pool"

    # https://developers.digitalocean.com/documentation/v2/#list-all-sizes
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}

# Docker swarm host:

resource "digitalocean_droplet" "khetha-docker" {
  image      = "docker-18-04"
  name       = "khetha-docker"
  region     = "${var.digitalocean_region}"
  size       = "s-1vcpu-1gb"
  monitoring = true

  ssh_keys = [
    "${digitalocean_ssh_key.pjdelport-personal-2016.id}",
    "${digitalocean_ssh_key.circleci-deploy.id}",
  ]

  # Manual config:
  # DOCKER_HOST=ssh://root@<public-IP> docker swarm init --advertise-addr <private-IP>

  # Deploy:
  # DOCKER_HOST=ssh://root@<public-IP> docker stack deploy -c docker-compose.yml -c docker-compose.staging.yml khetha-staging
}
