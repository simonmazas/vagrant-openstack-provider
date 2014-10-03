require 'log4r'
require 'timeout'

require 'vagrant-openstack-provider/action/abstract_action'

module VagrantPlugins
  module Openstack
    module Action
      class WaitForServerToBeActive < AbstractAction
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_openstack::action::start_server')
        end

        def execute(env)
          if env[:machine].id
            env[:ui].info(I18n.t('vagrant_openstack.waiting_start'))
            client = env[:openstack_client].nova
            timeout(200) do
              while client.get_server_details(env, env[:machine].id)['status'] != 'ACTIVE'
                sleep 3
                @logger.info('Waiting for server to be active')
              end
            end
          end
          @app.call(env)
        end
      end
    end
  end
end
