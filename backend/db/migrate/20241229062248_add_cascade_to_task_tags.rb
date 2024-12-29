class AddCascadeToTaskTags < ActiveRecord::Migration[6.0]
  def change
    # 外部キーにON DELETE CASCADEを追加
    remove_foreign_key :task_tags, :tasks
    remove_foreign_key :task_tags, :tags

    add_foreign_key :task_tags, :tasks, on_delete: :cascade
    add_foreign_key :task_tags, :tags, on_delete: :cascade
  end
end