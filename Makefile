include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)

export MIRROR_DOCKERFILE_TOOLS ?= Dockerfile.tools
export MIRROR_GITHUB_TOOLS ?= $(PWD)/.github/workflows/dependabot_hack.yml

export REPO_DIR ?= $(PWD)/.mirror/repo
export PACKER_VERSION ?= $(call match_pattern_in_file,$(MIRROR_DOCKERFILE_TOOLS),'hashicorp/packer','$(SEMVER_PATTERN)')
export PACKER_VERSION_REPO_PATH ?= $(REPO_DIR)/packer/$(PACKER_VERSION)
export TERRAFORM_VERSION ?= $(call match_pattern_in_file,$(MIRROR_DOCKERFILE_TOOLS),'hashicorp/terraform','$(SEMVER_PATTERN)')
export TERRAFORM_VERSION_REPO_PATH ?= $(REPO_DIR)/terraform/$(TERRAFORM_VERSION)
export TERRAGRUNT_VERSION ?= v$(call match_pattern_in_file,$(MIRROR_GITHUB_TOOLS),'gruntwork-io/terragrunt','$(SEMVER_PATTERN)')
export TERRAGRUNT_VERSION_REPO_PATH ?= $(REPO_DIR)/terragrunt/$(TERRAGRUNT_VERSION)

export PACKER_PLUGIN_AMAZON_VERSION ?= v$(call match_pattern_in_file,$(MIRROR_GITHUB_TOOLS),'hashicorp/packer-plugin-amazon','$(SEMVER_PATTERN)')
export PACKER_PLUGIN_AMAZON_VERSION_REPO_PATH ?= $(REPO_DIR)/packer-plugins/amazon/$(PACKER_PLUGIN_AMAZON_VERSION)

$(REPO_DIR)/%:
	@ echo "[make]: Creating directory '$@'..."
	mkdir -p $@

packer/download: | $(PACKER_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(PACKER_VERSION)..."
	$(call download_hashicorp_release,$(PACKER_VERSION_REPO_PATH)/$(@D)_$(PACKER_VERSION)_$(OS)_$(ARCH).zip,$(@D),$(PACKER_VERSION))

packer-plugin-amazon/download: PLUGIN_FILENAME = $(shell basename $(shell $(call parse_github_download_url,hashicorp,$(@D),tags/$(PACKER_PLUGIN_AMAZON_VERSION),(.name | contains("$(OS)_$(ARCH)")))))
packer-plugin-amazon/download: | $(PACKER_PLUGIN_AMAZON_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(PACKER_PLUGIN_AMAZON_VERSION)..."
	$(call download_github_release,$(PACKER_PLUGIN_AMAZON_VERSION_REPO_PATH)/$(PLUGIN_FILENAME),hashicorp,$(@D),tags/$(PACKER_PLUGIN_AMAZON_VERSION),(.name | contains("$(OS)_$(ARCH)")))

terraform/download: | $(TERRAFORM_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(TERRAFORM_VERSION)..."
	$(call download_hashicorp_release,$(TERRAFORM_VERSION_REPO_PATH)/$(@D)_$(TERRAFORM_VERSION)_$(OS)_$(ARCH).zip,$(@D),$(TERRAFORM_VERSION))

terragrunt/download: TERRAGRUNT_FILENAME = $(shell basename $(shell $(call parse_github_download_url,gruntwork-io,$(@D),tags/$(TERRAGRUNT_VERSION),(.name | contains("$(OS)_$(ARCH)")))))
terragrunt/download: | $(TERRAGRUNT_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(TERRAGRUNT_VERSION)..."
	$(call download_github_release,$(TERRAGRUNT_VERSION_REPO_PATH)/$(TERRAGRUNT_FILENAME),gruntwork-io,$(@D),tags/$(TERRAGRUNT_VERSION),(.name | contains("$(OS)_$(ARCH)")))

download-all: packer/download packer-plugin-amazon/download terraform/download terragrunt/download
