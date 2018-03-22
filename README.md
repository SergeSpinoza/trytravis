# SergeSpinoza_infra
SergeSpinoza Infra repository


# HomeWork-4

## Основное задание
Для подключения к internalhost в одну команду с рабочего устройства необходимо набрать следующую команду:

`ssh -A -t spinoza@35.205.75.117 ssh -A spinoza@10.132.0.3`


## Доп. задание
Для подключения к внутреннему хосту через команду вида ssh internalhost необходимо создать файл ~/.ssh/config со следующим содержимым: 

```
Host someinternalhost
User spinoza
HostName 10.132.0.3
ForwardAgent yes
ProxyCommand ssh spinoza@35.205.75.117 nc %h %p
```


## Данные для подключения

bastion_IP = 35.205.75.117
someinternalhost_IP = 10.132.0.3


# HomeWork-5

## Основное задание
Добавлены скрипты для развертывания
install_ruby.sh
install_mongodb.sh
deploy.sh

Данные для автоматического теста:
testapp_IP = 35.190.221.150
testapp_port = 9292

## Дополнительные задания:
1. Добавлен startup-script.sh скрипт для автоматического развертывания инстанса с запущенным приложением.

Для запуска развертывания с загрузкой вышеуказанного скрипта по URL необходимо повыполнить команду: 
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://gist.githubusercontent.com/SergeSpinoza/9c2c7178abad8b02d06e8b5b2e6601e4/raw/3706e8caee71a35d23ff0232c1e02d7a6d6cf5f6/startup-script.sh
  ```

2. Команда для добавления правила фаервола через gcloud:
```
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags puma-server
```

