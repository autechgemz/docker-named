#!/usr/bin/env sh

BIND_ROOT=/etc/bind
BIND_DATA=/var/bind

BIND_RNDC_KEY=$BIND_ROOT/rndc.key
if [ ! -f $BIND_RNDC_KEY ]; then
  rndc-confgen -b 512 -a -c $BIND_RNDC_KEY > /dev/null 2>&1
  chmod 0640 $BIND_RNDC_KEY
  chown root.named $BIND_RNDC_KEY
fi

if [ -e $BIND_ROOT/named.conf ]; then
  chmod 0640 $BIND_ROOT/named.conf
  chown root.named $BIND_ROOT/named.conf
  test -e /etc/bind/named.conf.authoritative && rm -f /etc/bind/named.conf.authoritative
  test -e /etc/bind/named.conf.recursive && rm -f /etc/bind/named.conf.recursive
fi

if [ -e $BIND_ROOT/conf.d ]; then
  chmod 0750 $BIND_ROOT/conf.d
  chown root.named $BIND_ROOT/conf.d
  find $BIND_ROOT/conf.d -type f -exec chmod 0640 {} \;
  find $BIND_ROOT/conf.d -type f -exec chown root.named {} \;
fi

if [ -d $BIND_DATA ]; then
  chmod g+s $BIND_DATA
fi

if [ -e $BIND_DATA/pri ]; then
  chmod 0770 $BIND_DATA/pri
  chown root.named $BIND_DATA/pri
  find $BIND_DATA/pri -type f -exec chmod 0660 {} \;
  find $BIND_DATA/pri -type f -exec chown root.named {} \;
fi

if [ -L /var/bind/named.ca ]; then
  rm -f /var/bind/named.ca
  if [ ! -f /var/bind/named.ca ]; then
    cp /usr/share/dns-root-hints/named.root /var/bind/named.ca
    chmod 0640 /var/bind/named.ca
    chown root.named /var/bind/named.ca
  else
    chmod 0640 /var/bind/named.ca
    chown root.named /var/bind/named.ca
  fi
fi

if [ -L /var/bind/root.cache ]; then
  rm -f /var/bind/root.cache
fi

/usr/sbin/rsyslogd &&
exec /usr/sbin/named -u named -f
