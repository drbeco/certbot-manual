#!/usr/bin/expect
# drbeco 2024-03-30 version 20240401.193929

set DOMAIN [lindex $argv 0]
set EMAIL [lindex $argv 1]
set DRYRUN [lindex $argv 2]
set RENEW [lindex $argv 3]
set TESTE [lindex $argv 4]
set TYPE [lindex $argv 5]
set timeout 6
if {$TESTE == 0 } {
        # true
        puts "Expect: no test"
        spawn certbot --dry-run $DRYRUN certonly -a manual --preferred-challenges http -d $DOMAIN -m $EMAIL --agree-tos --eff-email
    } else {
        # true
        puts "Expect: testing"
        spawn certbot-manual-simul.sh $DOMAIN $EMAIL $RENEW $TESTE $TYPE
    }

puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n"
sleep 1
expect {

    # if timeout, enter just in case, and exit
	timeout {send -- "\r"}

    # Press Enter to Continue
    -re "Press Enter to Continue" {sleep 6 ; send -- "\r"}

    # "Select the appropriate number [1-2] then [enter] (press 'c' to cancel):" {send -- "2\r"}
    # 1: Keep the existing certificate for now
    # 2: Renew & replace the certificate (may be subject to CA rate limits)
    -re "Select the appropriate number .1.2. then .enter. .press .c. to cancel.:" {
        if { $RENEW == "no" } { send_user "1\n" ; send "1\r" }
        if { $RENEW == "yes" } { send_user "2\n" ; send "2\r" }
    }
}

    # Create a file containing just this data:
    # And make it available on your web server at this URL:
    # Press Enter to Continue
	# "Certbot failed to authenticate some domains" {puts "failed\n"}
	# "The dry run was successful." {puts "ok\n"}

wait


#/* --------------------------------------------------------------------------- */
#/* vi: set ai et ts=4 sw=4 tw=0 wm=0 fo=croql syn=tcl : SH config Vim modeline */
#/* Template by Dr. Beco <rcb at beco dot cc>           Version 20240401.192722 */

