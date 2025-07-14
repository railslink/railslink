# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackChannelPresenter do
  subject { SlackChannelPresenter.new(channel) }

  describe '#cleaned_purpose' do
    context 'when purpose contains a Slack-style channel mention' do
      let(:channel) { double('purpose' => 'See <#C123456|job-seekers> for openings') }

      it 'replaces Slack channel mention with readable text' do
        expect(subject.cleaned_purpose).to eq 'See #job-seekers for openings'
      end
    end

    context 'when purpose is blank' do
      let(:channel) { double('purpose' => '') }

      it 'returns an empty string' do
        expect(subject.cleaned_purpose).to eq ''
      end
    end

    context 'when purpose does not contain Slack markup' do
      let(:channel) { double('purpose' => 'Talk about code') }

      it 'returns the original purpose' do
        expect(subject.cleaned_purpose).to eq 'Talk about code'
      end
    end
  end
end
