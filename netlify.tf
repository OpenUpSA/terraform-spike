# https://www.terraform.io/docs/providers/netlify/index.html
# https://github.com/terraform-providers/terraform-provider-netlify
#
# To get existing Netlify site IDs for import, use the Netlify CLI: netlify sites:list

provider "netlify" {
  token = "${var.netlify_token}"
}

# Imported using: terraform import netlify_site.affidavit-evictions-org 4c617890-48dd-422d-bbdb-d1361ee3e96d
resource "netlify_site" "affidavit-evictions-org" {
  name = "affidavit-evictions-org"

  # Domain record configured manually at: https://www.domains.co.za/index.php?m=proddomains&area=domains&manage=130503&action=dnsRecords
  #
  # CNAME affidavit -> affidavit-evictions-org.netlify.com
  #
  custom_domain = "affidavit.evictions.org.za"

  repo {
    provider    = "github"
    repo_path   = "OpenUpSA/eviction-resources"
    repo_branch = "master"
    command     = "gatsby build"
    dir         = "public/"
  }
}
