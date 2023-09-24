#!/bin/bash

# Install Java
sudo apt install -y openjdk-17-jre

# Check Java version
echo ""
java -version

# Check all versions of java installed
java_version=$(java -version 2>&1 | grep "openjdk version" | awk '{print substr ($3, 2, 2)}')


if [ "$java_version" -le 11 ]
then
    echo "An older version of Java has been found"
else
    echo "Java version 17 or greater has been found"
fi
