根据这个制作  个人配合HomeAssistant自用   
https://github.com/zanjie1999/workdayAlarmClockGo

sudo docker build -t workdayAlarmClock:1.0 .

sudo docker run --name my-app -p 8080:8080 workdayAlarmClock:1.0
