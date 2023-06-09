# tardigrade-terraform-network-mirror

Manages a [`cloudarmor.io`][0] site that can be used as a [`Terraform network mirror`][1] for installing a limited set of Terraform providers
and Terraform-associated tools. The site can be used directly or replicated into a disconnected network to serve as a Terrform
network mirror.

The Terraform providers and current versions are tracked within [`provider_versions.tf`][4]. The available tools and current versions are
tracked either within [`Dockerfile.tools`][2] or [`dependabot_hack.yml`][3]. An automated process utilizing Dependabot, Mergify, and GitHub Actions
will update the versions as they become available and append the new files to the mirror.  A limited number of older versions will be maintained
in the mirror but will be removed after a period of time.  New providers or tools can be added to the project by submitting a PR updating any of
previously mentioned files.  New releases for this project will track the Terraform core version.  As new versions of Terraform are incorporated, a corresponding release of this project will be created.

# How to use project or mirror

The providers mirror created by this project can be used directly, replicated to a disconnected network, or the project itself can be used to create a Terraform network mirror.

## Directly use public mirror

The [`Terraform providers mirror`][5] can be used directly by creating a [`Terraform CLI Configuration file`][6] and using the following
`provider_installation` block:

```
provider_installation {
  network_mirror {
    url = "https://hashicorp-mirror.cloudarmor.io/providers/"
  }
}
```
## Disconnected environments

The mirror can be copied as-is onto a local system. The `provider_installation` block in the Terraform CLI Configuration file needs to be updated
to use `filesystem_mirror` with the path to where the mirror was copied.

Another option is to create an internal static website using the mirror, use the `network_mirror`` option with a url to the static website.

Please see [`Provider Installation`][8] for additional information.

## Create a mirror

To use this project to create a mirror, simply clone this project and run `terraform providers mirror` with the desired `-platform` parameter 
and destination path.

For example,

```
terraform providers mirror -platform=linux_amd64 ./mirror/
```

To add additional providers, provider versions, or platforms, simply update `provider_versions.tf` and re-run the above command with the desired
platform using the same mirror path.  Using the same mirror path will allow Terraform to properly update the mirror json files to properly track multple provider versions.


[0]: https://hashicorp-mirror.cloudarmor.io/list.html
[1]: https://developer.hashicorp.com/terraform/internals/provider-network-mirror-protocol
[2]: https://github.com/plus3it/tardigrade-terraform-network-mirror/blob/tf-mirror/Dockerfile.tools
[3]: https://github.com/plus3it/tardigrade-terraform-network-mirror/blob/tf-mirror/.github/workflows/dependabot_hack.yml
[4]: https://github.com/plus3it/tardigrade-terraform-network-mirror/blob/tf-mirror/provider_versions.tf
[5]: https://hashicorp-mirror.cloudarmor.io/providers/
[6]: https://developer.hashicorp.com/terraform/cli/config/config-file
[8]: https://developer.hashicorp.com/terraform/cli/config/config-file#provider-installation
[9]: https://developer.hashicorp.com/terraform/cli/config/config-file#filesystem_mirror

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.29.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | 2.2.3 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.2.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

No providers.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

<!-- END TFDOCS -->
