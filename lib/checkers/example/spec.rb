require 'rails_helper'

module Checker
  RSpec.describe Base do
    context 'context' do

      it 'test' do
        expect(described_class.call).to eq(123)
      end

    end
  end
end
