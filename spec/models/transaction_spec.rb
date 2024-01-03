# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:date) }
  end
  
  it 'creates an transaction' do
    Transaction.create(
      amount: 100.01,
      description: 'test content',
      date: DateTime.now
    )

    expect(Transaction.count).to eq(1)
  end
end
