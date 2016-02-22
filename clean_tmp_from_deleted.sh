#!/bin/bash
# One liner prints deleted files on tmp partitions and kill processes 
# which still holding these files. As the result it frees up disk space on tmp partition

p=$( lsof /tmp/ | grep "(deleted)" | awk '{print $2}' | uniq )
kill $p