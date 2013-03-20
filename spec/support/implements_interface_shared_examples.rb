shared_examples_for 'RelayConnectionInterface' do
  subject { described_class.new('192.168.1.1') }

  it 'should accept a hash as options' do
    lambda { described_class.new('192.168.1.1', :test => 1, :test2 => 2)}.should_not raise_error
  end

  it { should respond_to(:status).with(1).argument }
  it { should respond_to(:statuses).with(0).arguments }

  it { should_not respond_to(:toggle).with(1).argument }
  it { should respond_to(:toggle).with(2).arguments }

  it { should respond_to(:toggle_on).with(0).arguments }
  it { should respond_to(:toggle_on).with(1).arguments }

  it { should respond_to(:toggle_off).with(0).arguments }
  it { should respond_to(:toggle_off).with(1).arguments }
end
