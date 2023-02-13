# @summary This will create resources into puppetdb for automatically configuring agent into zabbix front-end.
# @param hostname Hostname of the machine
# @param ipaddress The IP address of the machine running zabbix agent.
# @param use_ip Use ipadress instead of dns to connect.
# @param port The port that the zabbix agent is listening on.
# @param group *Deprecated* (see groups parameter) Name of the hostgroup.
# @param groups An array of groups the host belongs to.
# @param group_create Whether to create hostgroup if missing.
# @param templates List of templates which should be attached to this host.
# @param macros Array of hashes (macros) which should be attached to this host.
# @param proxy Whether it is monitored by an proxy or not.
# @param interfacetype Internally used identifier for the host interface.
# @param interfacedetails Hash with interface details for SNMP when interface type is 2.
# @param tls_connect How the server must connect to the agent
# @param tls_accept How the agent can connect to the server
# @param tls_issuer Issuer of the certificate that is allowed to talk with the serve
# @param tls_subject Subject of the certificate that is allowed to talk with the server
class zabbix::resources::agent (
  $hostname                           = undef,
  $ipaddress                          = undef,
  $use_ip                             = undef,
  $port                               = undef,
  $group                              = undef,
  Array[String[1]] $groups            = undef,
  $group_create                       = undef,
  $templates                          = undef,
  $macros                             = undef,
  $proxy                              = undef,
  $interfacetype                      = 1,
  Variant[Array, Hash] $interfacedetails = [],
  Optional[Enum['unencrypted','psk','cert']] $tls_connect = undef,
  Optional[Enum['unencrypted','psk','cert']] $tls_accept  = undef,
  Optional[String[1]] $tls_issuer                         = undef,
  Optional[String[1]] $tls_subject                        = undef,
) {
  if $group and $groups {
    fail("Got group and groups. This isn't support! Please use groups only.")
  } else {
    if $group {
      warning('Passing group to zabbix::resources::agent is deprecated and will be removed. Use groups instead.')
      $_groups = Array($group)
    } else {
      $_groups = $groups
    }
  }

  @@zabbix_host { $hostname:
    ipaddress        => $ipaddress,
    use_ip           => $use_ip,
    port             => $port,
    groups           => $_groups,
    group_create     => $group_create,
    templates        => $templates,
    macros           => $macros,
    proxy            => $proxy,
    interfacetype    => $interfacetype,
    interfacedetails => $interfacedetails,
    tls_connect      => $tls_connect,
    tls_accept       => $tls_accept,
    tls_issuer       => $tls_issuer,
    tls_subject      => $tls_subject,
  }
}
