#!/bin/bash -ef

if [ "$CIRCLE_BRANCH" == "main" ] || [[ $(cat gitlog.txt) == *"[circle full]"* ]]; then
    echo "Doing a full dev build";
    echo html > build.txt;
else
    echo "Doing a partial build";
    FNAMES=$(git diff --name-only $(git merge-base $CIRCLE_BRANCH upstream/main) $CIRCLE_BRANCH);
    echo FNAMES="$FNAMES";
    for FNAME in $FNAMES; do
        if [[ `expr match $FNAME "\(tutorials\|examples\)/.*plot_.*\.py"` ]] ; then
            echo "Checking example $FNAME ...";
            PATTERN=`basename $FNAME`"\\|"$PATTERN;
        fi;
    done;
    echo PATTERN="$PATTERN";
    if [[ $PATTERN ]]; then
        PATTERN="\(${PATTERN::-2}\)";
        echo html_dev-pattern > build.txt;
    else
        echo html > build.txt;
    fi;
fi;
echo "$PATTERN" > pattern.txt;
