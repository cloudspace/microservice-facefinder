Vagrant.configure("2") do |config|
  config.vm.box     = "cloudspace-ruby"
  config.vm.box_url = "http://devops.cloudspace.com/images%2Fruby%2Fruby.box"
  config.ssh.private_key_path = [File.join(ENV['HOME'], '.ssh', 'vagrant.pem'), File.join(ENV['HOME'], '.ssh', 'id_rsa')]

  org = "facefinder"

  config.ssh.forward_agent = true

  config.vm.network "private_network", ip: "33.33.33.13"

  config.vm.synced_folder ".", "/srv/#{org}", type: "nfs"

  config.vm.provider "virtualbox" do |v|
    v.customize [
      "modifyvm", :id, 
      "--memory", "4096",
      "--name", "facefinder",
      "--cpus", "4",
      "--usb", "off",
      "--usbehci", "off"
    ]
  end

  config.vm.provision "shell", path: 'provisioner/shell_install.sh'

end
