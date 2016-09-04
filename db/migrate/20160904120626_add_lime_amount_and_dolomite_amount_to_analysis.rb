class AddLimeAmountAndDolomiteAmountToAnalysis < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :lime_amount, :decimal
    add_column :analyses, :dolomite_amount, :decimal
  end
end
