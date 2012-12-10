require 'spec_helper'

describe Call do
  before do
    Pusher.stub(:trigger)
  end

  after do
    Pusher.unstub(:trigger)
  end

  describe '.create' do
    context 'given a phone number not matching any known targets' do
      before do
        @call = Call.create(phone_number: '+15558675309')
      end

      it 'queues the call' do
        @call.should be
        @call.should be_queued
      end
    end

    context 'given a phone number matching a known target' do
      before do
        @phone_number = '+15558675309'
        @target = create :target, phone_number: @phone_number
        @user = create :user
        @call = Call.create(phone_number: @phone_number)
      end

      it 'connects the call to a user' do
        @call.should be
        @call.should be_connect_to_user
        @call.user.should == @user
      end
    end

    context 'given a user' do
      before do
        @user = create :user
        TwilioService.stub(:make) do |call|
          @made_call = call
          mock().tap do |mock_call|
            mock_call.stub(:sid).and_return('sid')
          end
        end
        @call = Call.create(phone_number: '+15558675309', user: @user)
      end

      after do
        TwilioService.unstub(:make)
      end

      it 'makes the call' do
        @call.should be
        @call.should be_call_user
        @made_call.should == @call
      end
    end
  end

  describe '#dequeued!' do
    context 'when the call is currently queued' do
      before do
        call_sid = 'call_sid'
        @user = create(:user, call_sid: call_sid)
        @call = create(:call, state: :queued)

        @call.dequeued! user_call_sid: call_sid
      end

      it 'considers the call connected' do
        @call.should be_connected
      end

      it 'associates the call with the user of the dequeing call' do
        @call.user.should == @user
      end
    end
  end

  describe '#user_connected!' do
    context 'when a call was connecting to a user' do
      before do
        @call_sid == 'user_connected_call_sid'
        @user = create :user
        @call = create :call, state: :connect_to_user, user: @user

        @call.user_connected! user_call_sid: @call_sid
      end

      it 'considers the call connected' do
        @call.should be_connected
      end

      it 'associates the connecting sid to the call user' do
        @call.user.call_sid.should == @call_sid
      end
    end

    context 'when the call was calling a user' do
      before do
        @call_sid = 'calling_a_user_sid'
        @user = create :user, call_sid: @call_sid
        @call = create :call, state: :call_user

        @call.user_connected! user_call_sid: @call_sid
      end

      it 'connects to the phone number' do
        @call.should be_connect_to_phone_number
      end
    end
  end

  describe '#phone_number_connected!' do
    context 'when the call is connecting to its phone number' do
      before do
        @call_sid = 'connecting_phone_number_sid'
        @call = create :call, state: :connect_to_phone_number

        @call.phone_number_connected! call_sid: @call_sid
      end

      it 'considers the phone connected' do
        @call.should be_connected
      end

      it 'records the sid of the call' do
        @call.call_sid.should == @call_sid
      end
    end
  end
end
