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

It's **required** to create mounting points for the PostgreSQL, ElasticSearch, and JBrowse data. Otherwise, docker will create them with the root user and there will be permissions issues.

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

## Deploy your own Machado instance

In order to load your own datasets you'll need to git clone this repository to a brand new directory, configure the .env file with the information related to your project, load and index the datasets, and configure JBrowse. 

### Loading data

The data loading process should be executed in a particular order that is documented at https://machado.readthedocs.io/en/latest/dataload.html 

The instructions you'll find use the manage.py component from Django. In order to invoke it using the Docker environment it's required to add `docker-compose exec machado` before each data loading command. For example:

    docker-compose exec machado python manage.py load_relations_ontology --file data/sample/ontologies/ro.obo

After loading the data, it's required to rebuild the ElasticSearch index using:

    docker-compose exec machado python manage.py rebuild_index


### JBrowse

The JBrowse configuration file is available at `./data/jbdata`. If you have the machadosample instance running, you'll notice that inside jbdata there's a directory named after the organism, ***Arabidopsis thaliana*** in this case,  that contains a trackList.json file. 

It's necessary to create such directories containing trackList.json files for each organism that's loaded to the database. A sample trackList.json.sample is available at `./images/machado/config/trackList.json.sample`.

For example, if the mouse genomics data is loaded, there must be a `./data/pgdata/Mus musculus/trackList.json`. It's also required to open the trackList.json file and update the organism information properly.
