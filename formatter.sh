#!/usr/bin/env bash
find $(pwd) -name "*.nix" \
  -not -path "*/extra-files/*" \
  -not -path "*/old/*" \
  -exec nixfmt {} \;