#!/bin/bash
HPCGATE_DIRECT="astral.central.cranfield.ac.uk 
                hpclogin-1.central.cranfield.ac.uk 
                hpclogin-2.central.cranfield.ac.uk 
                grid.central.cranfield.ac.uk 
                senbazuru-01.soe.cranfield.ac.uk 
                senbazuru-02.soe.cranfield.ac.uk"

HOST=$1
PORT=$2
if ip addr show | perl -ane 'print "$F[1]\n" if ($F[0] eq "inet")' | grep -qe "^138.250"; then
    nc -q0 ${HOST} ${PORT}
elif [[ "${HPCGATE_DIRECT}" =~ "${HOST}" ]]; then
    SSHPASS=$(keyring get "all" "p003395@cranfield.ac.uk") sshpass -e \
        ssh -q hpcgate \
        "/bin/bash -c 'exec 3<>/dev/tcp/${HOST}/${PORT}; cat <&3 & cat >&3'"
else
    ssh -q astral netcat ${HOST} ${PORT}
fi
