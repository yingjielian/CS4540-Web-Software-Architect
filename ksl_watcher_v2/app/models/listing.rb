# == Schema Information
#
# Table name: listings
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Listing < ApplicationRecord
end
