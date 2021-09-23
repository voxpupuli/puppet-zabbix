# @summary This class can be used when you use hiera or The Foreman. With this tools you can't use and define. This make use of "create_resources".
# @param data This is the data in YAML format
# @example
#   zabbix::userparameter::data:
#     MySQL:
#       content: UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive
# @author Werner Dijkerman <ikben@werner-dijkerman.nl>
class zabbix::userparameter (
  Hash $data = {},
) {
  $_data = hiera_hash('zabbix::userparameter::data', $data)
  $_data.each |$key,$value| {
    zabbix::userparameters { $key:
      * => $value,
    }
  }
}
