shared_examples_for 'RelayConnectionInterface' do
  subject { described_class.new('192.168.1.1') }

  it 'should accept a hash as options' do
    expect { described_class.new('192.168.1.1', :test => 1, :test2 => 2)}.not_to raise_error
  end

  it { is_expected.to respond_to(:status).with(1).argument }
  it { is_expected.to respond_to(:statuses).with(0).arguments }

  it { is_expected.not_to respond_to(:toggle).with(1).argument }
  it { is_expected.to respond_to(:toggle).with(2).arguments }

  it { is_expected.to respond_to(:toggle_on).with(0).arguments }
  it { is_expected.to respond_to(:toggle_on).with(1).arguments }

  it { is_expected.to respond_to(:toggle_off).with(0).arguments }
  it { is_expected.to respond_to(:toggle_off).with(1).arguments }
end
