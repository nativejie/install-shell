#!/bin/bash
echo '========JRE环境基础检测========'
if type -p java;then
    echo Java安装正常;
    _java=java
#[ -x FILE ] 如果 FILE 存在且是可执行的则为真 [ -n STRING ] 如果STRING的长度非零则为真 ，即判断是否为非空，非空即是真
elif [[ -n $JAVA_HOME ] && [[ -x "$JAVA_HOME/bin/java" ]]];then
    echo 环境变量配置正常;
    _java="$JAVA_HOME/bin/java"
else
    echo 未找到JRE
fi

if [[ "$_java" ]];then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo Version: $version
fi

echo '========JDK环境基础检测========'
if type -p javac; then
    echo Javac安装正常
    _javac=javac  
elif [[ -n $JAVA_HOME ]] && [[ -x "$JAVA_HOME/bin/javac" ]];  then
    echo 环境变量配置正常
    _javac="$JAVA_HOME/bin/javac"
else
    echo "未找到JDK"
    echo "开始安装JDK..."
    yum install java-11-openjdk -y  
fi

echo "========正在创建halo目录========"
mkdir -p /usr/local/halo-app && cd /usr/local/halo-app
echo "halo目录：/usr/local/halo-app"

echo "========下载应用包========"
wget https://dl.halo.run/release/halo-1.4.16.jar -O halo.jar

echo "========创建工作目录========"
mkdir ~/.halo && cd ~/.halo
wget https://dl.halo.run/config/application-template.yaml -O ./application.yaml 
echo "配置文件目录：~/.halo"

echo "========启动服务========"
cd /usr/local/halo-app && java -jar halo.jar
