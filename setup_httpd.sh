# open cgi and dav for httpd  
set -e
set -x
docker rm -f httpd_v0

# docker run -dit --name httpd_v0 -h httpd_v0 -p 10248:80 -v /home/ubuntu/jd/t/html:/usr/local/apache2/htdocs  -v $t/vt:/uploads httpd
#
# docker run -dit \
#   --name httpd_v0 \
#   -h httpd_v0 \
#   -p 10248:80 \
#   -v /home/ubuntu/jd/t/html:/usr/local/apache2/htdocs \
#   -v $t/vt:/uploads \
#   httpd

docker run -dit \
  --name httpd_v0 \
  -h httpd_v0 \
  -p 10248:80 \
  -p 10247:443 \
  -v /home/ubuntu/jd/t/html:/usr/local/apache2/htdocs \
  -v `pwd`/ssl/server.crt:/usr/local/apache2/conf/server.crt:ro \
  -v `pwd`/ssl/server.key:/usr/local/apache2/conf/server.key:ro \
  -v `pwd`/httpd.conf:/usr/local/apache2/conf/httpd.conf:ro \
  -v $t/vt:/uploads \
   httpd


#docker cp httpd.conf httpd_v0:/usr/local/apache2/conf/httpd.conf
docker cp httpd-dav.conf httpd_v0:/usr/local/apache2/conf/extra/httpd-dav.conf
docker cp printenv httpd_v0:/usr/local/apache2/cgi-bin/printenv
docker cp user.passwd httpd_v0:/usr/local/apache2/

cat > run_setenv.sh <<EOF
set -e
set -x
useradd --create-home --no-log-init --shell /bin/bash jd
adduser jd sudo 
echo 'jd:pw' | chpasswd

chmod 0755 /usr/local/apache2/cgi-bin/printenv
mkdir -p var
touch var/DavLock
chown jd:jd var/DavLock
chmod 0666 var/DavLock
# htdigest -c "/usr/local/apache2/user.passwd" DAV-upload jd
chmod 0666 user.passwd  # user:jd , pw:pw
ls -al var/DavLock
stat var/DavLock

mkdir -p /uploads
ln -s /uploads uploads
chown -R jd:jd uploads/
chmod -R 0777 uploads

#setup timezone
rm /etc/localtime 
cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
date "+%Y%m%d_%H%M" >> uploads/startup_log.txt

EOF


docker cp run_setenv.sh httpd_v0:/tmp/run_setenv.sh
rm run_setenv.sh

docker exec httpd_v0 bash /tmp/run_setenv.sh

docker restart httpd_v0




