#!/bin/bash
# vb is not visualbasic you kekos                        # visualbasic is microsoft crap
# its view browser (FIrEFoX excusive)
# it opens current git repo on github                    # github totally not owned by microsoft xd
# yes only github no gitlab or bitbucket or what ever
# well only tested on github might work with other hubs as well

#           sub sub shell shiet!! 
#                     \_____
#                           \
#                           V
remote=$(git remote get-url $(git remote | head -n1))
url=$remote

if [[ $remote =~ ^git@ ]]
then
    echo "'$remote' is a ssh remote"
    nocolon=${remote/:/\/}
    url="https://${nocolon##*@}"
    echo "converted to url '$url'"
elif [[ $remote =~ ^https ]]
then
    echo "'$remote' is a https remote"
else
    echo "invalid remote '$remote"
    exit 1
fi

if [ "$(uname)" == "Darwin" ]
then
    open -a Safari $url
else
    firefox $url &
fi

