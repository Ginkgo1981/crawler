# == Schema Information
#
# Table name: company_jobs
#
#  id                   :integer          not null, primary key
#  company_name         :string(255)
#  company_scale        :string(255)
#  company_logo         :string(255)
#  company_kind         :string(255)
#  company_industry     :string(255)
#  company_city         :string(255)
#  company_address      :string(255)
#  company_description  :text(65535)
#  company_email        :string(255)
#  company_mobile       :string(255)
#  company_contact_name :string(255)
#  company_tags         :text(65535)
#  job_type             :string(255)
#  job_name             :string(255)
#  job_city             :string(255)
#  job_address          :string(255)
#  job_description      :text(65535)
#  job_expired_at       :string(255)
#  job_published_at     :string(255)
#  job_recruitment_num  :string(255)
#  job_language         :string(255)
#  job_category         :string(255)
#  job_salary_range     :string(255)
#  job_mini_experience  :string(255)
#  job_mini_eduction    :string(255)
#  job_majors           :text(65535)
#  job_skills           :text(65535)
#  job_tags             :text(65535)
#  sources              :string(255)
#  original_url         :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class CompanyJob < ApplicationRecord

  serialize :company_tags, Array
  serialize :job_majors, Array
  serialize :job_skills, Array
  serialize :job_tags, Array
  serialize :sources, Array

end
