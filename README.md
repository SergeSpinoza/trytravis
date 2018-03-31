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

# HomeWork-6

## Основное задание
Добавлена директория packer и скрипты для создания параметризированного шаблона reddit-base: 
ubuntu16.json - packer шаблон
scripts/install_mongodb.sh
scripts/install_ruby.sh
variables.json.example - пример файла с параметрами

Для запуска создания шаблона VM необходимо из директории packer выполнить команду:
```
packer build -var-file=variables.json ubuntu16.json
```

В файл .gitignore добавлен файл с реальными параметрами для packer - variables.json
 
В шаблон packer добавлены следующие опции: Описание образа, Размер и тип диска, Название сети, Теги

## Дополнительное задание с * 
Добавлен packer-шаблон для создания bake-образа VM со всеми зависимостями приложения и самим кодом приложения. 
Добавлен скрипт для создания и запуска (в том числе и автозагрузки) puma с использованием systemd unit. 

Для запуска создания шаблона VM необходимо из директории packer выполнить команду:
```
packer build immutable.json
```

## Дополнительное задание с двумя ** 
Создан скрипт создания VM через утилиту gcloud с использованием ранее созданного packer'ом шаблона vm.

Для запуска необходимо запустить скрипт, который находится в директории config-scripts: 
```
create-reddit-vm.sh
``` 

Проверить работу приложения можно по адресу: http://35.195.9.46:9292


# HomeWork-7

## Основное задание 
Добавлена директория terraform, в данную директорию добавлены конфигурационные файлы и файлы переменных terraform. 
Файл terraform.tfvars.example - пример файла с переменными для terraform

Для запуска необходимо из дирректории terraform выполнить команды:
```
terraform plan
terraform apply
``` 

После развертывания приложения и вывода output переменной с ip адресом - необходимо зайти через браузер на этот ip адрес и порт 9292.

## Дополнительное задание с *
Мы добавили пользователей appuser1 и appuser2 с ssh-ключами в метаданные проекта через конфигурационный файл terraform, и пользователя appuser_web через WEB-интерфейс GCP. 

Проблема возникает в следующем: если мы добавляем пользователя (appuser_web) через WEB-интерфейс GCP - то при выполнении команды terraform apply пользователь, созданный через WEB-интерфейс удалиться, т.к. его описания нету в конфигаруционном файле terraform'а.

## Дополнительное задание с **
Мы добавили конфигурационный файл terraform lb.tf для поднятия балансировщика. Добавили в output переменные внешний ip адрес балансировщика. Добавили в main.tf параметр count для поднятия 2-х инстансов reddit-app.

Для проверки необходимо создать файл terraform.tfvars по аналогии файла terraform.tfvars.example, войти в директорию terraform и выполнить команду 
```
terraform apply
```


# Homework-8

## Основное задание
 - Создан модуль vpc;
 - Проверена работа параметра source_ranges модуля vpc;
 - Выполнена дополнительная параметризация модулей. В модуль db добавлен параметр db_port, в модуль app добавлены параметры app_port, app_proto, access_to_app_from.

## Дополнительное задание со *
 - Настроено хранение стейт файла (для окружения prod) на удаленном backend (на одном из созданных storage-bucket);
 - Проверена работа кионфигурационных файлов terraform из другого места;
 - Добавлены provisioner'ы в модуль app для окружения prod;
 - Реализовано опциональное отключение provisioner'ов в модуле app. Для включения необходимо установить значение переменной "need_deploy" в "true".

## Для проверки работы необходимо: 
 - предварительно собрать необходимые образы packer'ом, зайдя в директорию packer и выполнив последовательно команды `packer build db.json` и `packer build app.json`;
 - запустить `terraform init` из директории terraform для создания backet'ов и установки нужных провайдеров;
 - запустить `terraform init` из директории необходимого окружения (для проверки приложения - prod);
 - запустить `terraform plan` и `terraform apply`;
 - порверить работу приложения из браузера, зайдя на ip адрес инстанса app и порт 9292.
 
