class GroupsController < ApplicationController
    before_action :set_group, only: [:mygroup, :update, :destroy]
    before_action :authenticate_user!

  def owner
    user = User.find(params[:id])
    @groups = user.groups.where(owner_id: user.id)
    render json: { status: 'SUCCESS', data: @groups }
  end
  
  def mygroup
    @recipes = @group.recipes.all
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: @recipes }
    # @recipes = @group.recipes.page(params[:page]).per(20).recent
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
    groups = Group.all
    render json: { status: 'SUCCESS', message: 'loaded groups', data: groups }
  end

  def show
    group = Group.find(params[:id])
    render json: { status: 'SUCCESS', message: 'loaded groups', data: group }
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
    @groups.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the group', data: @groups }
  end

  def update
    if @groups.update(group_params)
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
