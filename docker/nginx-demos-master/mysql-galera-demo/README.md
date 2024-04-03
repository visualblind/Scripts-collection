#Demo to show TCP Load balancing with health checks for a Mysql Galera cluster using NGINX Plus

This demo uses NGINX Plus as a TCP load balancer for a MySQL Galera cluster consisting of two mysqld servers. It does round-robin load balancing between the 2 mysqld servers and also does active health checks using an xinetd script running on port 9200 inside each mysqld container. This demo is based on docker and spins' up the following containers:

* [Galera cluster](http://galeracluster.com/products/) consisting of two mysqld containers built using this [Dockerfile](https://github.com/nginxinc/NGINX-Demos/blob/master/mysql-galera-demo/mysql_backend/Dockerfile)
* and of course [NGINX Plus](http://www.nginx.com/products)

## Prerequisites and Required Software

The following software needs to be installed on your laptop:

* [Docker for Mac](https://www.docker.com/products/docker#/mac) if you are running this locally on your MAC **OR** [docker-compose](https://docs.docker.com/compose/install) if you are running this on a linux VM

As the demo uses NGINX Plus a `nginx-repo.crt` and `nginx-repo.key` needs to be copied into the `nginxplus/` directory

## Setting up & Running the demo

1. Clone demo repo

     ```$ git clone https://github.com/nginxinc/NGINX-Demos.git```

1. Copy ```nginx-repo.key``` and ```nginx-repo.crt``` files for your account to ```~/NGINX-Demos/mysql-galera-demo/nginxplus/```

1. Move into the demo directory:

     ```
     $ cd ~/NGINX-Demos/mysql-galera-demo
     ```

1. If you have run this demo previously or have any docker containers running, start with a clean slate by running
    ```
    $ ./clean-containers.sh
    ```

1. NGINX Plus container will be listening on port 8080, 3306 & 9200 on the Docker Host
     1. If you are using Docker Toolbox, you can get the IP address of your docker-machine (default here) by running 

     ```
     $ docker-machine ip default
     192.168.99.100
     ```
     1. If you are using Docker for Mac or Docker Compose on your Linux VM, the IP address you need to use is 127.0.0.1 (localhost)

     Export this IP into an environment variable HOST_IP `export HOST_IP=x.x.x.x` (used by test.sh below)

1. Spin up the MySQL and NGINX Plus containers: 
	 ```
     $ docker-compose up -d
     ```
     The first time you issue this, it will build all the Docker images for you.

1. Now execute the following two docker exec commands in order to start xinetd inside the two mysqld containers
     ```
     $ docker exec -ti mysqld1 nohup service xinetd start
     $ docker exec -ti mysqld2 nohup service xinetd start
     ```

1. Now follow the steps under section 'Running the demo'

## Running the demo

1. You should have a bunch of containers up and running now:
	 ```
	 $ docker ps
	 CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                    NAMES
	 c8850125278d        ktcplb_nginxplus    "nginx -g 'daemon off"   43 minutes ago      Up 42 minutes       0.0.0.0:3306->3306/tcp, 0.0.0.0:8080->8080/tcp, 0.0.0.0:9200->9200/tcp   nginxplus
	 3696bcca070e        ktcplb_mysqld2      "mysqld --wsrep-clust"   43 minutes ago      Up 43 minutes       0.0.0.0:3308->3306/tcp, 0.0.0.0:9202->9200/tcp                           mysqld2
	 7f5fd84b0042        ktcplb_mysqld1      "mysqld --wsrep-clust"   43 minutes ago      Up 43 minutes       0.0.0.0:3307->3306/tcp, 0.0.0.0:9201->9200/tcp                           mysqld1
	 ```

1. Going to `http://<HOST_IP>:8080/` in your favorite browser will bring up the NGINX Plus dashboard. Under the TCP Upstreams tab, you will see two upstream groups named `tcp_backend` & `hc_backend` created. The upstreams under the group `tcp_backend` marked in green indicates that the health checks with the two mysqld servers passed.

1. You could now execute the script test.sh and see that the total connections count increases for both the upstreams in a round robin fashion thereby implying that NGINX Plus is load balancing the TCP connections. But change the Grant privilege to enable remote access to both the mysqld containers using enable-grant.sh first

	 ```
	 $ ./mysql_backend/enable-grant.sh
	 $ ./test.sh
	 ```

1. The way health checks work here is using a mysqlchk script inside `mysql_backend/` directory is litening on port 9200 inside both the mysql containers. It simply executes a `show databases` command and throws a string output `MySQL is running` or `MySQL is *down*` based on the result. And NGINX Plus hits this custom port 9200 on MySQL for health checks using the port parameter added to the [health_check](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#health_check) directive. The important section of nginx.conf file inside `nginxplus/conf` dir used here is this
	 ```
	 upstream hc_backend {
         zone hc_backend 64k;
         server 172.17.0.1:9201;
         server 172.17.0.1:9202;
     }
     match tcp {
         expect ~ "MySQL is running";
     }
     server {
         listen 9200;
         status_zone hc_server;
         proxy_pass hc_backend;
     }
     server {
         listen 3306;
         status_zone tcp_server;
         health_check match=tcp port=9200;
         proxy_pass tcp_backend;
     }
	 ```
