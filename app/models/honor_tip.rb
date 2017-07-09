# == Schema Information
#
# Table name: honor_tips
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tips       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class HonorTip < ApplicationRecord
  serialize :tips, Array
end
