class CreateNamespacedThings < ActiveRecord::Migration[5.2]
  def change
    create_table :namespaced_things do |t|
      t.string :color

      t.timestamps
    end
  end
end
