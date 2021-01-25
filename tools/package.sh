#!/bin/bash
set -euo pipefail

# -- Constants --

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

VERSION_REGEX="(^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(-[a-zA-Z0-9][-a-zA-Z.0-9]*)?(\\+[a-zA-Z0-9][-a-zA-Z.0-9]*)?$)"

# -- Main --
function main {

  echo -e "${YELLOW}Packaging available modules${RESET}"
  have_failed=0
  for module_dir in modules/* ; do

    # -- Check if module dir exists, if not skip --
    if [ ! -e "${module_dir}" ]; then
        echo -e "${YELLOW}${module_dir} doesn't exist, skipping${RESET}"
        continue
    fi

    module_name=$(basename "${module_dir}")
    version_path="modules/${module_name}/version.txt"

    echo -e "${YELLOW}Packaging ${module_name}.${RESET}"

    # -- Check for existence of version file --
    if [ ! -f "${version_path}" ]; then
      echo -e "${RED}No version file for ${module_name} module, skipping${RESET}"
      have_failed=1
      continue
    fi

    # -- Check version is formatted correctly --
    module_version="$(cat "${version_path}")"
    if ! [[ "${module_version}" =~ ${VERSION_REGEX} ]]; then
      echo -e "${RED}${module_name} version format is incorrect, skipping${RESET}"
      have_failed=1
      continue
    fi

    package_path="./tmp/${module_name}-${module_version}.tar.gz"

    # -- Tar & gzip module to create artifact --
    echo -e "${YELLOW}Creating module artifact with tar${RESET}"
    if tar -zcf "${package_path}" -C "${module_dir}"/ .; then
      echo -e "${GREEN}${package_path} created${RESET}"
    else
      echo -e "${RED}Error creating artifact, skipping${RESET}"
      have_failed=1
      continue
    fi

  done

  if [ "${have_failed}" -eq "1" ]; then
    echo -e "${RED}Failed to package some modules${RESET}"
    exit 1
  fi

  # -- Exit if all artifacts created successfully --
  echo -e "${GREEN}Complete${RESET}"
}

main "$@"
