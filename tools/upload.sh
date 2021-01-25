#!/bin/bash
set -euo pipefail

# -- Constants --

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

S3_BUCKET="tf-modules-prod"

# -- Main --
function main {

  echo -e "${YELLOW}Uploading Terraform modules${RESET}"
  have_failed=0
  for module_path in ./tmp/*.tar.gz ; do

    # -- Check if module artifact exists, if not skip --
    if [ ! -e "${module_path}" ]; then
        echo -e "${YELLOW}${module_path} doesn't exist, skipping${RESET}"
        continue
    fi

    echo -e "${YELLOW}Starting upload of ${module_path}${RESET}"
    module_file=$(basename "${module_path}")
    module_name=$(sed -E 's/\-([0-9]+)\.([0-9]+)\.([0-9]+)\.tar\.gz//g' <<< "${module_file}")

    ## -- Skip upload if artifact version already exists in repo --
	if aws s3api head-object --bucket "${S3_BUCKET}" --key "${module_name}/${module_file}" > /dev/null 2>&1; then
      echo -e "${YELLOW}${module_file} already exists in repository, skipping${RESET}"
      continue
    fi

    # -- Upload module to repo --
    module_md5_checksum=$(openssl md5 -binary "${module_path}" | base64)
	if aws s3api put-object --bucket "${S3_BUCKET}" --key "${module_name}/${module_file}" --body "${module_path}" --content-md5 "${module_md5_checksum}" > /dev/null 2>&1; then
      echo -e "${GREEN}${module_file} uploaded successfully${RESET}"
    else
      echo -e "${RED}${module_file} upload failed${RESET}"
      have_failed=1
      continue
    fi

  done

  if [ "${have_failed}" -eq "1" ]; then
    echo -e "${RED}Failed to upload some modules${RESET}"
    exit 1
  fi

  # -- Exit if all artifacts uploaded successfully --
  echo -e "${GREEN}Upload complete${RESET}"
}

main "$@"
