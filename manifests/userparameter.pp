# == Class: zabbix::userparameter
#
# This class can be used when you use hiera or The Foreman. With this tools
# you can't use and define. This make use of "create_resources".
#
# == Requirements
#
# Hiera or The Foreman
#
# == Parameters
#
# [*data*]
#  This is the data in YAML format
#
# == Example
#
# zabbix::userparameter::data:
#  MySQL:
#    content: UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive
#
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#

class zabbix::userparameter (
  $data = {},
) {
  $_data = hiera_hash('zabbix::userparameter::data', $data)
  validate_hash($_data)
  create_resources('zabbix::userparameters', $_data)
}