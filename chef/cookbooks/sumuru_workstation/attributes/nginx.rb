node.override["nginx_settings"]= {
  "server_name" => "localhost.local",
  "server_port" => 80,
  "server_document_root"=> "/var/www/apps/example/current/public"
}

node.override["ssl_settings"]= {
  "common_name" => "*.milyoni.net",
  "cert_path" => "/usr/local/etc/certificates",
  "ca_path" => "/usr/local/etc/certificates/demoCA"
}
