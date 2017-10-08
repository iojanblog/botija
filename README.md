# botija
BOT based on telegram for home automation on top of raspberry pi

### BOT setup

At Telegram App chat @BotFather to create your own BOT, it should give you a token for HTTP API
>/newbot

Clone this repo and make a new `botija.cfg` file based on sample provided, then configure the token and your households
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

Ask your BOT to send you a photo
>photo    

### August plugin

Install the plugin
```shell
./plug.august.sh install <offlineKey>
```

Ask your BOT to unlock your door
>unlock door    

### Nearby plugin

Install the plugin
```shell
./plug.nearby.sh install 
```

Edit your `botija.cfg` file, setting nearby_wifi_mac or nearby_blue_mac parameter
```shell
nearby_wifi_mac="11:11:11:11:11:11 ff:ff:ff:ff:ff:ff"
nearby_blue_mac="22:22:22:22:22:22 ee:ee:ee:ee:ee:ee"
```

Ask your BOT for the last count
>nearby count  

### Livolo plugin

Install the plugin
```shell
./plug.livolo.sh install 
```

Hold any light switch button for 5 seconds and wait for a beep, then execute this
```shell
./plug.livolo.sh toggle 0
```
It should beep again, signalling it is paired. You can use any number from 0 to 9

Ask your BOT to toggle lights
>toggle light 0
Ask your BOT to turn all off
>lights off