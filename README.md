# Certbot Automatically Manual Renew


## Why

After serving a docker image for a website, I found it tricky to use certbot to issue a certificate.

The best way to add a `SSL` certificate for your `HTTPS` website is undoubtfully
with `--preferred-challenges http`, but docker hides the `DOCUMENTROOT` inside its bucket, and
certbot cannot find it there.


## Manual Solution

The solution: add a new volume to your docker, exposing the subdirectory `.well-knwown`!

This will allow you to save the challenge file from certbot to the `DOCUMENTROOT`, but not automatically.

When automatic, certbot will need the real `DOCUMENTROOT`, and it will create the
subdirectories `DOCUMENTROOT/.well-knwown/acme-challenge` and look for the challenge file there.
But you cannot expose via docker the real `DOCUMENTROOT`, only a subpath of it.

So, you can manually copy the challenge file to the correct location using `certbot --manual`.


## Automatic Solution

Now, if you can do it by hand, you can do it automatically! Right?!

Then comes this small software script, using the power of `expect` to read/write to
the standard input/output and fill up the necessary responses for each trigger string.

## TODO and BUGS

### BUGS

There is no known bugs as of today.

### TODO

The software will be updated in the following months when I can access the real output of the certbot program,
doing a real renew.

For now, the only tested thing confirmed working is the creation of the first certificate.

Also, for now, there is a hardcode `PATH` a `DOCUMENTROOT` of a docker image I was working on, so there is that.


## Author and Copyright

* Author: Prof. Dr. Ruben Carlo Benante
* Contact email: rcb at beco.cc
* Data: 2024-04-01
* License: GNU/GPL v2.0


