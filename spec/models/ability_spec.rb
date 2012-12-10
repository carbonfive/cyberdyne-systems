require 'spec_helper'
require 'cancan/matchers'

describe "User" do
  context "when working with User" do
    let(:user) { build(:admin) { |u| u.id = 1 } }
    subject { Ability.new(user) }

    context "operating on themselves" do
      it { should be_able_to(:manage, user) }
    end

    context "operating on someone else" do
      let(:other) { build(:user) { |u| u.id = 2 } }

      it { should be_able_to(:manage, other) }
    end
  end

  context "when working with a Target" do
    let(:user) { build(:admin) { |u| u.id = 1 } }
    let(:target) { build(:target) }
    subject { Ability.new(user) }

    it { should be_able_to(:manage, target) }
  end

  context "when working with a Call" do
    let(:user) { build(:admin) { |u| u.id = 1 } }
    let(:call) { build(:call) }
    subject { Ability.new(user) }

    it { should be_able_to(:manage, call) }
  end
end
