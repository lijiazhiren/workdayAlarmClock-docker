FROM debian:bookworm-slim

RUN apt update && apt install -y wget mplayer busybox  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.mplayer /app

WORKDIR /app

COPY start.sh /app/start.sh

RUN wget -O /app/workdayAlarmClock-linux https://github.com/zanjie1999/workdayAlarmClockGo/releases/latest/download/workdayAlarmClock-linux && chmod +x /app/workdayAlarmClock-linux  && chmod +x /app/workdayAlarmClock-linux  /app/start.sh

RUN echo "ao=null" >> /root/.mplayer/config && \
    echo "vo=null" >> /root/.mplayer/config && \
    echo "quiet=yes" >> /root/.mplayer/config

# 暴露主程序 (8080) 和代理程序 (8081)
EXPOSE 8080 8088

# 更改入口点为启动脚本
ENTRYPOINT ["/app/start.sh"]

