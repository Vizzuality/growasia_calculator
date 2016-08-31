class Addition < ApplicationRecord
  has_enumeration_for :category, with: Category, create_helpers: true
end
