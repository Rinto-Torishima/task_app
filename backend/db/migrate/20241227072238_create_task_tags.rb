class CreateTaskTags < ActiveRecord::Migration[6.0]
  def change
    create_table :task_tags do |t|
      t.references :task, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end

    # task_id と tag_id の組み合わせをユニークにするインデックス
    add_index :task_tags, [:task_id, :tag_id], unique: true
  end
end