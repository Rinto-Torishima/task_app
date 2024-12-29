class Api::V1::TagsController < ApplicationController
    # タグ一覧を取得
    def index
      tags = Tag.all
      render json: tags
    end
  
    # 新しいタグを作成
    def create
      tag = Tag.new(tag_params)
      if tag.save
        render json: tag, status: :created
      else
        render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      tag = Tag.find_by(id: params[:id])
      
      if tag.nil?
        render json: { errors: "タグが見つかりません" }, status: :not_found
        return
      end
  
      begin
        tag.destroy!
        render json: { message: "タグを削除しました" }, status: :ok
      rescue ActiveRecord::RecordNotDestroyed => e
        render json: { errors: "タグの削除に失敗しました: #{e.message}" }, status: :unprocessable_entity
      end
    end
  
    private
  
    # タグの入力内容を検証
    def tag_params
      params.require(:tag).permit(:name)
    end
  end