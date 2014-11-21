#!/bin/bash
find -name "*.log" | xargs grep -li "error" | tee filesinfo.txt  | xargs wc -c

