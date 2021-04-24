FROM manifoldai/orbyter-ml-dev:1.7
ADD requirements_docker.txt /app/requirements_docker.txt

# set working directory to /app/
WORKDIR /app/

# set up pip and install python packages
RUN apt-get update &&\
pip3 install --upgrade pip &&\
pip3 install -r requirements_docker.txt
 
# create unprivileged user
RUN adduser --disabled-password --gecos ‘’ myuser

# make tweetvalidator available in Python path
ENV PYTHONPATH "${PYTHONPATH}:/app/src/"

COPY configs /configs
RUN ls -la /configs/*

COPY data /data
RUN ls -la /data/*

COPY src /src
RUN ls -la /src/*

COPY tweet_validator /tweet_validator
RUN ls -la /tweet_validator/*

CMD ["/bin/sh", "run_scripts.sh"]