# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  weight     :integer          default(0)
#  analyzer   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Site < ApplicationRecord
  has_many :channels
end
