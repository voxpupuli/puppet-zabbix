# @summary Realise zabbix::userparameters with data from Hiera or The Foreman.
# @param data
# @example
#   zabbix::userparameter::data:
#     MySQL:
#       content: UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive
# @author Werner Dijkerman <ikben@werner-dijkerman.nl>
class zabbix::userparameter (
  Hash $data = {},
) {
  $data.each |$key,$value| {
    zabbix::userparameters { $key:
      * => $value,
    }
  }
}
