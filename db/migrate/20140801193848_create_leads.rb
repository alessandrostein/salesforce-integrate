class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.text :name
      t.text :last_name
      t.text :email
      t.text :company
      t.text :job_title
      t.text :phone
      t.text :website

      t.timestamps
    end
  end
end
