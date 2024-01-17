class Product < ApplicationRecord
    has_one_attached :image
    validates :name, presence: true, length: { maximum: 255 }
    validates :price, presence: true
    validates :short_description, presence: true, length: { maximum: 500 }
end
