#!/bin/bash
find . -name "*.java" | xargs grep -L "import ru.hh.deathstar" > almost_harmless.txt
exit 0
