#!/bin/bash


update_settings () {
    cp /opt/machado/config/settings.py.sample ${MACHADO_PROJECT}/settings.py
    sed -i "s/machadosample/${MACHADO_PROJECT}/g" ${MACHADO_PROJECT}/settings.py
    sed -i "s/'USER': 'username',/'USER': '${POSTGRES_USER}',/g" ${MACHADO_PROJECT}/settings.py
    sed -i "s/'PASSWORD': 'userpass',/'PASSWORD': '${POSTGRES_PASSWORD}',/g" ${MACHADO_PROJECT}/settings.py
}

if [ ! -d ${MACHADO_PROJECT} ]; then
    django-admin startproject ${MACHADO_PROJECT} .
    update_settings
    python manage.py migrate
    python manage.py collectstatic
fi

sudo cp /opt/machado/config/django.conf.sample /etc/apache2/sites-enabled/django.conf
sudo sed -i "s/machadosample/${MACHADO_PROJECT}/g" /etc/apache2/sites-enabled/django.conf

#python manage.py runserver 0.0.0.0:8000

sudo apache2ctl -D FOREGROUND
