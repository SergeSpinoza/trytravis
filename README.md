# SergeSpinoza_infra
SergeSpinoza Infra repository


# HomeWork-4

## Основное задание
Для подключения к internalhost в одну команду с рабочего устройства необходимо набрать следующую команду:

`ssh -A -t spinoza@35.205.75.117 ssh -A spinoza@10.132.0.3`


## Доп. задание
Для подключения к внутреннему хосту через команду вида ssh internalhost необходимо создать файл ~/.ssh/config со следующим содержимым: 

```Host someinternalhost
User spinoza
HostName 10.132.0.3
ForwardAgent yes
ProxyCommand ssh spinoza@35.205.75.117 nc %h %p```


## Данные для подключения

bastion_IP = 35.205.75.117
someinternalhost_IP = 10.132.0.3

