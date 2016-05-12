# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/precise32'
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

  config.vm.provision 'shell', privileged: true, inline: 'aptitude update'
  config.vm.provision 'shell', privileged: true, inline: 'aptitude install -y cmake build-essential curl'

  config.vm.provision 'shell', privileged: false, inline: 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
  config.vm.provision 'shell', privileged: false, inline: '\curl -sSL https://get.rvm.io | bash -s stable'
  config.vm.provision 'shell', privileged: false, inline: 'rvm install 2.0.0'
  config.vm.provision 'shell', privileged: false, inline: 'rvm use 2.0.0 && gem install bundler'
end