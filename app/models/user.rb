class User < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error

  before_validation :normalize_attributes
  
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, 
                  uniqueness: { case_sensitive: false },
                  format: { with: URI::MailTo::EMAIL_REGEXP }
                  

  private

  def normalize_attributes
    self.name = name.strip if name.present?
    self.email = email.strip.downcase if email.present?
  end
end
