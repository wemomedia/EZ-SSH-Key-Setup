#!/bin/sh

# This script will make creating an SSH key and adding it to the server you want to communicate with super simple.
# We've reduced it to one command
# Download the code
# Run ./install.sh
# Now you can run "sshkeysetup" command from your terminal and follow the instructions
# After you do this, you'll be able to do this:
# ssh yourname@servername (no password required and it will be super-secure due to use of of SSH keys)
# Boom bitch!

ID_FILE="${HOME}/.ssh/id_rsa.pub"

echo "Provide a passphrase (at least 5 characters).  [default is empty]"

read passphrase

echo "the passphrase you entered is: " $passphrase

echo "Provide the username for the machine"

read username

echo "Provide the password for the machine"

read password

echo "Provide the hostname for the machine"

read hostname

ssh-keygen -t rsa -f "~/.ssh/id_rsa" -N "$test"

# if [ "-i" = "$1" ]; then
#   shift
#   # check if we have 2 parameters left, if so the first is the new ID file
#   if [ -n "$2" ]; then
#     if expr "$1" : ".*\.pub" > /dev/null ; then
#       ID_FILE="$1"
#     else
#       ID_FILE="$1.pub"
#     fi
#     shift         # and this should leave $1 as the target name
#   fi
# else
#   if [ x$SSH_AUTH_SOCK != x ] ; then
#     GET_ID="$GET_ID ssh-add -L | grep -vxF 'The agent has no identities.'"
#   fi
# fi

if [ -z "`eval $GET_ID`" ] && [ -r "${ID_FILE}" ] ; then
  GET_ID="cat ${ID_FILE}"
fi

if [ -z "`eval $GET_ID`" ]; then
  echo "$0: ERROR: No identities found" >&2
  exit 1
fi

# if [ "$#" -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
#   echo "Usage: $0 [-i [identity_file]] [user@]machine" >&2
#   exit 1
# fi

#if [ "$#" -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 [-i [identity_file]] [username@]hostname" >&2
#  exit 1
#fi

{ eval "$GET_ID" ; } | ssh $username@$hostname "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys; test -x /sbin/restorecon && /sbin/restorecon .ssh .ssh/authorized_keys" || exit 1

cat <<EOF
Now try logging into the machine, with "ssh '$1'", and check in:

  .ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.

EOF
