class Cat < ActiveRecord::Base
  SEX = ['M', 'F']
  COLORS = ['green', 'purple', 'black', 'white', 'brown', 'pink']
  validates :birth_date, :color, :name, :sex, presence: true
  validates :name, uniqueness: {scope: :birth_date}
  validates :color, inclusion: COLORS
  validates :sex, inclusion: SEX

  def age
    Date.today.year - birth_date.year
  end

  def gender
    sex == 'M' ? 'Male' : 'Female'
  end

  def self.colors
    COLORS
  end

  has_many :cat_rental_requests, dependent: :destroy,
    class_name: :CatRentalRequest,
    primary_key: :id,
    foreign_key: :cat_id
end
