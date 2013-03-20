shared_examples_for 'RelayConnection' do
  def default_initial_state
    relay.toggle(1, true)
    relay.toggle(2, false)
    # confirm the initial state is correct
    relay.statuses.should include( 1 => true, 2 => false )
  end

  describe '#statuses', :vcr do
    let(:statuses) { relay.statuses }
    before(:each) { default_initial_state }

    it 'should return a hash' do
      statuses.should be_a Hash
    end

    it 'should return outlet one as on' do
      statuses[1].should == true
    end

    it 'should return outlet two as off' do
      statuses[2].should == false
    end

    it 'should not have an outlet zero' do
      statuses[0].should be_nil
    end
  end

  describe '#status', :vcr do
    before(:each) { default_initial_state }

    it 'should return true for outlet 1' do
      relay.status(1).should == true
    end

    it 'should return false for outlet 2' do
      relay.status(2).should == false
    end
  end

  describe '#toggle', :vcr do
    before(:each) { default_initial_state }

    context 'toggling on' do
      context 'when the outlet is already on' do
        let(:outlet) { 1 }
        let!(:response) { relay.toggle(outlet, true) }

        it 'should return true' do
          response.should == true
        end

        it 'should still have the old status' do
          relay.status(outlet).should == true
        end

        it 'should have left the other outlet alone' do
          relay.status(2).should == false
        end
      end

      context 'when the outlet was off' do
        let(:outlet) { 2 }
        let!(:response) { relay.toggle(outlet, true) }

        it 'should return true' do
          response.should == true
        end

        it 'should be the new status' do
          relay.status(outlet).should == true
        end

        it 'should have left the other outlet alone' do
          relay.status(1).should == true
        end
      end
    end


    context 'toggling off' do
      context 'when the outlet is already off' do
        let(:outlet) { 2 }
        let!(:response) { relay.toggle(outlet, false) }

        it 'should return false' do
          response.should == false
        end

        it 'should still have the old status' do
          relay.status(outlet).should == false
        end

        it 'should have left the other outlet alone' do
          relay.status(1).should == true
        end
      end

      context 'when the outlet was on' do
        let(:outlet) { 1 }
        let!(:response) { relay.toggle(outlet, false) }

        it 'should return false' do
          response.should == false
        end

        it 'should be the new status' do
          relay.status(outlet).should == false
        end

        it 'should have left the other outlet alone' do
          relay.status(2).should == false
        end
      end
    end
  end

end