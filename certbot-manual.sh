#!/bin/bash
### BEGIN INIT INFO
# Title: certbot-manual.sh
# Provides: certbot-manual.sh
# Requires: certbot-manual-expect.sh, certibot-manual-simul.sh
# Required-Start:
# Required-Stop:
# Should-Start:
# Should-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Renew certficate SSL https issued manually
# License: GNU GENERAL PUBLIC LICENSE Version 2
# Author: Ruben Carlo Benante <rcb@beco.cc>
# Date: 2024-03-30
# Version: 20240330.171224
# Usage: certbot-manual.sh -d domain -e email -r
# bash_version: GNU bash, version 4.2.37(1)-release (x86_64-pc-linux-gnu)
### END INIT INFO

# **************************************************************************
# * (C)opyright 2024         by Ruben Carlo Benante     v20240401.193929   *
# *                                                                        *
# * This program is free software; you can redistribute it and/or modify   *
# *  it under the terms of the GNU General Public License as published by  *
# *  the Free Software Foundation version 2 of the License.                *
# *                                                                        *
# * This program is distributed in the hope that it will be useful,        *
# *  but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *  GNU General Public License for more details.                          *
# *                                                                        *
# * You should have received a copy of the GNU General Public License      *
# *  along with this program; if not, write to the                         *
# *  Free Software Foundation, Inc.,                                       *
# *  59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
# *                                                                        *
# * Contact author at:                                                     *
# *  Ruben Carlo Benante                                                   *
# *  rcb@beco.cc                                                           *
# **************************************************************************
#
# HELP from certbot manual:
# https://eff-certbot.readthedocs.io/en/latest/using.html#manual
#
# Certificates created using --manual do not support automatic renewal
# To manually renew a certificate using --manual without hooks,
# repeat the same certbot --manual command you used to create
# the certificate originally.

Help()
{
    cat << EOF
    certbot-manual - Renew certficate SSL https issued manually
    Usage: ${0} [-h|-V] | [-v|-n|-t DEBUGTYPE] -d domain -e email [-r]

    Options:
      -h, --help       Show this help.
      -V, --version    Show version.
      -v, --verbose    Turn verbose mode on (cumulative).
      -n, --dry-run    Do not issue the certificate, just test
      -t <DEBUGTYPE>   Set debug for test ( DEBUGTYPE: new, renewnow or renewlater)

      -d <DOMAIN>      Set the domain name
      -e <EMAIL>       Set the email
      -r, --renew      Answer positively for renew questions, otherwise keep it

    Exit status:
       0, if ok.
       1, some error occurred.

    Todo:
            Long options not implemented yet.
    Author:
            Written by Ruben Carlo Benante <rcb@beco.cc>

EOF
    exit 1
}

Copyr()
{
    echo 'certbot-manual - version 20240401.193929'
    echo
    echo 'Copyright (C) 2024 Ruben Carlo Benante <rcb@beco.cc>, GNU GPL version 2'
    echo '<http://gnu.org/licenses/gpl.html>. This  is  free  software:  you are free to change and'
    echo 'redistribute it. There is NO WARRANTY, to the extent permitted by law. USE IT AS IT IS. The author'
    echo 'takes no responsability to any damage this software may inflige in your data.'
    echo
    exit 1
}

# Starting at main function
main()
{
    verbose=0
	domain=""
    email=""
    dryrun="-v"
    renew="no"
    teste=0
    debugtype="new" # types new, renewnow, renewlater
    while getopts "hVvd:e:nrt:" FLAG; do
        case $FLAG in
            h)
                Help
                ;;
            V)
                Copyr
                ;;
            v)
                let verbose=verbose+1
                ;;
            d)
				domain=$OPTARG
                ;;
            e)
				email=$OPTARG
                ;;
            r)
                renew="yes"
                ;;
            n)
                dryrun="--dry-run"
                ;;
            t)
                teste=1
				debugtype=$OPTARG
                ;;
            *)
                Help
                ;;
        esac
    done

    if [ -z "$domain" ] ; then
        Help
    fi
    if [ -z "$email" ] ; then
        Help
    fi

    echo Starting certbot-manual.sh script, by drbeco, version 20240330.171224...
    if [ $verbose -gt 0 ] ; then
        echo Verbose level: $verbose
        echo "Domain: $domain"
        echo "Email: $email"
        echo "Renew: $renew"
    fi
    if [[ "$dryrun" == "--dry-run" ]] ; then
        if [ $verbose -gt 0 ] ; then
            echo "Dry-run: yes"
        fi
    fi
    if [ $teste -eq 1 ] ; then
        echo "Test: yes"
        echo "Debug type: $debugtype"
        echo "Command: /usr/local/bin/certbot-manual-expect.sh $domain $email $dryrun $renew $teste $debugtype"
        # exit 1
    fi

    NEXT=-500
    while read -r LIN ; do
        let NEXT=NEXT+1
        echo "$LIN"
        if [[ "$LIN" =~ ^(.*Create a file containing just this data.*)$ ]] ; then
            NEXT=0
        fi
        if [[ "$NEXT" -eq 2 ]] ; then
            TOKEN=$(echo ${LIN//[$'\t\r\n']})
            FILE=$(echo ${TOKEN%\.*})
            echo $TOKEN >> /srv/docker/root/volumes/taiga-docker_taiga-certbot-data/_data/acme-challenge/$FILE
        fi
    done < <(/usr/local/bin/certbot-manual-expect.sh $domain $email $dryrun $renew $teste $debugtype)
    sleep 1
    if [ $verbose -gt 0 ] ; then
        echo 'Removing token files from acme-challenge'
    fi
    rm -f /srv/docker/root/volumes/taiga-docker_taiga-certbot-data/_data/acme-challenge/*

    if [ $verbose -gt 0 ] ; then
        echo "Expect a success"
    fi
	exit 0
    echo Bye main
}

main "$@"
echo Bye script
exit 0

#/* -------------------------------------------------------------------------- */
#/* vi: set ai et ts=4 sw=4 tw=0 wm=0 fo=croql syn=sh : SH config Vim modeline */
#/* Template by Dr. Beco <rcb at beco dot cc>          Version 20190318.122053 */


