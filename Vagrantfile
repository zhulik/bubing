# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

def configure(config)
  config.vm.provision 'shell', privileged: true, inline: 'aptitude update'
  config.vm.provision 'shell', privileged: true, inline: 'aptitude install -y cmake build-essential curl'

  config.vm.provision 'shell', privileged: false, inline: 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
  config.vm.provision 'shell', privileged: false, inline: '\curl -sSL https://get.rvm.io | bash -s stable'
  config.vm.provision 'shell', privileged: false, inline: 'source $HOME/.rvm/scripts/rvm && rvm install 2.0.0'
  config.vm.provision 'shell', privileged: false, inline: 'source $HOME/.rvm/scripts/rvm && rvm use 2.0.0 && gem install bundler'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'x86_32' do |x86_32|
    x86_32.vm.box = 'ubuntu/precise32'
    x86_32.vm.box_url = 'http://files.vagrantup.com/precise32.box'

    configure(x86_32)
  end

  config.vm.define 'x86_64' do |x86_64|
    x86_64.vm.box = 'ubuntu/precise64'
    x86_64.vm.box_url = 'http://files.vagrantup.com/precise64.box'

    configure(x86_64)
  end
end