#使用官方的 debian:bookworm-slim 基础镜像

FROM debian:bookworm-slim

#安装 mplayer, wget, 以及 busybox（包含 httpd 服务）

RUN apt update && apt install -y mplayer wget busybox && rm -rf /var/lib/apt/lists/*

#设置工作目录

WORKDIR /app

#workdayAlarmClock-linux是主程序

RUN wget -O /app/workdayAlarmClock-linux https://github.com/zanjie1999/workdayAlarmClockGo/releases/latest/download/workdayAlarmClock-linux

#MPlayer 配置

RUN mkdir -p /root/.mplayer && echo "ao=null" >> /root/.mplayer/config && echo "vo=null" >> /root/.mplayer/config && echo "quiet=yes" >> /root/.mplayer/config

RUN chmod +x /app/workdayAlarmClock-linux

#开放主程序使用的端口

EXPOSE 8080

#开放 HTTP 文件服务使用的端口

EXPOSE 8088

#拷贝启动脚本和 MQTT 监控脚本

COPY start.sh /app/start.sh

#赋予启动脚本执行权限

RUN chmod +x /app/start.sh

#启动脚本作为入口点

ENTRYPOINT ["/app/start.sh"]
