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
end
