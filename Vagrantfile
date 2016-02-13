#  vagrant configuration

domain = '.vagrant'

sync_dirs = []
sync_dirs.push(["/slomedia", "/data/media"])


conf = {
  nfs: Vagrant.has_plugin?('vagrant-bindfs')
}

nodes = [
  { :hostname => 'slo',
    :ip => '172.16.56.12',
    :box => 'ubuntu/trusty64',
    :ram => '2048',
    :sync => sync_dirs
  },
]

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box_check_update = false
  config.ssh.forward_agent = true

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.enable :apt
    config.cache.enable :apt_lists
    config.cache.enable :npm
    config.cache.enable :gem
    config.cache.enable :bower

    # some of these don't seem to work without nfs
    if conf[:nfs]
      config.cache.enable :generic, {
        "tmp" => { cache_dir: "/tmp/cache" },
        # the npm plugin only covers the vagrant user, but most of our npm calls are as other users, so we need to add those folders manually
        "root_npm" => { cache_dir: "/root/.npm" },
        "www_npm" => { cache_dir: "/var/www/.npm" },
      }
    end
    config.cache.synced_folder_opts = {
      type: conf[:nfs] && :nfs || nil,
      mount_options: conf[:nfs] && ['rw', 'vers=3', 'tcp', 'nolock'] || []
    }
  else
    printf("** Install vagrant-cachier plugin `vagrant plugin install vagrant-cachier` to speedup deploy.**\n")
  end

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    # this fixes serious lag on OSX.  If you're still seeing everything on one
    # line in /etc/hosts then you need to update your plugins
    config.hostmanager.aliases_on_separate_lines = true
  else
    raise "** Install vagrant-hostmanager plugin `vagrant plugin install vagrant-hostmanager`.**\n"
  end

  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.host_name = node[:hostname] + domain
      node_config.vm.network :private_network, ip: node[:ip]
      node_config.hostmanager.aliases = ['raspberrypi', 'slomedialocal']

      node_config.vm.provider :virtualbox do |vb|
        vb.memory = node[:ram] ? node[:ram] : 512
        vb.cpus = node[:cpus] ? node[:cpus] : 1
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end

      if node.key?(:sync)
        node[:sync].each do |src, dest|
          if conf[:nfs]
            # use bindfs since nfs won't set the user/group correctly
            nfs_dir = '/nfs/' + File.basename(src)
            node_config.vm.synced_folder src, nfs_dir, type: 'nfs', mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
            node_config.bindfs.bind_folder nfs_dir, dest, owner: 'www-data', group: 'www-data'
          else
            node_config.vm.synced_folder src, dest, owner: "www-data", group: "www-data"
          end
        end
      end

      node_config.vm.provision "ansible" do |ansible|
        ansible.playbook = "slomedia.yml"
        ansible.host_key_checking = false
      end
    end
  end
end
