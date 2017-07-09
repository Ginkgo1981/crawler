# == Schema Information
#
# Table name: industries
#
#  id         :integer          not null, primary key
#  uuid       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Industry < ApplicationRecord

  has_many :experiences



end
