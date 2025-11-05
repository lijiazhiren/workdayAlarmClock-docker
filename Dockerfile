FROM debian:bookworm-slim

# 仅增加 curl, jq, socat 来实现网络数据提取和代理。
RUN apt update && apt install -y mplayer wget curl jq socat && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.mplayer /app

WORKDIR /app

RUN wget -O /app/workdayAlarmClock-linux https://github.com/zanjie1999/workdayAlarmClockGo/releases/latest/download/workdayAlarmClock-linux

RUN echo "ao=null" >> /root/.mplayer/config && \
    echo "vo=null" >> /root/.mplayer/config && \
    echo "quiet=yes" >> /root/.mplayer/config

RUN chmod +x /app/workdayAlarmClock-linux

# 暴露主程序 (8080) 和代理程序 (8081)
EXPOSE 8080 8081

# 拷贝启动脚本和代理脚本
COPY start.sh /app/start.sh
COPY proxy_script.sh /app/proxy_script.sh
RUN chmod +x /app/start.sh /app/proxy_script.sh

# 更改入口点为启动脚本
ENTRYPOINT ["/app/start.sh"]
