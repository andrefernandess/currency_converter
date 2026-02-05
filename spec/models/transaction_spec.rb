require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    subject(:transaction) { build(:transaction) }

    describe "with valid attributes" do
      it "is valid with all required attributes" do
        expect(transaction).to be_valid
      end

      it "saves successfully to database" do
        expect { transaction.save }.to change(Transaction, :count).by(1)
      end
    end

    describe "user_id" do
      it "is required" do
        transaction.user = nil
        transaction.user_id = nil
        expect(transaction).not_to be_valid
      end
    end

    describe "currencies" do
      describe "from_currency" do
        it "is required from_currency" do
          transaction.from_currency = nil
          expect(transaction).not_to be_valid
          expect(transaction.errors[:from_currency]).to include("can't be blank")
        end

        it "must be a valid from_currency code" do
          transaction.from_currency = "INVALID"
          expect(transaction).not_to be_valid
          expect(transaction.errors[:from_currency]).to include("is not included in the list")
        end

        it "cannot be the same as to_currency" do
          transaction.to_currency = transaction.from_currency
          expect(transaction).not_to be_valid
          expect(transaction.errors[:to_currency]).to include("must be different from origin currency")
        end

        it "is required to_currency" do
          transaction.to_currency = nil
          expect(transaction).not_to be_valid
          expect(transaction.errors[:to_currency]).to include("can't be blank")
        end
        
        it "must be a valid to_currency code" do
          transaction.to_currency = "INVALID"
          expect(transaction).not_to be_valid
          expect(transaction.errors[:to_currency]).to include("is not included in the list")
        end

        it 'accepts valid currencies' do
          %w[BRL USD EUR JPY].each do |currency|
            transaction.to_currency = currency
            transaction.from_currency = 'BRL' if currency == 'USD'
            expect(transaction).to be_valid
          end
        end

        it "validates even when currencies are nil" do
          transaction.from_currency = nil
          transaction.to_currency = nil
          expect(transaction).not_to be_valid
          expect(transaction.errors[:to_currency]).to include("can't be blank")
          expect(transaction.errors[:from_currency]).to include("can't be blank")
          expect(transaction.errors[:to_currency]).not_to include("must be different from origin currency")
        end
      end
    end

    describe "values" do
      it "is from_value required" do
        transaction.from_value = nil
        expect(transaction).not_to be_valid
      end

      it "from_value must be greater than zero" do
        transaction.from_value = 0
        expect(transaction).not_to be_valid
      end

      it "from_value must be a number" do
        transaction.from_value = "invalid"
        expect(transaction).not_to be_valid
      end

      it "is to_value required" do
        transaction.to_value = nil
        expect(transaction).not_to be_valid
      end

      it "to_value must be greater than zero" do
        transaction.to_value = 0
        expect(transaction).not_to be_valid
      end

      it "to_value must be a number" do
        transaction.to_value = "invalid"
        expect(transaction).not_to be_valid
      end
    end

    describe "rate" do
      it "is required" do
        transaction.rate = nil
        expect(transaction).not_to be_valid
      end

      it "must be greater than zero" do
        transaction.rate = 0
        expect(transaction).not_to be_valid
      end

      it "must be a number" do
        transaction.rate = "invalid"
        expect(transaction).not_to be_valid
      end
    end

    describe "VALID_CURRENCIES constant" do
      it "includes all supported currencies" do
        expect(Transaction::VALID_CURRENCIES).to match_array(%w[BRL USD EUR JPY])
      end

      it "is frozen" do
        expect(Transaction::VALID_CURRENCIES.frozen?).to be_frozen
      end
    end
  end
end