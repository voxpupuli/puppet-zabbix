# @summary Type for size values in bytes (also allows k/K and m/M as appendix)
type Zabbix::Historyics = Optional[Pattern[/^\d+[k|K|m|M]?$/]]
