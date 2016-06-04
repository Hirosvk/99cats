require 'byebug'
class CatRentalRequest < ActiveRecord::Base
  STATUS = ["Pending", "Approved", "Denied"]
  validates :status, inclusion: STATUS
  validates :status, :cat_id, :start_date, :end_date, presence: true

  after_initialize :set_status

  validate :valid_request

  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: "Cat"

  def approve!
    self.status = 'Approved'
    if self.save
      conflicting_requests = overlapping_requests
      until conflicting_requests.empty?
        request = conflicting_requests.pop
        request.deny
      end
    end
  end


  def deny
    self.status = 'Denied'
    self.save
  end

  def set_status
    self.status ||= "Pending"
  end

  def overlapping_requests
    return [] if self.status == 'Denied'
    same_cat_reqs = CatRentalRequest.where(cat_id: self.cat_id)
    overlapping_reqs = []
    same_cat_reqs.each do |request|
      next if self.id == request.id
      if (self.start_date <= request.end_date && self.end_date >= request.start_date) ||
        (self.start_date <= request.start_date && self.end_date >= request.end_date) ||
        (self.start_date >= request.start_date && self.end_date <= request.end_date)
        overlapping_reqs << request
      end
    end
    overlapping_reqs
  end


  def self.all_sorted_by_start_date
    requests = CatRentalRequest.all.order(:start_date)
  end

  def overlapping_approved_requests
    approved_requests = []
    overlapping_requests.each do |request|
      approved_requests << request if request.status == 'Approved'
    end
    approved_requests
  end

  def valid_request
    if start_date > end_date
      errors[:base] << "Start date is later than end date"
    elsif !overlapping_approved_requests.empty?
      errors[:date_conflict] << 'has occurred'
    end
  end

end
