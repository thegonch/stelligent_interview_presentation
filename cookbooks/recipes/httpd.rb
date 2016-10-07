if node['platform'] == "ubuntu"
  package "apache2"
else
  package "httpd"
end
log "Apache HTTPD has been installed"
