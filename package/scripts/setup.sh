#!/bin/bash

PACKAGE_NAME=$1

PACKAGE_FILE=$2

PACKAGE_LOCATION=$3

OS_TYPE=$4

function setup_deb() {
    OUTPUT=$(dpkg-query -W --showformat='${Status}\n' $PACKAGE_NAME | grep "install ok installed")

    if [ "$?" -eq 1 ]; then
        echo $OUTPUT
        OUTPUT=$(dpkg -i $PACKAGE_LOCATION$PACKAGE_FILE)
        echo $OUTPUT
        OUTPUT=$(apt-get install -f)
        echo $OUTPUT

        #double check
        OUTPUT=$(dpkg-query -W --showformat='${Status}\n' $PACKAGE_NAME | grep "install ok installed")
        if [ "$?" -eq 1 ]; then
            echo $OUTPUT
            OUTPUT=$(apt-get install -f)
            echo $OUTPUT
        else
            echo "Package $PACKAGE_NAME successfully installed"
        fi
    else
        echo $OUTPUT
        echo "Package $PACKAGE_NAME already installed, skipping install..."     
    fi
}

function setup_rpm() {
    OUTPUT=$(rpm -q $PACKAGE_NAME)
    echo $OUTPUT | grep "is not installed"
    if [ "$?" -eq 1 ]; then
        echo "Package $PACKAGE_NAME already installed, skipping install..."
    else
        OUTPUT=$(rpm -Uvh $PACKAGE_LOCATION$PACKAGE_FILE)
        echo $OUTPUT
    fi
}

function setup_solr() {
    if [ "$OS_TYPE" == "ubuntu" ]; then
        setup_deb
    else
        setup_rpm
    fi
}

setup_solr