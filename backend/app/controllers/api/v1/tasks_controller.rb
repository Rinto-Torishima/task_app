module Api
    module V1
      class TasksController < ApplicationController
        # タスクの一覧を取得
      def index
        tasks = Task.includes(:tags).all
        render json: tasks.as_json(include: :tags)
      end  
        # 新しいタスクを作成
      def create
        task = Task.new(task_params)
        if task.save
          # タグが選択されている場合、タスクにタグを関連付け
          if params[:task][:tag_ids]
            # 重複を防ぐためにsyncを使用
            task.tags = Tag.where(id: params[:task][:tag_ids])
          end
          render json: task, status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

        # タスクを更新 (完了状態の変更など)
      def update
        task = Task.find(params[:id])
      
        Task.transaction do
          if task.update(task_params)
            if params[:tag_ids]
              task.tags = Tag.where(id: params[:tag_ids])
            end
            render json: task.as_json(include: :tags)
          else
            render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue => e
        render json: { errors: ["更新中にエラーが発生しました: #{e.message}"] }, status: :unprocessable_entity
      end
      # タスクを削除
      # ここの記述戻して、cascadeにするかも
      def destroy
        task = Task.find_by(id: params[:id])
      
        if task.nil?
          render json: { errors: "タスクが見つかりません" }, status: :not_found
          return
        end
        
        begin
          # 関連する task_tags を削除
          task.tags.clear # または task.task_tags.destroy_all で関連するタグを削除
          
          task.destroy!
          render json: { message: "タスクを削除しました" }, status: :ok
        rescue ActiveRecord::RecordNotDestroyed => e
          render json: { errors: "タスクの削除に失敗しました: #{e.message}" }, status: :unprocessable_entity
        end
      end
        private
  
        # Strong parameters: タスクの入力内容を検証
        def task_params
          params.require(:task).permit(:title, :description, :completed, tag_ids: [])
        end
      end
    end
  end