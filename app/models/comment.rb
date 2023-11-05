class Comment < ApplicationRecord
  # Relations
  # belongs_to :comment, optional: true # Reddit like comment tree
  belongs_to :article
  belongs_to :author, class_name: 'User'

  validates :content, presence: true
end
