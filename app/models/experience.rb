# == Schema Information
#
# Table name: experiences
#
#  id            :integer          not null, primary key
#  industry_id   :integer
#  industry_name :string(255)
#  title         :string(255)
#  sub_title     :string(255)
#  content       :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Experience < ApplicationRecord
end
