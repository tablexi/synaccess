require 'spec_helper'
require 'synaccess_connect/net_booter/telnet'

describe NetBooter::Telnet::RevB do
  it_behaves_like 'RelayConnectionInterface'

  let(:relay) { described_class.new('192.168.10.20', :username => 'admin', :password => 'admin') }

  pending "implementation should work"  do
    it_behaves_like 'RelayConnection'
  end
end
