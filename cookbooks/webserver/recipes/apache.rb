if node['platform'] == "ubuntu"
  package "apache2" do
    action :install
  end

  service "apache2" do
    action [ :enable, :start ]
  end

  file '/var/www/html/index.html' do
    owner 'www-data'
    group 'www-data'
    mode '0644'
    content '<html><h1>Hello World, Stelligent!</h1></html>'
    action :create
  end
else
  package "httpd" do
    action :install
  end

  service "httpd" do
    action [ :enable, :start ]
  end

  file '/var/www/html/index.html' do
    owner 'apache'
    group 'apache'
    mode '0644'
    content '<html><h1>Hello World, Stelligent!</h1></html>'
    action :create
  end
end
log "Apache HTTPD has been installed"
