---
layout: post
title: Setting up a Flask application on an EC2 Ubuntu instance with Apache + mod_wsgi
tags: [amazon, ec2, python, flask, melodypy, music, linux, apache]
draft: true
---

Last weekend I had to restart [my melody.py live demo](http://melodypy.com), as the EC2 instance it was on was outdated. In the process I had to figure out again how to set up [Flask](http://flask.pocoo.org/) applications using `mod_wsgi`. As a relative newbie to both EC2 and Apache, the process took longer than I'd like, so I'm documenting the steps I took in detail, in part to make it easier for me next time I need to do something like this.

I'm going to break the process up into bite-sized chunks:

- Launching an EC2 instance
- Setting up Flask and Apache
- Configuration

So, without further ado ...

Prerequisites
=======
I assume you have a working Flask app that has a remote git repo, perhaps on GitHub.

Launching an EC2 Instance
=======
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-instance_linux.html

Gotchas:

- security group
- make sure that there’s public DNS
- make sure you chmod 0600 your private key

Setting up Flask and Apache
======

Now that the EC2 instance is up and running and we can SSH into it, et's install Apache, mod_wsgi, Flask, and git:
{% highlight bash %}
sudo apt-get install apache2 apache2-base apache2-mpm-prefork apache2-utils libexpat1 ssl-cert
sudo apt-get install python-pip git
pip install flask
{% endhighlight %}

For more information on this step, see [the DigitalOcean tutorial](https://www.digitalocean.com/community/tutorials/installing-mod_wsgi-on-ubuntu-12-04).


Configuration
==========
First things first, we need to make a WSGI file for our application. This is the file that tells Python how to communicate with a web server. I use a very barebones WSGI file:

{% highlight python %}
import sys
sys.path.insert(0, '/var/www/[appname]')

from app import [app global variable in app.py] as application
{% endhighlight %}

(for more information about this file, see [the Flask mod_wsgi documentation](http://flask.pocoo.org/docs/0.10/deploying/mod_wsgi/)). For convenience, I like to store this file directly in git, so save it as `[appname].wsgi` in your app root directory and add it to your app's git repo.

Now, let's deploy this application to the server:
{% highlight bash %}
cd /var/www/
git clone [path to git repo] # you may need to mess with permissions on the /var/www/ directory
{% endhighlight %}

Now, you just need to configure Apache to use `mod_wsgi` and point to your WSGI file.

Go to `/etc/apache2/sites-available/` and make a new file -- let's call it `amazonaws.com.conf`. This is the file that will tell Apache what to do when someone visits your site. A basic template that works for me is:

{% highlight bash %}
NameVirtualHost *:80

<VirtualHost *:80>
        ServerName [your EC2 server's public DNS domain name]
        WSGIScriptAlias / /var/www/[appname]/[appname].wsgi
        <Directory /var/www/[appname]/>
                Order allow,deny
                Allow from all
        </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        LogLevel info
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
{% endhighlight %}

Now let's enable the site we just configured:
{% highlight bash %}
sudo a2ensite amazonaws.com
sudo a2dissite 000-default  # and for good measure, let's disable the default placeholder site
{% endhighlight %}

Almost done! Now we just need to restart apache:
{% highlight bash %}
sudo /etc/init.d/apache2 reload
{% endhighlight %}
is what most tutorials suggest, but for some reason I kept seeing the default Apache loading page after this.
Without digging too deeply, I solved this problem by doing:
{% highlight bash %}
sudo apachectl restart
{% endhighlight %}
instead.

For more information on this step, see [this DigitalRiver tutorial](https://www.digitalocean.com/community/tutorials/using-mod_wsgi-to-serve-applications-on-ubuntu-12-04).

Troubleshooting
==========

Troubleshooting: log
