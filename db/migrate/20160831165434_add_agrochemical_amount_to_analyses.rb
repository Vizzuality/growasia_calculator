class AddAgrochemicalAmountToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :agrochemical_amount, :string
  end
end
