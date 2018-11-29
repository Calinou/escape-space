#!/usr/bin/env bash
#
# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

set -euo pipefail
IFS=$'\n\t'

# Install gothub to create releases
curl -fsSLO \
    "https://github.com/Calinou/gothub/releases/download/v0.7.1/gothub_0.7.1_linux_x86_64.tar.gz"
tar xf "gothub_0.7.1_linux_x86_64.tar.gz"
sudo mv "gothub_0.7.1_linux_x86_64/gothub" "/usr/local/bin/gothub"

# Delete existing GitHub release
gothub delete \
    --tag "continuous" || true
curl \
    --request DELETE --header "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/git/refs/tags/continuous"

# Create a GitHub release
gothub release \
    --tag "continuous" \
    --name "Continuous build" \
    --description "Continuous build" \
    --pre-release || true

# Upload all artifacts
for artifact in "$SYSTEM_ARTIFACTSDIRECTORY/build"/*; do
  gothub upload \
      --tag "continuous" \
      --name "$(basename "$artifact")" \
      --file "$artifact"
done
