require 'spec_helper'

describe User do
  describe "validations" do

    subject { build(:user) }

    describe "name" do
      it "is required" do
        subject.should_not accept_values(:email, nil, '')
      end
    end

    describe "email" do
      it "is required" do
        subject.should_not accept_values(:email, nil, '', ' ')
      end

      it "must be properly formatted" do
        subject.should     accept_values(:email, 'a@b.com', 'a@b.c.com')
        subject.should_not accept_values(:email, 'a@b', 'a.b.com')
      end
    end
  end

  describe ".create" do
    subject { build(:user) }

    it 'sets an initial state of available' do
      subject.should be_available
    end
  end

  describe 'state changes' do
    shared_examples 'pushes the new state to Pusher' do
      it 'pushes the state change to Pusher' do
        @channels_pushed_to.should include 'userStates'
        @event_pushed.should == 'cyberdyne:userStateChanged'
        @data_pushed.should include(:state)
        @data_pushed[:state].should == subject.state
        @data_pushed.should include(:user_id)
        @data_pushed[:user_id].should == subject.id
      end
    end

    before do
      Pusher.stub(:trigger) do |channels, event, data|
        @channels_pushed_to = channels
        @event_pushed = event
        @data_pushed = data
      end
    end

    after do
      Pusher.unstub(:trigger)
      @channels_pushed_to = nil
      @event_pushed = nil
      @data_pushed = nil
    end

    describe "#pickup_from_queue!" do
      let(:call_sid) { 'call_sid' }
      subject { create(:user, phone_number: '+1234567890') }

      before do
        fake_call = mock()
        fake_call.stub(:sid) do
          call_sid
        end
        TwilioService.stub(:make_queue_pickup_call_to) do |number|
          @called_phone_number = number
          fake_call
        end

        subject.pickup_from_queue!(call_sid: call_sid)
      end

      after do
        TwilioService.unstub(:make_queue_pickup_call_to)
      end

      it 'the user should be waiting' do
        subject.should be_waiting
      end

      it 'records the Twilio sid of the call' do
        subject.call_sid.should == call_sid
      end

      it "calls the user's phone so it they can pick up a target from the call queue" do
        @called_phone_number.should be
        @called_phone_number.should == subject.phone_number
      end
    end

    describe '#picked_up_call!' do
      context 'given a Twilio call sid' do
        let(:call_sid) { 'a_call_sid' }
        subject { build(:user) }

        before do
          subject.picked_up_call! call_sid: call_sid
        end

        it 'sets the user to be on a call' do
          subject.should be_on_a_call
        end

        it 'records the call sid' do
          subject.call_sid.should == call_sid
        end

        include_examples 'pushes the new state to Pusher'
      end

      context 'when the user already has a call sid' do
        let(:call_sid) { 'a_call_sid' }
        let(:other_call_sid) { 'other_call_sid' }
        subject { build(:user, call_sid: call_sid) }

        before do
          subject.picked_up_call! call_sid: other_call_sid
        end

        it 'sets the user to be on a call' do
          subject.should be_on_a_call
        end

        it 'does not change the call sid' do
          subject.call_sid.should == call_sid
        end
      end
    end

    describe '#hung_up!' do
      subject { build(:user, state: :on_a_call, call_sid: 'call_sid') }

      before do
        subject.hung_up!
      end

      it 'sets the user to available' do
        subject.should be_available
      end

      it 'removes any call sid' do
        subject.call_sid.should_not be
      end
    end
  end
end
