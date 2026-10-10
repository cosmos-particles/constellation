#!/usr/bin/env bash
set -euo pipefail

# Exchanges GitHub App credentials for a short-lived installation access token.
# Reads GITHUB_APP_ID, GITHUB_APP_INSTALLATION_ID, GITHUB_APP_PEM_FILE from the
# environment - the same variables the integrations/github Terraform provider's
# app_auth block reads. Prints the installation token to stdout.

: "${GITHUB_APP_ID:?GITHUB_APP_ID must be set}"
: "${GITHUB_APP_INSTALLATION_ID:?GITHUB_APP_INSTALLATION_ID must be set}"
: "${GITHUB_APP_PEM_FILE:?GITHUB_APP_PEM_FILE must be set}"

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

# GITHUB_APP_PEM_FILE may hold the PEM with real newlines, or with literal
# "\n" sequences (common when the key is passed through an env var/secret
# store) - normalize to real newlines so openssl can parse it either way.
pem="${GITHUB_APP_PEM_FILE//\\n/$'\n'}"

now=$(date +%s)
header=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
payload=$(printf '{"iat":%d,"exp":%d,"iss":"%s"}' "$((now - 60))" "$((now + 540))" "$GITHUB_APP_ID" | b64url)
signature=$(printf '%s.%s' "$header" "$payload" | openssl dgst -sha256 -sign <(printf '%s' "$pem") | b64url)
jwt="${header}.${payload}.${signature}"

curl -sS --fail -X POST \
  -H "Authorization: Bearer ${jwt}" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/${GITHUB_APP_INSTALLATION_ID}/access_tokens" \
  | jq -r '.token'
