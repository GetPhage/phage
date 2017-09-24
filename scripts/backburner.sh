#!/usr/bin/env bash

# based on puma from  https://gist.github.com/sudara/8653130

# This monit wrapper script will be called by monit as root
# Edit these variables to your liking

RAILS_ENV=production
RACK_ENV=production
USER=phage
APP_DIR=/home/phage/phage/current
SHARED_DIR=/home/phage/phage/shared
BACKBURNER_PID_FILE=$SHARED_DIR/tmp/pids/backburner.pid

# check if backburner process is running
backburner_is_running() {
    if [ -e $BACKBURNER_PID_FILE ] ; then
      if cat $BACKBURNER_PID_FILE | xargs pgrep -P > /dev/null ; then
        return 0
      else
        echo "No backburner process found"
      fi
    else
      echo "No backburner pid file found"
    fi

  return 1
}

stop_backburner() {
  if backburner_is_running ; then
    /bin/su - $USER -c "cd $APP_DIR && RAILS_ENV=$RAILS_ENV bundle exec backburner -k -P $BACKBURNER_PID_FILE"
  fi
}

start_backburner() {
    if backburner_is_running ; then
	echo "backburner is already running"
	return
    fi

    echo "cd $APP_DIR && RAILS_ENV=$RAILS_ENV bundle exec backburner -d -P $BACKBURNER_PID_FILE -l $SHARED_DIR/log/backburner.log"
    /bin/su - $USER -c "cd $APP_DIR && RAILS_ENV=$RAILS_ENV bundle exec backburner -d -P $BACKBURNER_PID_FILE -l $SHARED_DIR/log/backburner.log"
}

case "$1" in
  start)
    echo "Starting backburner..."

    start_backburner

    echo "done"
    ;;

  stop)
    echo "Stopping backburner..."
      stop_backburner
      rm -f $BACKBURNER_PID_FILE

    echo "done"
    ;;

  restart)
    if backburner_is_running ; then
      echo "Hot-restarting backburner..."
      stop_backburner
      sleep 15

      start_backburner

      echo "Doublechecking the process restart..."
      if backburner_is_running ; then
        echo "done"
        exit 0
      else
        echo "Backburner restart failed :/"
      fi
    fi
    ;;
  

  *)
    echo "Usage: backburner {start|stop|restart}" >&2
    ;;
esac
