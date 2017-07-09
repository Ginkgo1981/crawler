class CreateCompanyJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :company_jobs do |t|
      t.string :company_name
      t.string :company_scale
      t.string :company_logo
      t.string :company_kind
      t.string :company_industry
      t.string :company_city
      t.string :company_address
      t.text   :company_description
      t.string :company_email
      t.string :company_mobile
      t.string :company_contact_name
      t.text :company_tags

      t.string :job_type
      t.string :job_name
      t.string :job_city
      t.string :job_address
      t.text :job_description
      t.string :job_expired_at
      t.string :job_published_at
      t.string :job_recruitment_num
      t.string :job_language
      t.string :job_category
      t.string :job_salary_range
      t.string :job_mini_experience
      t.string :job_mini_eduction
      t.text :job_majors
      t.text :job_skills
      t.text :job_tags
      t.string :sources
      t.string :original_url
      t.timestamps
    end
  end
end
