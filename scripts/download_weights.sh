


>
>

cat > create_pr_files.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail

# ensure in git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not in a git repository. cd to repo root first."
  exit 1
fi

git checkout -B add-ci-docker-scripts

mkdir -p scripts .github/workflows

cat > scripts/download_weights.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

usage(){
  cat <<E
Usage: \$0 --url <URL> --out <OUTPUT_PATH> [--sha256 <SHA256>]

Downloads a file from URL to OUTPUT_PATH and optionally verifies its sha256 checksum.
E
}

URL=""
OUT=""
SHA=""
while [[ \$# -gt 0 ]]; do
  case "\$1" in
    --url) URL="\$2"; shift 2;;
    --out) OUT="\$2"; shift 2;;
    --sha256) SHA="\$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: \$1"; usage; exit 1;;
  esac
done

if [[ -z "\$URL" || -z "\$OUT" ]]; then
  echo "--url and --out are required"
  usage
  exit 1
fi

mkdir -p "\$(dirname \"\${OUT}\")"

echo "Downloading \${URL} -> \${OUT}"
if command -v curl >/dev/null 2>&1; then
  curl -L --fail --retry 3 --connect-timeout 10 -o "\$OUT" "\$URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "\$OUT" "\$URL"
else
  echo "Neither curl nor wget found; please install one to download files"
  exit 1
fi

if [[ -n "\$SHA" ]]; then
  if command -v sha256sum >/dev/null 2>&1; then
    echo "Verifying sha256..."
    echo "\${SHA}  \${OUT}" | sha256sum -c -
  elif command -v shasum >/dev/null 2>&1; then
    echo "Verifying sha256 with shasum..."
    echo "\${SHA}  \${OUT}" | shasum -a 256 -c -
  else
    echo "No sha256 verification tool (sha256sum/shasum) found; skipping verification"
  fi
fi

echo "Download finished: \${OUT}"
