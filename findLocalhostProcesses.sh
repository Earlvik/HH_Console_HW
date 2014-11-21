#!bin/bash
ps aux | grep -E "^[a-zA-Z]+\s*[1-9][0-9]{4}.*127.0.0.1" | grep -v grep | sort -k 2 -r
exit 0

