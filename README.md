# machado-docker

This repository contains docker images to create you Machado instance. 

## Requirements

- Docker 
- Docker Compose (>=1.25.4)

Make sure you can run docker with your current user:

    docker run hello-world


## Quickstart

Just grab the code using GIT and enter the directory:

    git clone https://github.com/lmb-embrapa/machado-docker.git
    cd machado-docker

It's required to create two mounting points for the PostgreSQL and ElasticSearch data. Otherwise, docker will create them with the root user and there will be permissions issues.

    mkdir ./data/pgdata
    mkdir ./data/ecdata
    mkdir ./data/jbdata

Now, edit the `.env` file to update your user information. In order to find you UID, just type `id` in a linux terminal. 

| **Variable**          | **Description**                                                         |
|-----------------------|-------------------------------------------------------------------------|
| **UID**               | the numeric value obtained using the command `id`                       |
| **USER**              | the username of your current user                                       |
| **POSTGRES_DB**       | the name of the database that will be created                           |
| **POSTGRES_USER**     | a user nome to access the database                                      |
| **POSTGRES_PASSWORD** | a password to access the database                                       |
| **MACHADO_SOURCE**    | the URL to the Machado GitHub repository or a fork of this repository   |
| **MACHADO_PROJECT**   | the name of the Machado instance that you are creating                  |


To start the containers, type:

    docker-compose up --build --force-recreate

After creating the images and starting up the containers, the log will stop, but the prompt will not release.
The terminal will be locked with this process.

Now open the Machado instance in a browser using the URL (replace machadosample with the value of the variable MACHADO\_PROJECT): 

    http://localhost:8000/machadosample/

There are sample data files that can be quickly loaded. 
You can just open a new terminal, access the machado-docker directory and run:

    bash load_machadosample.sh

The results can be visualized in the browser, by accessing the URL above and using the search box. If you tried the search box before loading the data, it's necessary to restart the containers in order to clean the cache.

To stop machado-docker, go back to the terminal that is displaying the logs and stop the containers:

    CTRL+C
    docker-compose down
    
To get them running again just type:

    docker-compose up

