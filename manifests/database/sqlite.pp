# == Class: zabbix::database::sqlite3
#
#  This is a dummy helper class to handle sqlite database installations
#  zabbix will automatically create a sqlite schema if one does not
#  already exist.
#
#  Please note:
#  This class will be called from zabbix::database. No need for calling
#  this class manually.
#
# === Authors
#
# Author Name: mjackson@equalexperts.com
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::database::sqlite () { }