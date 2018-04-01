#!/bin/bash
set -e

PASSWORD=${PASSWORD:-password}
WEBMIN=${WEBMIN:-true}

BIND_DATA=${DATA_DIR}/bind
WEBMIN_DATA=${DATA_DIR}/webmin

create_bind_data_dir() {
  mkdir -p ${BIND_DATA}

  # populate default bind configuration if it does not exist
  if [ ! -d ${BIND_DATA}/etc ]; then
    mv /etc/bind ${BIND_DATA}/etc
  fi
  rm -rf /etc/bind
  ln -sf ${BIND_DATA}/etc /etc/bind
  chmod -R 0775 ${BIND_DATA}
  chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA}

  if [ ! -d ${BIND_DATA}/lib ]; then
    mkdir -p ${BIND_DATA}/lib
    chown ${BIND_USER}:${BIND_USER} ${BIND_DATA}/lib
  fi
  rm -rf /var/lib/bind
  ln -sf ${BIND_DATA}/lib /var/lib/bind
}

create_webmin_data_dir() {
  mkdir -p ${WEBMIN_DATA}
  chmod -R 0755 ${WEBMIN_DATA}
  chown -R root:root ${WEBMIN_DATA}

  # populate the default webmin configuration if it does not exist
  if [ ! -d ${WEBMIN_DATA}/etc ]; then
    mv /etc/webmin ${WEBMIN_DATA}/etc
  fi
  rm -rf /etc/webmin
  ln -sf ${WEBMIN_DATA}/etc /etc/webmin
}

set_root_passwd() {
  echo "root:$PASSWORD" | chpasswd
}

create_pid_dir() {
  mkdir -m 0775 -p /var/run/named
  chown root:${BIND_USER} /var/run/named
}

create_bind_cache_dir() {
  mkdir -m 0775 -p /var/cache/bind
  chown root:${BIND_USER} /var/cache/bind
}

create_pid_dir
create_bind_data_dir
create_bind_cache_dir

# allow arguments to be passed to named
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == named || ${1} == $(which named) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch named
if [[ -z ${1} ]]; then
  if [ "${WEBMIN}" == "true" ]; then
    create_webmin_data_dir
    set_root_passwd
    echo "Starting webmin..."
    /etc/init.d/webmin start
  fi

  echo "Starting named..."
  exec $(which named) -u ${BIND_USER} -g ${EXTRA_ARGS}
else
  exec "$@"
fi
