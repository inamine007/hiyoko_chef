class CommentsController < ApplicationController
    def create
        recipe = Recipe.find(params[:recipe_id])
        comment = recipe.comments.build(comment_params)
        comment.user_id = current_user.id
        if comment.save
            render json: { status: 'SUCCESS', data: comment }
        else
            render json: { status: 'ERROR', data: comment.errors.full_messages }
        end
    end

    def destroy
        comment = Comment.find(params[:id])
        comment.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the comment', data: comment }
    end

    private

    def comment_params
        params.require(:comment).permit(:content)
    end
end
