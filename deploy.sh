#!/usr/bin/env bash
# Déploie le site sur Cloudflare Pages (projet « maisonclaire »).
# Prérequis : variable CLOUDFLARE_API_TOKEN (droit « Cloudflare Pages : Edit ») et CLOUDFLARE_ACCOUNT_ID.
# Seuls les fichiers publics partent en ligne (README, RECETTE et ce script restent privés).
set -euo pipefail
cd "$(dirname "$0")"
OUT=$(mktemp -d)
cp -r index.html 404.html _headers favicon.svg logo.svg logo-dark.svg robots.txt sitemap.xml llms.txt fonts img "$OUT"/
npx --yes wrangler@4.45.0 pages deploy "$OUT" --project-name=maisonclaire --branch=main --commit-dirty=true
rm -rf "$OUT"
