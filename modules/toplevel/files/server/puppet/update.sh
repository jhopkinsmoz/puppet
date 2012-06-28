#! /bin/bash

errormailto="release@mozilla.com"
changemailto="release@mozilla.com"
repo="http://hg.mozilla.org/build/puppet"

hostname=`hostname -s`
cd /etc/puppet/production

# check for uncommitted changes
output=`/usr/bin/hg stat`
if [ -n "$output" ]; then
    (
        echo "Uncommitted local changes to $hostname:/etc/puppet/production!"
        echo ''
        echo $output
    ) | mail -s "[PuppetAgain Errors] Uncommitted local changes in $hostname:/etc/puppet/production" $errormailto
    exit 1
fi

try_update() {
    rev_before=`/usr/bin/hg ident -i`
    rev_current=`/usr/bin/hg ident -i $repo`
    if [ $? -ne 0 ] || [ -z "$rev_current" ]; then
        return 1
    fi

    if [ $rev_before == $rev_current ]; then
        # nothing to do
        return 0
    fi

    # update (and pass on the exit status)
    /usr/bin/hg pull -u
}

# retry that five times
LOGFILE=$(mktemp)
ok=false
for try in {1..5}; do
    if try_update >> $LOGFILE 2>&1; then
        ok=true
        break
    else
        # don't sleep too long, or we'll overlap the next crontask
        sleep 1
    fi
    echo '' >> $LOGFILE
done

if ! $ok; then
    (
        echo "Errors pulling from mercurial for puppet on $hostname:"
        echo ''
        cat $LOGFILE
    ) | mail -s "[PuppetAgain Errors] Errors pulling from mercurial for puppet on $hostname" $errormailto
else
    # get a new rev, in case something landed during this run
    rev_after=`/usr/bin/hg ident -i`
    if [ $rev_before != $rev_after ]; then
        (
            echo "Puppet changes applied at $hostname:"
            echo ''
            hg diff -r $rev_before -r $rev_after
        ) | mail -s "[PuppetAgain Changes] Puppet changes applied at $hostname" $changemailto
    fi
fi

rm -f $LOGFILE
