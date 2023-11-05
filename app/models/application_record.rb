class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Set defaults
  before_create :set_defaults

  protected

  # Supposed to be overridden.
  def set_defaults
  end
end
