#!/usr/bin/env python3
from threading import Thread, local

t = {
    'en': {
    },
    'ru': {
        'Profile': 'Профиль',
        'Files': 'Файлы',
        'Subscriptions': 'Подписки',
        'About': 'Что это?',
        'Favorites': 'Избранное',
        'Conferences': 'Конференции',
        'Login': 'Логин',
        'Address': 'Адрес',
        'Read mode': 'Режим чтения',
        'Feed': 'Лента',
        'Mailbox': 'Почта',
        'Home': 'Главная',
        'Log out': 'Выйти',
        'Log in': 'Войти',
        'Top': 'Наверх',
        'Post message': 'Новое сообщение',
        'New': 'Новое',
        'From': 'От',
        'To': 'Кому',
        'Search': 'Поиск',
        'Subject': 'Тема',
        'Reply to': 'Ответ на',
        'Mark readed': 'Очистить',
        'Sent': 'Отправленные',
        'Received': 'Мне',
        'Edit': 'Редактировать',
        'Reply': 'Ответить',
        'Link to the message': 'Ссылка на сообщение',
        'Private message': 'Личное сообщение',
        'Blacklist': 'Черный список',
        'Next': 'Следующее сообщение',
        'Prev': 'Предыдущее сообщение',
        'Home': 'В начало',
        'End': 'В конец',
        'Enter the text body': 'Введите текст сообщения',
        'auth-key': 'auth-ключ',
        'New message in': 'Новое сообщение в',
        'Send': 'Отправить',
        'Edit subscriptions': 'Управление подписками',
        'Save': 'Сохранить',
        'Add all conferences': 'Добавить все конференции',
        'Edit list of conferences': 'Редактируйте список конференций',
        'Registration': 'Регистрация',
        'Enter username and password': 'Введите имя пользователя и пароль',
        'Register': 'Зарегистрироваться',
        'Back': 'Назад',
        'Read more': 'Читать далее',
        'Authorization': 'Авторизация',
        'List': 'Список',
        'Edit the': 'Редактирование',
        'Private correspondence': 'Личная переписка',
        'Favorites lists': 'Списки избранных сообщений',
        'Wrong username or password!': 'Неверные учетные данные!',
        'Bad username!': 'Плохое имя пользователя!',
        'Such username already exists!': 'Такой пользователь уже существует!',
        'Help': 'Помощь',
        'Code blocks': 'Вставка кода',
        'Quotes': 'Цитирование',
        'Spoilers': 'Спойлеры',
        'Headers and splitters': 'Заголовки и очерчивания',
        'Language': 'Язык',
        'Preview': 'Предпросмотр',
        'Subscribe': 'Подписаться',
        'Unsubscribe': 'Отписаться',
    },
}

data = local()

def setlang(n):
    data.LANG = n

def tr(s):
    LANG = data.LANG
    if s in t[LANG]:
        return t[LANG][s]
    return s
