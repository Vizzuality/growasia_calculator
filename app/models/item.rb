class Item < ApplicationRecord
  has_enumeration_for :category, with: ItemCategory, create_helpers: true
  validates :name, uniqueness: { scope: :category }
end
