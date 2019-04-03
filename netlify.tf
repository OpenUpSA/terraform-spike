# https://www.terraform.io/docs/providers/netlify/index.html
# https://github.com/terraform-providers/terraform-provider-netlify
#
# To get existing Netlify site IDs for import, use the Netlify CLI: netlify sites:list

provider "netlify" {
  token = "${var.netlify_token}"
}
