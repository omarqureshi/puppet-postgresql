class postgresql::debian::v9-1::repo {
  apt::preferences {[
                     "libpq5",
                     "libpq-dev",
                     "postgresql-${version}",
                     "postgresql-client-${version}",
                     "postgresql-common",
                     "postgresql-client-common",
                     "postgresql-contrib-${version}",
                     "postgresql-server-dev-${version}",
                     ]:
                       pin      => "release a=${lsbdistcodename}-backports",
                       priority => "1100",
                     }
}
