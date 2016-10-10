if node['platform'] == "ubuntu"
  package "apache2"

  file '/var/www/html/index.html' do
    owner 'www-data'
    group 'www-data'
    mode '0644'
    content '<html><h1>Hello World, Stelligent!</h1></html>'
    action :create
  end
else
  package "httpd"

  file '/var/www/html/index.html' do
    owner 'apache'
    group 'apache'
    mode '0644'
    content 'Hello World, Stelligent!'
    action :create
  end
end
log "Apache HTTPD has been installed"
