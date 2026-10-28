#!/usr/bin/env bash
set -euo pipefail
# FreeLLMAPI 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/tashfeenahmed/freellmapi#quick-start
# 更新日期：2026-10-28
# 类型：binary
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v curl >/dev/null 2>&1 || { echo "需要先安装 curl"; exit 1; }

mkdir -p .download
cd .download

if [ "$(uname -s)" = "Darwin" ]; then case "$(uname -m)" in arm64) url=https://github.com/tashfeenahmed/freellmapi/releases/download/v0.16.11/FreeLLMAPI-0.16.11-arm64.dmg ; want=7acaf7cda4a4072905ba82054cbab22ad43f3e1d62c6eb697d0555d0eae958c5 ;; *) url=https://github.com/tashfeenahmed/freellmapi/releases/download/v0.16.11/FreeLLMAPI-0.16.11-x64.dmg ; want=83ac9597038d8567a1bd2db25a149b1cf99c9bc81c824ad04b321e1d058771e6 ;; esac ; file=FreeLLMAPI.dmg ; else url=https://github.com/tashfeenahmed/freellmapi/releases/download/v0.16.11/FreeLLMAPI-0.16.11.AppImage ; want=0b7446bff587538c8e8a7a1bc00c4418b3b296553bcc9d2b1e3ecf9469564cad ; file=FreeLLMAPI.AppImage ; fi
curl -fL -o "$file" "$url"
if command -v sha256sum >/dev/null 2>&1; then echo "$want  $file" | sha256sum -c - ; else echo "$want  $file" | shasum -a 256 -c - ; fi
if [ "$file" = "FreeLLMAPI.AppImage" ]; then chmod +x FreeLLMAPI.AppImage ; echo "已就绪：./FreeLLMAPI.AppImage" ; else echo "已下载 FreeLLMAPI.dmg，双击挂载后拖进 Applications" ; fi

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:3001"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:3001" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:3001，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:3001 确认"
fi
echo "部署完成：打开 http://127.0.0.1:3001，在 Keys 页添加供应商 Key，再到 Fallback Chain 调顺序"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/tashfeenahmed/freellmapi#quick-start"
