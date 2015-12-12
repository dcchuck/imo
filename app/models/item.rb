class Item < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :image_url, presence: true, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0.00 }
end
