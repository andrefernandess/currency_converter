require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    subject(:transaction) do
      Transaction.new(
        user_id: 1,
        from_currency: 'USD',
        to_currency: 'BRL',
        from_value: 100.0,
        to_value: 520.0,
        rate: 5.20
      )
    end

    context 'with valid attributes' do
      it 'is valid' do
        expect(transaction).to be_valid
      end
    end

    context 'user_id' do
      it 'is required' do
        transaction.user_id = nil
        expect(transaction).not_to be_valid
        expect(transaction.errors[:user_id]).to include("can't be blank")
      end

      it 'must be greater than zero' do
        transaction.user_id = 0
        expect(transaction).not_to be_valid
      end

      it 'must be an integer' do
        transaction.user_id = 1.5
        expect(transaction).not_to be_valid
      end
    end

    context 'currencies' do
      it 'from_currency is required' do
        transaction.from_currency = nil
        expect(transaction).not_to be_valid
      end

      it 'to_currency is required' do
        transaction.to_currency = nil
        expect(transaction).not_to be_valid
      end

      it 'accepts valid currencies' do
        %w[BRL USD EUR JPY].each do |currency|
          other_currency = currency == 'USD' ? 'BRL' : 'USD'
          
          transaction.from_currency = currency
          transaction.to_currency = other_currency
          
          expect(transaction).to be_valid
        end
      end

      it 'rejects invalid currencies' do
        transaction.from_currency = 'XXX'
        expect(transaction).not_to be_valid
      end

      it 'requires different from and to currencies' do
        transaction.from_currency = 'USD'
        transaction.to_currency = 'USD'
        expect(transaction).not_to be_valid
        expect(transaction.errors[:to_currency]).to include('must be different from origin currency')
      end
    end

    context 'values' do
      it 'from_value is required' do
        transaction.from_value = nil
        expect(transaction).not_to be_valid
      end

      it 'to_value is required' do
        transaction.to_value = nil
        expect(transaction).not_to be_valid
      end

      it 'from_value must be greater than zero' do
        transaction.from_value = 0
        expect(transaction).not_to be_valid
      end

      it 'to_value must be greater than zero' do
        transaction.to_value = -10
        expect(transaction).not_to be_valid
      end
    end

    context 'rate' do
      it 'is required' do
        transaction.rate = nil
        expect(transaction).not_to be_valid
      end

      it 'must be greater than zero' do
        transaction.rate = 0
        expect(transaction).not_to be_valid
      end
    end
  end
end