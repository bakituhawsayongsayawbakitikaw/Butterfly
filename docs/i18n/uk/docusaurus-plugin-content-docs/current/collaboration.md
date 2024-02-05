---
sidebar_label: Співпраця
sidebar_position: 4
title: Співпраця
---

:::warning 🧪 експеримент

Ця функція стоїть за прапором експерименту. Read more [here](/nightly#experiments).
Все в цьому розділі буде предметом змін.

:::

## Вступ

Як підтримав бета-версію 2.0, Butterfly підтримує співпрацю. Це означає, що ви можете редагувати один і той же файл з кількома людьми одночасно. Це корисно, якщо ви хочете працювати разом на документі.

## Як це працює

Метелик використовує сервер webсокету, який буде розміщений на вашому комп'ютері. Цей сервер повинен бути доступним з Інтернету або вашої локальної мережі. Клієнт буде підключений до цього сервера. Сервер синхронізує всі зміни і події з усіма клієнтами.

## Налаштування сервера

:::note

Ця функція сервера недоступна в інтернеті.

:::

Спершу дозвольте спільний експеримент в налаштуваннях. Після цього відкрийте документ, яким ви хочете поділитися. Потім натисніть кнопку "Поділитися" у лівому верхньому куті праворуч від назви. Відкриється діалог. Натисніть на `початковий сервер`.

Сервер буде розміщений на всіх інтерфейсах на порту `28005`. Ви можете змінити це у діалоговому вікні. Вам потрібно переконатися, що цей сервер доступний клієнту.
У локальній мережі це має працювати з коробкою. Якщо ви хочете отримати доступ до сервера з Інтернету, вам потрібно переслати порт у маршрутизаторі. Ви можете знайти більш детальну інформацію про це [here](https://en.wikipedia.org/wiki/Port_forwarding/).

If you cannot forward the port, you can use a service like [ngrok](https://ngrok.com/). Це створить тунель на вашому локальному сервері. Це є корисно, якщо ви хочете поділитися документом з іншими людьми.

Для ngrok команда виглядатиме так:

```bash
ngrok http 28005
```

## З'єднатися з сервером

Тепер необхідно підключитися до сервера. Для цього перейдіть на домашню сторінку та натисніть на кнопку з плюсом, створивши новий документ. Там ви побачите новий пункт меню під назвою "Підключення".

Натисніть на це і ви побачите діалог. Введіть URL-адресу підключення тут.
Якщо ви перебуваєте в одній мережі, то можете використовувати локальну IP-адресу комп'ютера, в якому працює сервер.
URL-адреса має виглядати так: `ws://{ip}:28005`. Замінити `{ip}` ip адресою комп'ютера. Ви можете знайти IP-адресу за допомогою команди `ipconfig` у вікні або `ifconfig` на linux. На Андроїд ви можете знайти IP-адресу в налаштуваннях Wi-Fi.

Якщо ви не в тій же мережі, то вам потрібно використовувати IP-адресу комп'ютера. Ви можете знайти це, шукаючи `що таке мій ip` в улюбленому вікні пошуку. URL повинен виглядати як зверху, але з публічною IP-адресою.

Якщо ви використовуєте ngrok, налаштування трохи відрізняються. Замінити `https` `ws` і додати порт `:28005` в кінці. URL-адреса має виглядати так: `wss://{random}:28005`. Замініть випадкову частину тієї частини, яку дає ngrok.