#!/bin/bash

PACKAGE_NAME=$1

PACKAGE_FILE=$2

PACKAGE_LOCATION=$3

OS_TYPE=$4

SOLR_LOG=$5

function setup_deb() {
    OUTPUT=$(dpkg-query -W --showformat='${Status}\n' $PACKAGE_NAME | grep "install ok")

    if [ "$?" -eq 1 ]; then
        echo $OUTPUT >> $SOLR_LOG
        OUTPUT=$(dpkg -i $PACKAGE_LOCATION$PACKAGE_FILE)
        echo $OUTPUT >> $SOLR_LOG
    else
        echo $OUTPUT >> $SOLR_LOG
        echo "Package $PACKAGE_NAME is already installed, skipping install..." >> $SOLR_LOG
    fi
}

function setup_rpm() {
    OUTPUT=$(rpm -q $PACKAGE_NAME)
    echo $OUTPUT | grep "is not installed"
    if [ "$?" -eq 1 ]; then
        echo $OUTPUT >> $SOLR_LOG
        echo "Package $PACKAGE_NAME is already installed, skipping install..." >> $SOLR_LOG
    else
        echo $OUTPUT >> $SOLR_LOG
        OUTPUT=$(rpm -Uvh $PACKAGE_LOCATION$PACKAGE_FILE)
        echo $OUTPUT >> $SOLR_LOG
    fi
}

function setup_solr() {
    SOLR_LOG_DIR=$(dirname "$SOLR_LOG")
    
    if [ ! -d "$SOLR_LOG_DIR" ]; then
        mkdir -p $SOLR_LOG_DIR
    fi
    
    if [ "$OS_TYPE" == "ubuntu" ]; then
        setup_deb
    else
        setup_rpm
    fi
}

setup_solr