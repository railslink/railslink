# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackUserPresenter do
  subject { SlackUserPresenter.new(slack_user) }

  describe '#admin_checkmark' do
    context 'when is_admin? is true' do
      let(:slack_user) { double('is_admin?' => true) }

      it 'returns ✓' do
        expect(subject.admin_checkmark).to eq '✓'
      end
    end

    context 'when is_admin? is false' do
      let(:slack_user) { double('is_admin?' => false) }

      it 'returns an empty string' do
        expect(subject.admin_checkmark).to eq ''
      end
    end
  end

  describe '#name_with_email' do
    context 'name is blank' do
      let(:slack_user) { double('name' => '', 'email' => 'john@doe.com') }

      it 'returns the email address' do
        expect(subject.name_with_email).to eq 'john@doe.com'
      end
    end

    context 'name is present' do
      let(:slack_user) { double('name' => 'John', 'email' => 'john@doe.com') }

      it 'returns name and email address' do
        expect(subject.name_with_email).to eq 'John - john@doe.com'
      end
    end
  end
end
