require 'spec_helper'

RSpec.describe NetBooter::Http::RevB do
  it_behaves_like 'RelayConnectionInterface'

  let(:relay) { described_class.new('192.168.10.20', :username => 'admin', :password => 'admin') }

  it_behaves_like 'RelayConnection'
end
