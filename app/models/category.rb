class Category < ApplicationRecord
  # To allow many-to-many articles
  has_many :article_categories, dependent: :destroy
  has_many :articles, through: :article_categories, source: :article

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
