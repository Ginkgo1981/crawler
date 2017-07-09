# == Schema Information
#
# Table name: interest_tags
#
#  id         :integer          not null, primary key
#  intent     :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InterestTag < ApplicationRecord
end
