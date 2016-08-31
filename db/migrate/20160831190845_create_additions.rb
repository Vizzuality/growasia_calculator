class CreateAdditions < ActiveRecord::Migration[5.0]
  def change
    create_table :additions do |t|
      t.float :amount
      t.string :category
      t.string :unit
      t.string :analysis_id
      t.decimal :area

      t.timestamps
    end
  end
end
