#!/bin/bash

# prompt the user to initialize the data cleaning
echo "Would you like to clean the data? (enter "1" for yes, "0" for no)" 
read cleancontinue

# if user selects 1, then run the cleanse_data script
if [ $cleancontinue -eq 1 ]
then
    echo "Cleaning Data"
    python dev/cleanse_data.py
    echo "Finished Cleaning Data"

    # grab the first line of dev and prod changelogs
    dev_firstline=$(head -n1 dev/changelog.md)
    prod_firstline=$(head -n1 prod/changelog.md)

    # split the strings into arrays
    read -a split_dev_firstline <<< $dev_firstline
    read -a split_prod_firstline <<< $prod_firstline

    # grab the version value at the index 1 of arrays
    dev_version=${split_dev_firstline[1]}
    prod_version=${split_prod_firstline[1]}

    # proceed if the dev_version and prod_version do not match
    if [ $prod_version != $dev_version ]
    then 
        # alert the user and ask before proceeding to move dev files to prod
        echo "New changes are detected. Move dev file to prod? (enter "1" for yes, "0" for no)"
        read scriptcontinue
    else
        scriptcontinue=0
    fi
else
# otherwise, do not run anything
    echo "Come back later."
fi 

# if user selects 1, then copy and move files from dev to prod
if [ $scriptcontinue -eq 1 ]
then
    for filename in dev/*
    do
        if [ $filename == "dev/cademycode_cleansed.db" ] || [ $filename == "dev/cademycode_cleansed.csv" ] || [ $filename == "dev/changelog.md" ]
        then
            cp $filename prod
            echo "Copying " $filename
        else
            echo "Not Copying " $filename
        fi
    done
# otherwise, don't run anything
else
    echo "Come back later."
fi