class postgresql::debian::v9-1::hba($clients) {
  $version = "9.1"
  if $clients == "" {
    $pg_clients = []
  } else {
    $pg_clients = $clients
  }

  file {"/etc/postgresql/9.1/main/pg_hba.conf":
    content => template("postgresql/hba.erb"),
    require => Package["postgresql-${version}"],
    notify => Exec["reload postgresql ${version}"],
  }
}
