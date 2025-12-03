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

## 默认端口

API服务默认运行在 `0.0.0.0:5001`

