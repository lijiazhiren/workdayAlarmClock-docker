#!/bin/sh

# 启动一个只读的 HTTP 文件服务器 (busybox httpd)
# 使用 /bin/busybox 确保 httpd 命令总是能被找到
# -p 8088: 监听 8088 端口
# -h /app: 设置文档根目录为 /app
# -r: 只读模式 (防止上传和删除操作)
# -c: 禁用 CGI
# &: 在后台运行，使脚本可以继续执行主程序
# /bin/busybox httpd -p 8088 -h /app -r -c &

# echo "BusyBox HTTPD 文件服务已在 8088 端口启动，服务目录为 /app (只读)"

# 使用 exec 启动主程序，使其成为容器的 PID 1，确保容器保持在前台运行

exec /app/workdayAlarmClock-linux mplayer
