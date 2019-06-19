#!/usr/bin/env bash
#
# Provides      : Check if a file is changed
# 

#Path of file that we want to check
file=/home/hostadmin/Desktop/so/raports/raport1.txt

# path to file's saved md5sum
# I did not spend much effort in naming this file
# if you have to test multiple files
# so just use a commandline option and use the given
# file name like: filename=$(basename "$file")
fingerprintfile=/tmp/.bla.md5savefile


echo "FIle Comparator Start - Generating Raport"
sudo  mysql --defaults-file=/etc/mysql/debian.cnf -Dsecurityonion_db -e 'SELECT timestamp, signature FROM event order by timestamp desc limit 40;' > /home/hostadmin/Desktop/so/raports/raport1.txt

# does the file exist?
if [ ! -f $file ]
    then
        echo "ERROR: $file does not exist - aborting"
    exit 1
fi

# create the md5sum from the file to check
# cut print selected part of lines from file to standard output
filemd5=`md5sum $file | cut -d " " -f1`

# check the md5 and
# show an error when we check an empty file
if [ -z $filemd5 ]
    then
        echo "The file is empty - aborting"
        exit 1
    else
        # pass silent
        :
fi

# do we have allready an saved fingerprint of this file?
if [ -f $fingerprintfile ]
    then
        # yup - get the saved md5
        savedmd5=`cat $fingerprintfile`

        # check again if its empty
        if [ -z $savedmd5 ]
            then
                echo "The file is empty - aborting"
                exit 1
        fi

        #compare the saved md5 with the one we have now
        if [ "$savedmd5" = "$filemd5" ]
            then
                # pass silent
                :
            else
                echo "File has been changed sendingg mail"
                cat $file | mailx -s "Raport Attack Changed" root@localhost

                echo 
        fi

fi

# save the current md5
echo $filemd5 > $fingerprintfile