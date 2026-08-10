#!/usr/bin/env bash
set -euo pipefail
usage(){ cat <<E
Usage: \$0 --url <URL> --out <OUTPUT_PATH> [--sha256 <SHA256>]
E
}
URL=""; OUT=""; SHA=""
while [[ \$# -gt 0 ]]; do
  case "\$1" in
    --url) URL="\$2"; shift 2;;
    --out) OUT="\$2"; shift 2;;
    --sha256) SHA="\$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: \$1"; usage; exit 1;;
  esac
done
if [[ -z "\$URL" || -z "\$OUT" ]]; then echo "--url and --out are required"; usage; exit 1; fi
mkdir -p "$(dirname "\${OUT}")"
if command -v curl >/dev/null 2>&1; then
  curl -L --fail --retry 3 --connect-timeout 10 -o "\$OUT" "\$URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "\$OUT" "\$URL"
else
  echo "需要 curl 或 wget 来下载"; exit 1
fi
if [[ -n "\$SHA" ]]; then
  if command -v sha256sum >/dev/null 2>&1; then
    echo "\${SHA}  \${OUT}" | sha256sum -c -
  elif command -v shasum >/dev/null 2>&1; then
    echo "\${SHA}  \${OUT}" | shasum -a 256 -c -
  else
    echo "未找到 sha256 校验工具；跳过校验"
  fi
fi
echo "下载完成: \${OUT}"
