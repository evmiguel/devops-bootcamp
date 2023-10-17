1. 
Start mysql container
```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.1.0
```

Export environment variables for application
```
export DB_USER=root \
> export DB_PWD=my-secret-pw \
> export DB_SERVER=localhost \
> export DB_NAME=mysql
```

Run phpmyadmin
```
docker run --name phpmyadmin -d --link some-mysql:db -p 8081:80 phpmyadmin
```

Build and push to Nexus
```
docker build -t 137.184.78.100:8083/java-app:1.0 .
docker push 137.184.78.100:8083/java-app:1.0
```

Note: setting environment variables with a .env file


```
scp docker-compose.yaml root@143.198.113.128:/root
scp .env root@143.198.113.128:/root
```