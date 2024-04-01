#!/bin/bash
# certbot-manual-simul.sh : simulates certbot input/output, for debug purposes
# drbeco 20240401 version 20240401.193929
#
# TODO: simulate renewnow, when due for renewal
# TODO: add second part of Renew

if [ "$5" == "new" ] ; then
	# simulate new certificate

cat <<EOF
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Simulating renewal of an existing certificate for example.domain.ext

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Create a file containing just this data:

cnon8ur12345678zhHqb2byouW25xaXS-NGlb7QDFng.Jszdzu1UxG6LoxPx0K8lA0CSu_gZwK275big123456M

And make it available on your web server at this URL:

http://example.domain.ext/.well-known/acme-challenge/cnon8ur12345678zhHqb2byouW25xaXS-NGlb7QDFng

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
EOF
	read $VAR
	echo The dry run was successful.

else
	# simulate renew (2) or not (1) a certificate
	if [ "$5" == "renewlater" ] ; then #else renewnow

cat <<EOF
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Certificate not yet due for renewal

You have an existing certificate that has exactly the same domains or certificate name you requested and isn't close to expiry.
(ref: /etc/letsencrypt/renewal/example.domain.ext.conf)

What would you like to do?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: Keep the existing certificate for now
2: Renew & replace the certificate (may be subject to CA rate limits)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-2] then [enter] (press 'c' to cancel):
EOF

	else # renewnow (it is due to renew)

cat <<EOF
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Certificate IS due for renewal (this message is not confirmed)

You have an existing certificate that has exactly the same domains or certificate name you requested and isn't close to expiry.
(ref: /etc/letsencrypt/renewal/example.domain.ext.conf)

What would you like to do?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: Keep the existing certificate for now
2: Renew & replace the certificate (may be subject to CA rate limits)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-2] then [enter] (press 'c' to cancel):
EOF

	fi

	read $var
	if [ $var -ne 1 ] && [ $var -ne 2] ; then
		echo '** Invalid input **'
		echo 'Select the appropriate number [1-2] then [enter] (press 'c' to cancel):'
	fi
fi


#/* -------------------------------------------------------------------------- */
#/* vi: set ai et ts=4 sw=4 tw=0 wm=0 fo=croql syn=sh : SH config Vim modeline */
#/* Template by Dr. Beco <rcb at beco dot cc>          Version 20190318.122053 */

