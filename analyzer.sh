#! /bin/bash

CURR_TIME=`date +%s`
SOURCE_FILE=AW_Vs_CM_20220408.csv
RESULT_FILE=AW_Vs_CM_20220408_ckd.csv

# check string value case insensitively
rslt="no result"
check_equal()
{
shopt -s nocasematch
case "$1" in
 $2 ) rslt=1;;
 *) rslt=0;;
esac
}

# processing
LINE=`head -1 $SOURCE_FILE`
echo $LINE > $RESULT_FILE

while IFS="," read -r CM_FIRSTNAME CM_LASTNAME CM_DOB CM_GENDER CM_EMAIL_ID CM_CMRN AW_PATIENT_EMPI AW_PATIENT_SOURCE_ID AW_PRIMARY_SOURCE_ID AW_FIRSTNAME AW_LASTNAME AW_DOB AW_GENDER AW_EMAIL_ID ETC 
do
  LINE="$CM_FIRSTNAME,$CM_LASTNAME,$CM_DOB,$CM_GENDER,$CM_EMAIL_ID,$CM_CMRN,$AW_PATIENT_EMPI,$AW_PATIENT_SOURCE_ID,$AW_PRIMARY_SOURCE_ID,$AW_FIRSTNAME,$AW_LASTNAME,$AW_DOB,$AW_GENDER,$AW_EMAIL_ID,,"
  #echo $LINE
  
  # Processing first name match
  rslt="No Match"
  check_equal $CM_FIRSTNAME $AW_FIRSTNAME
  if [ $rslt == 1 ]
  then
     LINE=$LINE"FirstName matched,"
  else
     LINE=$LINE"FirstName Mismatch,"
  fi

  # Processing last name match
  rslt="No Match"
  check_equal $CM_LASTNAME $AW_LASTNAME
  if [ $rslt == 1 ]
  then
     LINE=$LINE"LastName matched,"
  else
     LINE=$LINE"LasttName Mismatch,"
  fi

  # Processing DoB match
  rslt="No Match"
  
  #cm_dob_raw=$CM_DOB
  cm_dob_chg=`echo ${CM_DOB:0:5}`
  
  check_equal $cm_dob_chg $AW_DOB
  if [ $rslt == 1 ]
  then
     LINE=$LINE"DoB matched,"
  else
     LINE=$LINE"DoB Mismatch,"
  fi

  # Processing Gender match
  rslt="No Match"
  check_equal $CM_GENDER $AW_GENDER
  if [ $rslt == 1 ]
  then
     LINE=$LINE"Gender matched,"
  else
     LINE=$LINE"Gender Mismatch,"
  fi

  echo $LINE >> $RESULT_FILE
done < <(tail -n +2 $SOURCE_FILE)
