# FreeLLMAPI 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/tashfeenahmed/freellmapi#quick-start
# 更新日期：2026-10-28
# 类型：binary
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) { throw '需要先安装 curl（Windows 10+ 自带 curl.exe）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

curl.exe -L --fail -o FreeLLMAPI.zip https://github.com/tashfeenahmed/freellmapi/releases/download/v0.16.11/FreeLLMAPI-0.16.11-win.zip
$h = (Get-FileHash -Algorithm SHA256 FreeLLMAPI.zip).Hash.ToLower() ; if ($h -ne '0b080cb35f89184efea09303f76b0133ecba4c8f963fc1a622f6c8e6d421451d') { throw "SHA256 校验失败，文件可能不完整，请重试" }
Expand-Archive -Path FreeLLMAPI.zip -DestinationPath FreeLLMAPI -Force ; $exe = Get-ChildItem -Path FreeLLMAPI -Recurse -Filter *.exe | Select-Object -First 1 ; Start-Process -FilePath $exe.FullName ; Write-Host '已启动 FreeLLMAPI，面板地址 http://127.0.0.1:3001'

Write-Host ''
$url = 'http://127.0.0.1:3001'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成：打开 http://127.0.0.1:3001，在 Keys 页添加供应商 Key，再到 Fallback Chain 调顺序'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/tashfeenahmed/freellmapi#quick-start'
