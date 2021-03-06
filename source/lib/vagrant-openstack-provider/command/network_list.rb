require 'vagrant-openstack-provider/command/utils'
require 'vagrant-openstack-provider/command/abstract_command'

module VagrantPlugins
  module Openstack
    module Command
      class NetworkList < AbstractCommand
        include VagrantPlugins::Openstack::Command::Utils

        def self.synopsis
          I18n.t('vagrant_openstack.command.network_list_synopsis')
        end
        def cmd(name, argv, env)
          fail Errors::UnrecognizedArgForCommand, cmd: name, arg: argv[1] if argv.size > 1
          if argv.size == 0
            flavors = env[:openstack_client].neutron.get_private_networks(env)
          elsif argv[0] == 'all'
            flavors = env[:openstack_client].neutron.get_all_networks(env)
          else
            fail Errors::UnrecognizedArgForCommand, cmd: name, arg: argv[0]
          end
          display_item_list(env, flavors)
        end
      end
    end
  end
end
