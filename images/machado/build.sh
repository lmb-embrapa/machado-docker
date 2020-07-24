#!/bin/bash


update_settings () {
    cp /opt/machado/config/settings.py.sample ${MACHADO_PROJECT}/settings.py
    if [ ${MACHADO_PROJECT} != "machadosample" ]
    then
        sed -i "s/machadosample/${MACHADO_PROJECT}/g" ${MACHADO_PROJECT}/settings.py
        sed -i "s/'USER': 'username',/'USER': '${POSTGRES_USER}',/g" ${MACHADO_PROJECT}/settings.py
        sed -i "s/'PASSWORD': 'userpass',/'PASSWORD': '${POSTGRES_PASSWORD}',/g" ${MACHADO_PROJECT}/settings.py
    fi
}

/opt/machado/bin/wait-for-it.sh db:5432
/opt/machado/bin/wait-for-it.sh elasticsearch:9200

if [ ! -d ${MACHADO_PROJECT} ]; then
    django-admin startproject ${MACHADO_PROJECT} .
    update_settings
    python manage.py migrate
fi

python manage.py runserver 0.0.0.0:8000
