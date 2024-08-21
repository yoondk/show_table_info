#!/bin/bash

QUERY_1=" SELECT trim(schemaname), trim(relname),n_live_tup AS total, seq_scan, idx_scan, n_tup_ins AS ins, n_tup_upd AS upd, n_tup_del AS del, \
       	         n_dead_tup AS dead_tup, TO_CHAR(last_vacuum , 'YYYY-MM-DD HH24:MI:SS') AS LAST_TIME_VACUUM , \
	         TO_CHAR(last_autovacuum , 'YYYY-MM-DD HH24:MI:SS') AS LAST_TIME_AUTOVACUUM \
          FROM   pg_stat_user_tables order by seq_scan desc , total  desc ; "
QUERY_2=" select schemaname , relname , indexrelname , idx_scan , idx_tup_fetch from pg_stat_user_indexes order by relname  ; "

if [ $# -ne 1 ]; then
   echo "   argument error "
   echo "   ex) $0 table"
   echo "       $0 index"
   exit 1
fi

if [ $1 == "table" ]; then
   QUERY=$QUERY_1
   TITLE="TABLE"
elif [ $1 == "index" ]; then
   QUERY=$QUERY_2
   TITLE="INDEX"
else
   echo "ERROR : $QUERY "
   exit
fi

function jumpto
{
   label="start"
   cmd=$(sed -n "/#$label:/{:a;n;p;ba};" $0 | grep -v ':$')
   eval "$cmd"
   exit
}

start=${1:-"start"}
jumpto $start
#start:
clear

echo ""
echo "==================================================================="
echo "     $TITLE INFORMATION   "
echo "==================================================================="
echo "                                                                   "
echo "     1. ADI                                                      "
echo "                                                                   "
echo "     2. BSI                                                       "
echo "                                                                   "
echo "     3. DSR                                                      "
echo "                                                                   "
echo "     4. GIS                                                       "
echo "                                                                   "
echo "     5. OPT                                                      "
echo "                                                                   "
echo "     0. EXIT                                                      "
echo "                                                                   "
echo "==================================================================="
echo ""
echo -n "Input server [1..5] or 0 :  "
read  num
echo ""

case $num in
   1)
   echo "=====ADI Server ===============================================================";
   echo " " ;
   asql -U usr_xxx -d adi -h xxx.xxx.xxx.xxx -p 5432 -c " $QUERY "
   echo " " ;
   read -s -n1 -p "press any key to continue.. "
   jumpto 
   ;;

   2)
   echo "=====BSI Server ===============================================================";
   echo " " ;
   asql -U usr_xxx -d bsi -h xxx.xxx.xxx.xxx -p 5432 -c " $QUERY "
   echo " " ;
   read -s -n1 -p "press any key to continue.. "
   jumpto 
   ;;

   3)
   echo "=====DSR Server ===============================================================";
   echo " " ;
   asql -U usr_xxx -d dsr -h xxx.xxx.xxx.xxx -p 5432 -c " $QUERY "
   echo " " ;
   read -s -n1 -p "press any key to continue.. "
   jumpto 
   ;;

   4)
   echo "=====GIS Server ===============================================================";
   echo " " ;
   asql -U usr_xxx -d gis -h xxx.xxx.xxx.xxx -p 5432 -c " $QUERY "
   echo " " ;
   read -s -n1 -p "press any key to continue.. "
   jumpto 
   ;;

   5)
   echo "=====OPT Server ===============================================================";
   echo " " ;
   asql -U usr_xxx -d opt -h xxx.xxx.xxx.xxx -p 5432 -c " $QUERY "
   echo " " ;
   read -s -n1 -p "press any key to continue.. "
   jumpto 
   ;;

   0)
   echo "Exit,  Bye...."
   echo ""
   exit
   ;;

   *)
   echo "Input error: Choose the number [1..5]"
   sleep 1
   jumpto 
   ;;
esac

### end of file
