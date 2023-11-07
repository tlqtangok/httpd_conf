# httpd_conf
my httpd_conf on docker , include cgi, webdav

# usage
to run a httpd + cgi + webdav server, use 
```
sh setup_httpd.sh

```


this will start a docker server on :10248-->:80

the cgi will run like:

```
curl localhost:10248/cgi-bin/printenv
```

the webdav url will be:
```
http://localhost:10248/uploads
```

use any webdav client,like ios app: ES file explorer to open and uploads files.

happy , enjoy, gogogo :)


author: jd
email: tlqtangok@126.com

