module NetBooter
end

require 'synaccess_connect/net_booter/telnet/telnet_connection'
require 'synaccess_connect/net_booter/telnet/rev_a'
require 'synaccess_connect/net_booter/telnet/rev_b'



# if defined?(Rails)
#   module SynaccessConnect
#     class Railtie < Rails::Railtie
#       # initializer "carrierwave.setup_paths" do
#       #   CarrierWave.root = Rails.root.join(Rails.public_path).to_s
#       #   CarrierWave.base_path = ENV['RAILS_RELATIVE_URL_ROOT']
#       # end

#       # initializer "carrierwave.active_record" do
#       #   ActiveSupport.on_load :active_record do
#       #     require 'carrierwave/orm/activerecord'
#       #   end
#       # end
#     end
#   end
# end