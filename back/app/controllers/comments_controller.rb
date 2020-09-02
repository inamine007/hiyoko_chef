class CommentsController < ApplicationController
    before_action :set_recipe
    
    def create
        comment = @recipe.comments.build(comment_params)
        comment.user_id = current_user.id
        if comment.save
            render json: { status: 'SUCCESS', data: comment }
        else
            render json: { status: 'ERROR', data: comment.errors.full_messages }
        end
    end

    def destroy
        comment = @recipe.comments.find_by(id: comment_params[:id])
        comment.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the comment', data: comment }
    end

    private

    def set_recipe
        @recipe = Recipe.find(params[:recipe_id])
    end

    def comment_params
        params.require(:comment).permit(:id, :content)
    end
end
