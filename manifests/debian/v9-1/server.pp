/*
==Class: postgresql::debian::v9-1::server

Parameters:
 $postgresql_data_dir:
    set the data directory path, which is used to store all the databases

Requires:
 - Class["apt::preferences"]

*/
  
class postgresql::debian::v9-1::server inherits postgresql::base {
  $version = "9.1"
  include postgresql::params
  include postgresql::debian::v9-1::client

  Package["postgresql"] {
    name   => "postgresql-${version}",
    notify => Exec["drop initial cluster"],
  }

  service {"postgresql":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    start     => "/etc/init.d/postgresql start ${version}",
    status    => "/etc/init.d/postgresql status ${version}",
    stop      => "/etc/init.d/postgresql stop ${version}",
    restart   => "/etc/init.d/postgresql restart ${version}",
    require   => Package["postgresql-common"],
  }

  exec {"drop initial cluster":
    command     => "pg_dropcluster --stop ${version} main",
    onlyif      => "test \$(su -c 'psql -lx' postgres |awk '/Encoding/ {printf tolower(\$3)}') = 'sql_asciisql_asciisql_ascii'",
    timeout     => 60,
    environment => "PWD=/",
    before      => Postgresql::Cluster["main"],
  }

  postgresql::cluster {"main":
    ensure      => present,
    clustername => "main",
    version     => $version,
    encoding    => "UTF8",
    data_dir    => "${postgresql::params::data_dir}",
    require     => [Package["postgresql"], Exec["drop initial cluster"]],
  }

  package {[
            "postgresql-contrib-${version}",
            "postgresql-server-dev-${version}",
            ]:
              ensure  => present,
              require => Package["postgresql"],
            }
}
