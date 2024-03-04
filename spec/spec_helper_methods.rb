# frozen_string_literal: true

def baseline_os_hash
  {
    supported_os: [
      {
        'operatingsystem' => 'CentOS',
        'operatingsystemrelease' => %w[7 8]
      },
      {
        'operatingsystem' => 'Debian',
        'operatingsystemrelease' => %w[11]
      },
      {
        'operatingsystem' => 'Ubuntu',
        'operatingsystemrelease' => %w[20.04 22.04]
      },
      {
        'operatingsystem' => 'Archlinux',
      },
      # TODO: Support and tests for Gentoo need to be fixed
      # {
      #   'operatingsystem' => 'Gentoo',
      # },
      {
        'operatingsystem' => 'windows',
        'operatingsystemrelease' => %w[2016 2019]
      },
    ]
  }
end
