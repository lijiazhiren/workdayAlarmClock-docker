根据这个制作  个人配合HomeAssistant和esphome自用   
https://github.com/zanjie1999/workdayAlarmClockGo

sudo docker build -t workdayalarmclock:0.1 .

sudo docker run -d --name workdayalarmclock -p 8080:8080 -p 8088:8088 workdayalarmclock:0.1
