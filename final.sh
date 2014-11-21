#!/bin/bash
fileName=$1
echo "Выберите подзадание:"
echo "1) Найти общее время успешных обращений к /resume, среднее, 95% и 99% квантиль"
echo "2) Найти среднее значение и медиану времени отклика для резюме с id=43"
echo "3) Построить график 95% квантили по времени отклика по /resume, /vacancy и /user"
echo "4) Выход"
read command

case $command in
1)
lines=`grep -E "12:[0-5][0-9]:[0-5][0-9].*/resume.*\s200\s" $fileName | sort -k 8`
SUM=0
NUM=0
for line in $lines; do
if [[ $line == *ms ]]
then
t=${line:0:6};
SUM=`echo $SUM + $t | bc`;
NUM=$((NUM+1));
times[$NUM]=$t;
fi
done;
echo Общее время обращений: $SUM
echo Количество обращений: $NUM
echo Среднее время обращения: `echo $SUM / $NUM | bc`
index95=`echo "$NUM * 0.95 + 1" | bc`;
index95=${index95%.*};
index99=`echo "$NUM * 0.99 +1" | bc`;
index99=${index99%.*};
echo Квантиль 95%: ${times[$index95]}
echo Квантиль 99%: ${times[$index99]}
;;
2)
echo "Введите день в формате гггг-ММ-дд"
read day
echo day: $day
lines=`grep -E "$day.*/resume.*id=43" $fileName | sort -k 8`
SUM=0
NUM=0
for line in $lines; do
if [[ $line == *ms ]]
then
t=${line:0:6};
SUM=`echo $SUM + $t | bc`;
NUM=$((NUM+1));
times[$NUM]=$t;
fi
done;
echo Среднее время обращения: `echo $SUM / $NUM | bc`
index50=`echo "$NUM * 0.5 + 1" | bc`;
index50=${index50%.*};
echo Медиана: ${times[$index50]}

;;
3)
echo "Введите день в формате гггг-ММ-дд"
read day
awk "/$day.*resume/"'{print $1 " " $2 " =duration.resume " $8}' $fileName > logs.trace
awk "/$day.*vacancy/"'{print $1 " " $2 " =duration.vacancy " $8}' $fileName >> logs.trace
awk "/$day.*user/"'{print $1 " " $2 " =duration.user " $8}' $fileName >> logs.trace
tplot -if logs.trace -o graph.png -k duration 'within[.] lines' 
;;
4)
exit 0
;;
*)
echo "Непрвильная команда"
esac
