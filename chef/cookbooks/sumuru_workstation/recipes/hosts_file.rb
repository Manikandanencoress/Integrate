run_unless_marker_file_exists("hosts_file") do
  template "/etc/hosts" do
    source "hosts.erb"
    owner "root"
    group "wheel"
    mode 0644
  end
end