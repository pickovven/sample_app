# == Schema Information
# Schema version: 20110108181256
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessible :name, :email
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, 	:presence => true,
						:length   => { :maximum => 200 }
	validates :email, 	:presence => true,
						:format   => { :with => email_regex },
						:uniqueness => { :uniqueness => false }
end

