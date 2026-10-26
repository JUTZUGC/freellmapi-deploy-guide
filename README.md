# FreeLLMAPI 一键部署指南

> 第三方部署指南 · 非 FreeLLMAPI 官方仓库。官方项目：[tashfeenahmed/freellmapi](https://github.com/tashfeenahmed/freellmapi)
> 内容来自官方文档（2026-10-26）。项目迭代快，请以[官方文档](https://github.com/tashfeenahmed/freellmapi#quick-start)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用一个个申请免费 Key，让百度搭子把路由装好，一个接口调用所有免费模型。

⚠️ 支持 Windows / macOS / Linux / Docker / Termux。免费端点随时可能限流或下线，项目定位是个人实验，不适合生产。面板与网关默认只监听 127.0.0.1:3001。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/freellmapi-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会按系统下载安装包、核对 SHA256；Windows 解压后直接启动，Linux 加执行权限，按它的提示确认即可，结束时它会告诉你结果。
   （下载地址与校验方式以官方文档为准。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:3001](http://127.0.0.1:3001)，按官方引导完成初始化配置。

## FreeLLMAPI 是什么？

FreeLLMAPI 是开源的把几十家免费大模型聚合成一个 OpenAI 兼容接口的本地路由（协议：MIT，<img src="https://img.shields.io/github/stars/tashfeenahmed/freellmapi?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把 34 家免费 LLM 供应商、635 个免费模型端点聚合成一个 OpenAI 兼容的 /v1 接口，做智能路由、自动故障切换、限流跟踪与密钥加密；自带 60 种语言的 Web 面板和菜单栏应用。

- 聚合：34 家供应商、635 个免费端点，统一 /v1
- 路由：按额度、限流、健康度自动换下一个
- 客户端：Claude Code / Codex / Cursor 等有现成接入命令
- 面板：Keys、Fallback Chain、用量统计，支持 60 种语言
- 形态：Windows 安装包、macOS dmg、Linux AppImage、Docker、Termux
- 数据：密钥加密存本机 SQLite，请求不经过第三方中转

（来源：[官方仓库](https://github.com/tashfeenahmed/freellmapi)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 41.9k stars | 半年涨到 41.9k，月增约 1.3 万 |
| 一个接口通吃 | 34 家免费供应商、635 个端点 |
| 自动故障切换 | 某家限流就换下一个 |
| 面板完善 | 60 种语言，含中文 |
| 部署简单 | 安装包、桌面端、Docker、Termux 都有 |

| 需要注意 | 说明 |
|---|---|
| 免费额度不稳定 | 端点随时限流、下线 |
| 仅限个人实验 | 项目自己声明不适合生产 |
| 要自备 Key | 免费不等于免注册 |
| 桌面端包体大 | Windows 包约 141 MB |
| 安全边界有限 | 面板默认只监听本机，别直接暴露公网 |

> 以上基于官方文档与社区反馈整理（2026-10-26），以官方最新文档为准。

## 官方安装方式（可手动执行）

```powershell
# Windows（便携版）
curl.exe -L --fail -o FreeLLMAPI.zip https://github.com/tashfeenahmed/freellmapi/releases/download/v0.16.10/FreeLLMAPI-0.16.10-win.zip
$h = (Get-FileHash -Algorithm SHA256 FreeLLMAPI.zip).Hash.ToLower()
if ($h -ne 'b8a37f31224d42f4d546d3f4a8072e0efe9472a6aba80b135a3bfae1501b347f') { throw 'SHA256 校验失败，请重新下载' }
Expand-Archive -Path FreeLLMAPI.zip -DestinationPath FreeLLMAPI -Force
```

启动后浏览器访问 [http://127.0.0.1:3001](http://127.0.0.1:3001)（管理面板）。（来源：[https://github.com/tashfeenahmed/freellmapi/releases/tag/v0.16.10](https://github.com/tashfeenahmed/freellmapi/releases/tag/v0.16.10)）

## 验证状态

| 场景 | 状态 |
|---|---|
| Release v0.16.10 的 Windows / macOS / Linux 包与 SHA256 digest 已核对 | 已核对 2026-10-26 |
| 未下载安装（Windows 包 141 MB，本机网络不适合完整拉取） | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

FreeLLMAPI 自带 MCP server，Agent 可以在会话中查询路由与用量。本仓库的 MCP 只提供下载、校验与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-26）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\freellmapi-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后

1. 打开 [http://127.0.0.1:3001](http://127.0.0.1:3001)
2. **Keys** 页添加各家供应商的 Key（免费额度也要先注册对应平台）
3. **Fallback Chain** 里排好顺序：前面限流就自动落到下一个
4. 在页头复制统一 API Key，把客户端指向 `http://127.0.0.1:3001/v1`

### 接 Claude Code / Codex

```sh
npx freellmapi launch          # Claude Code
npx freellmapi launch-codex    # Codex
```

### Docker 方式

```sh
curl -fsSL https://freellmapi.co/install.sh | bash
```

需要本机已装 Docker；脚本会在 `~/freellmapi` 生成配置与加密密钥，重复执行会保留。

> ⚠️ 免费端点的额度与可用性由各家随时调整，项目自己也标注为个人实验用途；不要把它放到公网当生产网关，也不要在上面传敏感数据。

## 常见坑

- 面板打不开：确认应用已启动，3001 没被占用
- 某个模型一直失败：免费端点经常限流，在 Fallback Chain 里调整顺序
- 想给别的设备用：默认只监听本机，需要显式开 LAN 并加访问控制
- Windows 用便携版：解压后运行目录里的主程序，不要只拷单个 exe
- macOS 提示无法验证：到「隐私与安全性」允许打开
- Linux AppImage 打不开：先 `chmod +x`，缺 FUSE 时加 `--appimage-extract-and-run`
- 别当生产网关：项目定位是个人实验，没有 SLA

## 免责声明

本仓库为第三方指南，与 FreeLLMAPI 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-26），项目迭代快，请以[官方文档](https://github.com/tashfeenahmed/freellmapi#quick-start)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
