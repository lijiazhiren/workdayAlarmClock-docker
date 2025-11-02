
FROM debian:bookworm-slim

RUN apt update && apt install -y mplayer wget && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.mplayer /app

WORKDIR /app

RUN wget -O /app/workdayAlarmClock-linux  https://github.com/zanjie1999/workdayAlarmClockGo/releases/latest/download/workdayAlarmClock-linux

RUN echo "ao=null" >> /root/.mplayer/config && \
         echo "vo=null" >> /root/.mplayer/config && \
         echo "quiet=yes" >> /root/.mplayer/config

RUN chmod +x /app/workdayAlarmClock-linux

EXPOSE 8080

ENTRYPOINT ["/app/workdayAlarmClock-linux", "/usr/bin/mplayer"]
