server.port=8080
server.contextPath=/myapp
spring.main.banner-mode=off
logging.level.org.springframework=ERROR
spring.datasource.url=jdbc:mysql://${db_server}:3306/${db_name}?useUnicode=true&characterEncoding=utf8&createDatab$
spring.datasource.username=${db_user}
spring.datasource.password=${db_pass}
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
