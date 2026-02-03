# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(name: 'João Silva', email: 'joao@email.com')
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = User.new(name: nil, email: 'joao@email.com')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a name shorter than 3 characters' do
      user = User.new(name: 'A', email: 'joao@email.com')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    it 'is invalid without an email' do
      user = User.new(name: 'João Silva', email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with an invalid email format' do
      invalid_emails = ['invalid', 'test@', '@test.com', 'test@.com']
      
      invalid_emails.each do |email|
        user = User.new(name: 'João Silva', email: email)
        expect(user).not_to be_valid, "Expected #{email} to be invalid"
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    it 'is invalid with a duplicate email' do
      User.create!(name: 'João Silva', email: 'joao@email.com')
      duplicate = User.new(name: 'João Santos', email: 'joao@email.com')
      
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it 'is invalid with a duplicate email (case insensitive)' do
      User.create!(name: 'João Silva', email: 'joao@email.com')
      duplicate = User.new(name: 'João Santos', email: 'JOAO@EMAIL.COM')
      
      expect(duplicate).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many transactions' do
      assoc = described_class.reflect_on_association(:transactions)
      expect(assoc.macro).to eq(:has_many)
    end

    it 'deletes associated transactions when destroyed' do
      user = User.create!(name: 'João Silva', email: 'joao@email.com')
      user.transactions.create!(
        from_currency: 'USD',
        to_currency: 'BRL',
        from_value: 100,
        to_value: 525.32,
        rate: 5.25
      )

      expect { user.destroy }.to change(Transaction, :count).by(0)
    end
  end
end
