module Api
    module V1
      class TasksController < ApplicationController
        # タスクの一覧を取得
        def index
          tasks = Task.all
          render json: tasks
        end
  
        # 新しいタスクを作成
        def create
          task = Task.new(task_params)
          if task.save
            render json: task, status: :created
          else
            render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        # Strong parameters: タスクの入力内容を検証
        def task_params
          params.require(:task).permit(:title, :description, :completed)
        end
      end
    end
  end