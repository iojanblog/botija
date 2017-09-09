# botija
BOT based on telegram for home automation on top of raspberry pi

### Basic installation

Clone this repo from your raspberry pi, and configure it based on sample file. Only values at "Telegram section" are required
```shell
cp botija.cfg.sample botija.cfg
vi botija.cfg
```

Check BOT readiness at your Telegram Chat
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

Ask the BOT to send you a photo at your Telegram Chat
>photo    

### August plugin

Install the plugin
```shell
./plug.august.sh install <offlineKey>
```

Ask the BOT to unlock your door at your Telegram Chat
>unlock door    