#!/usr/bin/env bash

# version="$(curl -sX GET "https://api.github.com/repos/exo-explore/exo/releases/latest" | jq --raw-output '.tag_name' || true)"
version="$(curl -sX GET "https://api.github.com/repos/exo-explore/exo/commits/main" | jq --raw-output '.sha')"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
