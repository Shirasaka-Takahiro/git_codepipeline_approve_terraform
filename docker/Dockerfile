FROM nginx:alpine
 
COPY ./nginx/onya-lab.site.conf /etc/nginx/conf.d/
ADD ./nginx/nginx.conf /etc/nginx/
COPY ./nginx/index.html /var/www/html/
 
EXPOSE 80