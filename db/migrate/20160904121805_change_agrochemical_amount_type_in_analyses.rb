class ChangeAgrochemicalAmountTypeInAnalyses < ActiveRecord::Migration[5.0]
  def change
    change_column :analyses, :agrochemical_amount, 'decimal USING CAST(agrochemical_amount AS decimal)'
  end
end
