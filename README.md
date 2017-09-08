# botija
BOT based on telegram for home automation on top of raspberry pi


### Basic installation

Clone this repo from your raspberry pi, and configure it based on sample file. Only values at "Telegram section" are required
```shell
cp botija.cfg.sample botija.cfg
vi botija.cfg
```

Check BOT readiness on your Telegram Chat
```shell
./plug.status.sh
```


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

Ask the BOT to send you a photo on your Telegram Chat
>photo    