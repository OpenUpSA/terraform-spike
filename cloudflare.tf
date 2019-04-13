# https://www.terraform.io/docs/providers/cloudflare/index.html

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Imported with cf-terraforming on 2019-03-28.

resource "cloudflare_zone" "khetha_org_za" {
  zone = "khetha.org.za"
  plan = "free"
}

#resource "cloudflare_record" "A_khetha_org_za" {
#  domain = "${cloudflare_zone.khetha_org_za.zone}"
#  type   = "A"
#  name   = "khetha.org.za"
#
#  # Netlify's load balancer IP address: https://www.netlify.com/docs/custom-domains/
#  value = "104.198.14.52"
#
#  proxied = "true"
#}
#
#resource "cloudflare_record" "CNAME_www_khetha_org_za" {
#  domain = "${cloudflare_zone.khetha_org_za.zone}"
#  type   = "CNAME"
#  name   = "www.khetha.org.za"
#  value  = "khetha.netlify.com"
#
#  proxied = "true"
#}

# Settings:
# https://www.terraform.io/docs/providers/cloudflare/r/zone_settings_override.html

resource "cloudflare_zone_settings_override" "khetha_org_za" {
  name = "${cloudflare_zone.khetha_org_za.zone}"

  settings {
    advanced_ddos            = "on"
    always_online            = "on"
    always_use_https         = "on"
    automatic_https_rewrites = "off"
    brotli                   = "on"
    browser_cache_ttl        = 14400
    browser_check            = "on"
    cache_level              = "aggressive"
    challenge_ttl            = 1800
    cname_flattening         = "flatten_at_root"
    development_mode         = "off"
    edge_cache_ttl           = 7200
    email_obfuscation        = "on"
    hotlink_protection       = "off"
    http2                    = "on"
    ip_geolocation           = "on"
    ipv6                     = "on"
    max_upload               = 100
    min_tls_version          = "1.0"

    minify {
      css  = "off"
      html = "off"
      js   = "off"
    }

    mirage = "off"

    mobile_redirect {
      mobile_subdomain = ""
      status           = "off"
      strip_uri        = false
    }

    opportunistic_encryption    = "on"
    opportunistic_onion         = "on"
    origin_error_page_pass_thru = "off"
    polish                      = "off"
    prefetch_preload            = "off"
    privacy_pass                = "on"
    pseudo_ipv4                 = "off"
    response_buffering          = "off"
    rocket_loader               = "off"

    security_header {
      enabled            = false
      include_subdomains = false
      max_age            = 0
      nosniff            = false
      preload            = false
    }

    security_level              = "medium"
    server_side_exclude         = "on"
    sha1_support                = "off"
    sort_query_string_for_cache = "off"

    # XXX: Switch to flexible, for now.
    ssl = "flexible"

    tls_1_2_only          = "off"
    tls_1_3               = "on"
    tls_client_auth       = "off"
    true_client_ip_header = "off"
    waf                   = "off"
    websockets            = "on"
  }
}

# New resources since the import:

resource "cloudflare_record" "A_staging_khetha_org_za" {
  domain  = "${cloudflare_zone.khetha_org_za.zone}"
  type    = "A"
  name    = "staging.khetha.org.za"
  value   = "${digitalocean_floating_ip.khetha-ip.ip_address}"
  proxied = true
}

# Point production at staging, for now.

resource "cloudflare_record" "A_khetha_org_za" {
  domain  = "${cloudflare_zone.khetha_org_za.zone}"
  type    = "A"
  name    = "khetha.org.za"
  value   = "${digitalocean_floating_ip.khetha-ip.ip_address}"
  proxied = true
}

resource "cloudflare_record" "A_www_khetha_org_za" {
  domain  = "${cloudflare_zone.khetha_org_za.zone}"
  type    = "A"
  name    = "www.khetha.org.za"
  value   = "${digitalocean_floating_ip.khetha-ip.ip_address}"
  proxied = true
}
