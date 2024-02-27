#!/usr/bin/env zsh

pkill  ags

log="/tmp/ags.log"

# Launch ags
echo ""
echo "(づ ￣ ³￣)づ remember when one-liners were cool?" | tee -a /tmp/ags.log
ags 2>&1 | tee -a $log & disown
echo ""
echo "launching ags, logs at $log, errors to follow:"
echo " yes, there will be errors"
echo ""