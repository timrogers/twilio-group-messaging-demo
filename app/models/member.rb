class Member < ActiveRecord::Base
	validates :phone_number, presence: true, uniqueness: true
end
