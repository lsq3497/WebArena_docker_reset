# WebArena Docker Reset API

用于在AWS Linux服务器上控制WebArena容器重置的API服务。

## 项目结构

```
webarena-reset-api/
├── README.md
├── reset_api.py
├── container_manager.py
├── config.env                   # 统一配置容器运行参数（HOSTNAME等）
├── scripts/
│   ├── reset_shopping.sh
│   ├── reset_shopping_admin.sh
│   ├── reset_forum.sh
│   ├── reset_gitlab.sh
│   ├── reset_kiwix.sh
│   ├── reset_map.sh
│   └── reset_all.sh
├── requirements.txt
└── systemd/
    └── reset-api.service
```

## 安装和配置

1. 安装Python依赖：
```bash
pip install -r requirements.txt
```

2. 配置 `config.env` 文件，设置HOSTNAME和容器镜像名称。

3. 确保所有脚本有执行权限：
```bash
chmod +x scripts/*.sh
```

## 使用systemd服务

1. 复制systemd服务文件：
```bash
sudo cp systemd/reset-api.service /etc/systemd/system/
```

2. 重新加载systemd配置：
```bash
sudo systemctl daemon-reload
```

3. 启动服务：
```bash
sudo systemctl start reset-api
```

4. 设置开机自启：
```bash
sudo systemctl enable reset-api
```

## API端点

- `POST /reset` - 重置所有容器
- `POST /reset/{container}` - 重置指定容器（shopping, shopping_admin, forum, gitlab, kiwix, map）
- `GET /status` - 获取所有容器的运行状态

## 容器重置时长说明

不同容器的重置时间差异较大，请根据实际需求选择合适的容器进行测试或重置：

| 容器名称 | 预计时长 | 说明 |
|---------|---------|------|
| **forum** | 5-10秒 | ⚡ 最快，无等待时间，适合快速测试 |
| **kiwix** | 5-10秒 | ⚡ 很快，无等待时间 |
| **map** | 10-20秒 | ⚡ 较快，使用docker compose |
| **shopping** | 60-70秒 | ⏱️ 需要等待60秒让Magento服务启动 |
| **shopping_admin** | 60-70秒 | ⏱️ 需要等待60秒让Magento服务启动 |
| **gitlab** | 5-10分钟 | ⏳ 最慢，需要等待300秒（5分钟）让GitLab完全启动，并执行reconfigure操作 |

### 重要提示

1. **API响应时间**：由于重置操作是同步执行的，API请求会阻塞直到重置完成。对于长时间操作（如gitlab），建议：
   - 使用异步方式调用API（如后台任务）
   - 或者增加HTTP客户端超时时间
   - 或者考虑将API改为异步执行（需要修改代码）

2. **测试建议**：首次测试API功能时，建议使用 `forum` 或 `kiwix` 容器，它们执行最快，可以快速验证API是否正常工作。

3. **重置所有容器**：`POST /reset` 会按顺序重置所有容器，总耗时约为 **7-12分钟**（取决于gitlab的启动时间）。

## 默认端口

API服务默认运行在 `0.0.0.0:5001`

## API测试示例（PowerShell）

以下是在Windows PowerShell中使用curl命令测试API的示例（假设API服务运行在 `ec2-18-224-173-55.us-east-2.compute.amazonaws.com:5001`）：

### 1. 获取所有容器状态

```powershell
curl.exe -X GET http://ec2-18-224-173-55.us-east-2.compute.amazonaws.com:5001/status
```

### 2. 重置shopping容器

```powershell
curl.exe -X POST http://ec2-18-224-173-55.us-east-2.compute.amazonaws.com:5001/reset/shopping
```

### 3. 重置所有容器

```powershell
curl.exe -X POST http://ec2-18-224-173-55.us-east-2.compute.amazonaws.com:5001/reset
```

**注意：** 请根据实际的服务器地址和端口修改上述命令中的URL。如果API服务运行在本地，可以使用 `http://localhost:5001` 或 `http://127.0.0.1:5001`。

