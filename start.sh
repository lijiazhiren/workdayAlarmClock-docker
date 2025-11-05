#!/bin/bash

# 1. 启动主程序 (workdayAlarmClock-linux)
/app/workdayAlarmClock-linux /usr/bin/mplayer &

# 2. 健康检查：等待 8080 端口的 /status 接口就绪
echo "Waiting for main program (8080/status) to become ready..."
WAIT_TIME=0
# 循环检查 8080/status 端口是否返回有效响应 (curl -sS 显示错误，2>/dev/null 丢弃)
while ! curl -sS http://127.0.0.1:8080/status 2>/dev/null | grep -q 'isStop'; do
    sleep 1
    WAIT_TIME=$((WAIT_TIME + 1))
    if [ "$WAIT_TIME" -ge 30 ]; then
        echo "Error: Main program on 8080 failed to start after 30 seconds." >&2
        exit 1
    fi
done
echo "Main program is ready after $WAIT_TIME seconds."

# 3. 启动 socat 极简代理
# ignoreeof 参数是解决 Shell 脚本在 EXEC 模式下 I/O 阻塞的关键
echo "Starting socat proxy on 8081..."
socat -T 60 TCP-LISTEN:8081,reuseaddr,fork EXEC:'/app/proxy_script.sh',ignoreeof &

# 4. 等待任一后台进程退出，防止容器关闭
wait -n