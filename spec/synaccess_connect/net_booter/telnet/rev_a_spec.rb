require 'spec_helper'

describe NetBooter::Telnet::RevA do
  it_behaves_like 'RelayConnectionInterface'

  let(:relay) { described_class.new('192.168.10.21', :username => 'admin', :password => 'admin') }

  pending do
    it_behaves_like 'RelayConnection'
  end
end
