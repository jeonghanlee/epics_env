#!/bin/bash

target=$1

mkdir ${target}
cd ${target}
makeBaseApp.pl -t ioc ${target}
makeBaseApp.pl -i -t ioc ${target}
