/*
==Class: postgresql::debian::v9-1::client

Requires:
 - Class["apt::preferences"]

*/

class postgresql::debian::v9-1::client {

  package {[
            "postgresql-client-${version}",
            "postgresql-common",
            "libpq-dev",
            ]:
              ensure => installed,
              require => Class["postgresql::debian::v9-1::repo"],
            }
}
