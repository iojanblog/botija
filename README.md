# botija
BOT based on telegram for home automation on top of raspberry pi

### BOT setup

Install telegram and chat @BotFather to create your BOT, at the en it should give you a token for HTTP API, take note
>> /newbot

Clone this repo and make a new config file based on `botija.cfg.sample`, then configure the token @BotFather gave you
```shell
git clone https://github.com/iojanblog/botija.git && cd botija
vi botija.cfg
```

Add the listener to your crontab, and then start to listen for the first time
```shell
(crontab -l; echo "@reboot `pwd`/botija.sh listen >> `pwd`/tmp/cron.out 2>&1 &") | crontab -
./botija.sh listen
```

Chat with your new BOT, ask to send you status
>status

### Camera plugin

Enable your raspicam and test if it works
```shell
sudo raspi-config
raspistill -o test1.jpg
```

Install the plugin
```shell
./plug.camera.sh install
```

Ask your BOT to send you a photo at your Telegram Chat
>photo    

### August plugin

Install the plugin
```shell
./plug.august.sh install <offlineKey>
```

Ask your BOT to unlock your door at your Telegram Chat
>unlock door    