# botija
BOT based on telegram for home automation on top of raspberry pi

### BOT setup

Install telegram and chat @BotFather to create your own BOT, at the end it should give you a token for HTTP API, take note
>/newbot

Clone this repo and make a new `botija.cfg` file based on sample provided, then configure the token and households
```shell
token="333333333:abcdefgABCDEFG_abcdefgABCDEFGabcdefg"
households="111111111 222222222"
```

Add the listener to your crontab, and then start to listen for the first time
```shell
(crontab -l; echo "@reboot `pwd`/botija.sh listen >> `pwd`/tmp/cron.out 2>&1 &") | crontab -
./botija.sh listen
```

Chat with your new BOT, ask him send you status
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

### Nearby plugin

Install the plugin
```shell
./plug.nearby.sh install 
```

Edit your `botija.cfg` file, setting nearby_wify_mac parameter
```shell
nearby_wify_mac="11:11:11:11:11:11 ff:ff:ff:ff:ff:ff"
```