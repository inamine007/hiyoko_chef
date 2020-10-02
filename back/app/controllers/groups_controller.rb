class GroupsController < ApplicationController
    before_action :set_group, only: [:mygroup, :update, :destroy]
    before_action :authenticate_user!

  def owner
    user = User.find(params[:id])
    @groups = user.groups.where(owner_id: user.id)
    render json: { status: 'SUCCESS', data: @groups }
  end

  def members
    group = Group.find(params[:id])
    users = group.users
    render json: users, each_serializer: UserSerializer
  end

  def mygroup
    recipes = @group.recipes.all
    render json: recipes, each_serializer: RecipeSerializer
    # render json: { status: 'SUCCESS', message: 'loaded recipes', data: @recipes }
  end

  def add_user_group
    group = Group.find(group_params[:id])
    
    if group.password == group_params[:password].to_i
      group.users << current_user
      render json: { status: 'SUCCESS', data: group.users }
    else
      render json: { status: 'ERROR' }
    end
  end

  def remove_user
    group = current_user.groups.find(params[:id])
    group.users.delete(current_user)
    render json: { status: 'SUCCESS', message: 'Exited the group', data: group }
  end

  def index
    groups = current_user.groups
    render json: { status: 'SUCCESS', message: 'loaded groups', data: groups }
  end

  def show
    group = Group.find(params[:id])
    member_count = group.users.length
    render json: { status: 'SUCCESS', message: 'loaded groups', data: group, data_count: member_count}
  end

  def create
    group = Group.new(group_params)
    group.users << current_user
    group.owner_id = current_user.id
    if group.save
      render json: { status: 'SUCCESS', data: group }
    else
      render json: { status: 'ERROR', data: group.errors.full_messages }
    end
  end

  def destroy
    @group.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the group', data: @groups }
  end

  def update
    if @group.update(group_params)
      render json: { status: 'SUCCESS', message: 'Updated the group', data: @groups }
    else
      render json: { status: 'ERROR', message: 'Not updated', data: @groups.errors }
    end
  end

  private

  def set_group
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:id, :name, :introduction, :password, :owner_id, :image)
  end
end
