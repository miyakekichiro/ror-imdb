class Movie < ApplicationRecord
  paginates_per 3
  belongs_to :user
  has_many :reviews
  has_one_attached :image
end
