class Article < ApplicationRecord
  # Relations
  belongs_to :author, class_name: 'User'

  validates :title, presence: true

  has_one :editor, class_name: 'User'
  has_many :comments, dependent: :destroy
  # To allow many-to-many categories
  has_many :article_categories, dependent: :destroy
  has_many :categories, through: :article_categories, source: :category

  ## Checks if the article is published (visible)
  ## If the publish_by DateTime is either null or less than current time, it is not published and therefore, hidden.
  def published?
    return false unless self.publish_by.present?

    self.publish_by < DateTime.now
  end

  def self.all_published
    self.where('publish_by is not null and publish_by <= ?', DateTime.now)
  end

  def self.all_hidden
    self.where('publish_by is null or publish_by > ?', DateTime.now)
  end

  private

  def set_defaults
    self.comments_enabled ||= false
  end

end
