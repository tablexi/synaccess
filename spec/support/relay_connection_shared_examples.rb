shared_examples_for 'RelayConnection' do
  def default_initial_state
    relay.toggle(1, true)
    relay.toggle(2, false)
    # confirm the initial state is correct
    expect(relay.statuses).to include( 1 => true, 2 => false )
  end

  describe '#statuses', :vcr do
    let(:statuses) { relay.statuses }
    before(:each) { default_initial_state }

    it 'should return a hash' do
      expect(statuses).to be_a Hash
    end

    it 'should return outlet one as on' do
      expect(statuses[1]).to eq(true)
    end

    it 'should return outlet two as off' do
      expect(statuses[2]).to eq(false)
    end

    it 'should not have an outlet zero' do
      expect(statuses[0]).to be_nil
    end
  end

  describe '#status', :vcr do
    before(:each) { default_initial_state }

    it 'should return true for outlet 1' do
      expect(relay.status(1)).to eq(true)
    end

    it 'should return false for outlet 2' do
      expect(relay.status(2)).to eq(false)
    end
  end

  describe '#status' do
    it 'should raise an error if connection times out' do
      expect_any_instance_of(NetBooter::HttpConnection).to receive(:do_http_request).and_raise(Timeout::Error)
      expect { relay.status(1) }.to raise_error(NetBooter::Error)
    end
  end

  describe '#toggle', :vcr do
    before(:each) { default_initial_state }

    context 'toggling on' do
      context 'when the outlet is already on' do
        let(:outlet) { 1 }
        let!(:response) { relay.toggle(outlet, true) }

        it 'should return true' do
          expect(response).to eq(true)
        end

        it 'should still have the old status' do
          expect(relay.status(outlet)).to eq(true)
        end

        it 'should have left the other outlet alone' do
          expect(relay.status(2)).to eq(false)
        end
      end

      context 'when the outlet was off' do
        let(:outlet) { 2 }
        let!(:response) { relay.toggle(outlet, true) }

        it 'should return true' do
          expect(response).to eq(true)
        end

        it 'should be the new status' do
          expect(relay.status(outlet)).to eq(true)
        end

        it 'should have left the other outlet alone' do
          expect(relay.status(1)).to eq(true)
        end
      end
    end


    context 'toggling off' do
      context 'when the outlet is already off' do
        let(:outlet) { 2 }
        let!(:response) { relay.toggle(outlet, false) }

        it 'should return false' do
          expect(response).to eq(false)
        end

        it 'should still have the old status' do
          expect(relay.status(outlet)).to eq(false)
        end

        it 'should have left the other outlet alone' do
          expect(relay.status(1)).to eq(true)
        end
      end

      context 'when the outlet was on' do
        let(:outlet) { 1 }
        let!(:response) { relay.toggle(outlet, false) }

        it 'should return false' do
          expect(response).to eq(false)
        end

        it 'should be the new status' do
          expect(relay.status(outlet)).to eq(false)
        end

        it 'should have left the other outlet alone' do
          expect(relay.status(2)).to eq(false)
        end
      end
    end
  end

end
