def baseline_os_hash
  {
    supported_os: [
      {
        'operatingsystem' => 'CentOS',
        'operatingsystemrelease' => %w[7 8]
      },
      {
        'operatingsystem' => 'Debian',
        'operatingsystemrelease' => %w[10 11]
      },
      {
        'operatingsystem' => 'Ubuntu',
        'operatingsystemrelease' => %w[16.04 18.04 20.04]
      },
      {
        'operatingsystem' => 'Archlinux',
      },
      {
        'operatingsystem' => 'Gentoo',
      },
      {
        'operatingsystem' => 'windows',
        'operatingsystemrelease' => ['2012', '2012 R2', '2016']
      },
    ]
  }
end
