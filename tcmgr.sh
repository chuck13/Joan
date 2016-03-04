#!/bin/sh
export APP_HOME="/var/srv"
export CATALINA_HOME=/opt/tomcat/apache-tomcat-8.0.30
case "$1" in
   *new)
        if [ -d "$APP_HOME/$2" ]; then
	    echo $APP_HOME/$2 exists.
	    exit 3
	else
	    inst_dir=$APP_HOME/$2
            mkdir $inst_dir
	    mkdir $inst_dir/bin
	    mkdir $inst_dir/logs
	    mkdir $inst_dir/webapps
	    mkdir $inst_dir/conf
	    mkdir $inst_dir/temp
	    cp $CATALINA_HOME/conf/server.xml $inst_dir/conf/server.xml
	    cp $CATALINA_HOME/conf/web.xml $inst_dir/conf/web.xml
	    cp $CATALINA_HOME/conf/context.xml $inst_dir/conf/context.xml
	    cp $CATALINA_HOME/conf/catalina.properties $inst_dir/conf/catalina.properties
        fi
	exit 1
        ;;
   *run)
	for d in $APP_HOME/* ; do
	# Check for directory
        [ -d "$d" ] || continue

        # Get the subsystem name.
        subsys=${d#$APP_HOME/*}
        echo $subsys
        # Networking could be needed for NFS root.
        [ $subsys = network ] && continue
        # Bring the subsystem down.
        if [ $d = "$APP_HOME/"$2 ]; then
                export CATALINA_BASE=$d
                $CATALINA_HOME/bin/startup.sh
        fi
	done
        ;;
   *bye)
	for d in $APP_HOME/* ; do
        # Check for directory
        [ -d "$d" ] || continue

        # Get the subsystem name.
        subsys=${d#$APP_HOME/*}
        echo $subsys
        # Networking could be needed for NFS root.
        [ $subsys = network ] && continue
	echo shit not here
	echo before 35 $d,,,,$APP_HOME/$2
        # Bring the subsystem down.
        if [ $d == "$APP_HOME/$2" ]; then
                export CATALINA_BASE=$d
                $CATALINA_HOME/bin/shutdown.sh
        fi
        done
	;;
   *see)
	tail -f $APP_HOME/$2/logs/catalina.out
	exit 1
	;;
   *)
        echo $"Usage: $0 {command} {nodename} "
        exit 1
        ;;
esac

