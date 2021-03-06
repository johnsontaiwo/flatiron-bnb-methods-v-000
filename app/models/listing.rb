class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

   after_create :change_user_to_host
   after_destroy :alter_host_status

   def change_user_to_host
      host.host = true
      host.save
   end
    
    def alter_host_status
      if host.listings.empty?
        host.host = false
        host.save
      end
    end

    def average_review_rating
      self.reviews.average(:rating)
    end
end
