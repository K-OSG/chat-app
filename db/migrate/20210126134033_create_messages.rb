class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.references :room, foreign_kye: true
      t.references :user, foreign_kye: true
      t.timestamps
    end
  end
end
