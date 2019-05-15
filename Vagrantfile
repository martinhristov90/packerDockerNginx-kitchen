Vagrant.configure(2) do |config|
    config.vm.box = "xenial"
    config.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
    config.vm.provision "shell", path: "scripts/provision.sh" , privileged: false
    config.vm.synced_folder ".", "/home/vagrant/buildDir", disabled: false
    config.vm.provision "shell", path: "scripts/kitchenSetup.sh" , privileged: false
  end
