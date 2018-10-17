# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  active     :boolean
#  keywords   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Search < ApplicationRecord
end
