# crools
**cr**ap t**ools**. Don't even bother.

No actually these cruel tools are actually a waste of time.
(im totally not hiding any secret information here)

## it started as a meme and became my daily driver

These scripts are a mess but without this repo in my PATH I would struggle a lot nowerdays.

## quick overview

Most of the scripts are just simple wrappers around common cli tools.

Most of the scripts work as standalones but all share the same ``~/.config/crools`` config path.
Also ``crools_find_editor`` is a dependency in some other scripts. The ``~/.config/crools/zzh.cnf`` file holds some ssh remotes used by the zzh command but the first entry is marked as the favorite ssh (user/host) where images and videos get uploaded to by ``crapshot`` and ``opentube``.

My zzh.cnf looks like this:
```
# zzh - config
# store your fav ssh commands here
ssh favuser@zillyhuhn.com
ssh foo@other-server.de
ssh -t favuser@zillyhuhn.com "cd /var/www/html/OpenTube; bash"
ssh otheruser@zillyhuhn.com
ssh otheruser2@zillyhuhn.com
ssh otheruser3@razerpro
ssh otheruser4@zillyhuhn.com
```

## my favorite ones

### zzh

It literally replaced ssh for me. The script it self actually has nothing todo with ssh and it just evals any selected lines from the zzh.cnf but I use it for my ssh connections. Just enter all your most used ssh connections in ``zzh --edit`` and when firing up ``zzh`` you will be prompted with a menu:

```
$ zzh
1) ssh favuser@zillyhuhn.com 2) ssh foo@other-server.de
Select ssh connection: 
```

### irc

Just opens my ``weechat`` screen or creates it. Used to be local now is essentially a ``zzh`` alternative and expects a screen running on your favorite remote (first zzh.cnf entry).

### qq

I tried a bunch of tools to remote control second devices without too much success. And ``qq`` works fine enough so it was a daily driver for some weeks. Essentially it is yet another ``zzh`` similarity that just executes shell code you provide. But this time it is more explicitly generic as the name qq stands for quick command. It does not select you between multiple shell lines but it takes a whole script. So to initially set a script that gets executed do ``qq --edit``.
My ``~/.config/crools/qq.cnf`` that lets me open firefox tabs on second device from copybuffer:

```
#!/bin/bash
function os_paste() {
    if [ "$(uname)" == "Darwin" ]
    then
        pbpaste
    else
        xsel -b
    fi
}
clip="$(os_paste)"
if ! [[ "$clip" =~ ^http ]]
then
    echo "WARNING CLIPBOARD IS NO URL:"
    echo "$clip"
    echo "Do you want to continue? [y/N]"
    read -r -n 1 yn
    echo ""
    if [[ ! "$yn" =~ [yY] ]]
    then
        echo "Aborting ..."
        exit 0
    fi
fi
ssh user@seconddevice "export DISPLAY=:1;firefox $clip"
```

### cplay

cplay originally was in a different repo because I thought it was too useful for crools. But that repo did not end up in my PATH so I moved cplay in here. Especially after messing around with scripting languages like bash,ruby and python I got used to quickly spin up ``a command lol,irb,python`` and test things before including them into my big project where testing might require expensive context spinups. Since I did not find any good C/C++ interpreters I decided to build ``cplay`` which quickly spins up a temporary c enviroment. This heavily depends on a solid vim config with nice c compiler shortcuts to be efficent.

Just type in ``cplay`` and get cracking! After closing file is in /tmp and will probably be deleted by your os on reboot. If you want to return or list do ``cplay <filename>`` get a list from ``cplay --list``.

### vb

Wanna browse the repo you currently work on in your terminal on the web (github/gitlab)?

I thing together with ``zzh`` this boi kick started this repositorys career!!! It looks at ``git remote`` and opens a browser. It prefers origin and also tries to be smart about the browser.

It is tested on macOS and linux and works fine with github and gitlab.

### bstd, opentube, crapshot, kl

wrappers around by paste tool based on pstd https://paste.zillyhuhn.com, cli uploader for my video site, selfhosted image service, launch openshot-qt form source and wrapper around python keylogger.


All these wrappers are great for me but depend on specific paths, cli dependencys and server setups.

### fear

Lmao I used it often enough to list it here. To clear screen in tmux before creating a yt video. Is there a better way? SURE!
