export MIRROR_DOCKERFILE_TOOLS ?= Dockerfile.tools
export MIRROR_GITHUB_TOOLS ?= $(PWD)/.github/workflows/dependabot_hack.yml

export REPO_DIR ?= $(PWD)/.mirror/repo
export PACKER_VERSION ?= $(call match_pattern_in_file,$(MIRROR_DOCKERFILE_TOOLS),'hashicorp/packer','$(SEMVER_PATTERN)')
export PACKER_VERSION_REPO_PATH ?= $(REPO_DIR)/packer/$(PACKER_VERSION)
export TERRAFORM_VERSION ?= $(call match_pattern_in_file,$(MIRROR_DOCKERFILE_TOOLS),'hashicorp/terraform','$(SEMVER_PATTERN)')
export TERRAFORM_VERSION_REPO_PATH ?= $(REPO_DIR)/terraform/$(TERRAFORM_VERSION)
export TERRAGRUNT_VERSION ?= v$(call match_pattern_in_file,$(MIRROR_GITHUB_TOOLS),'gruntwork-io/terragrunt','$(SEMVER_PATTERN)')
export TERRAGRUNT_VERSION_REPO_PATH ?= $(REPO_DIR)/terragrunt/$(TERRAGRUNT_VERSION)

include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)

$(REPO_DIR)/%:
	@ echo "[make]: Creating directory '$@'..."
	mkdir -p $@

packer/download: | $(PACKER_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(PACKER_VERSION)..."
	$(call download_hashicorp_release,$(PACKER_VERSION_REPO_PATH)/$(@D)_$(PACKER_VERSION)_$(OS)_$(ARCH).zip,$(@D),$(PACKER_VERSION))

packer-plugin/download/%: PACKER_PLUGIN_NAME = packer-plugin-$*
packer-plugin/download/%: PACKER_PLUGIN_VERSION = $(call match_pattern_in_file,$(MIRROR_GITHUB_TOOLS),'hashicorp/$(PACKER_PLUGIN_NAME)','$(SEMVER_PATTERN)')
packer-plugin/download/%: PACKER_PLUGIN_VERSION_REPO_PATH = $(REPO_DIR)/packer-plugins/$*/$(PACKER_PLUGIN_VERSION)
packer-plugin/download/%:
	@ $(SELF) $(PACKER_PLUGIN_VERSION_REPO_PATH)
	@ echo "[$@]: Downloading $(PACKER_PLUGIN_NAME) $(PACKER_PLUGIN_VERSION)..."
	$(call download_hashicorp_release,$(PACKER_PLUGIN_VERSION_REPO_PATH)/$(PACKER_PLUGIN_NAME)_$(PACKER_PLUGIN_VERSION)_$(OS)_$(ARCH).zip,$(PACKER_PLUGIN_NAME),$(PACKER_PLUGIN_VERSION))

packer-plugins/download: | guard/program/jq
packer-plugins/download: packer-plugin/download/amazon packer-plugin/download/azure packer-plugin/download/vagrant packer-plugin/download/virtualbox

terraform/download: | $(TERRAFORM_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(TERRAFORM_VERSION)..."
	$(call download_hashicorp_release,$(TERRAFORM_VERSION_REPO_PATH)/$(@D)_$(TERRAFORM_VERSION)_$(OS)_$(ARCH).zip,$(@D),$(TERRAFORM_VERSION))

terragrunt/download: TERRAGRUNT_FILENAME = $(shell basename $(shell $(call parse_github_download_url,gruntwork-io,$(@D),tags/$(TERRAGRUNT_VERSION),(.name | contains("$(OS)_$(ARCH)")))))
terragrunt/download: | $(TERRAGRUNT_VERSION_REPO_PATH) guard/program/jq
	@ echo "[$@]: Downloading $(@D) $(TERRAGRUNT_VERSION)..."
	$(call download_github_release,$(TERRAGRUNT_VERSION_REPO_PATH)/$(TERRAGRUNT_FILENAME),gruntwork-io,$(@D),tags/$(TERRAGRUNT_VERSION),(.name | contains("$(OS)_$(ARCH)")))

download-all: packer/download packer-plugins/download terraform/download terragrunt/download
