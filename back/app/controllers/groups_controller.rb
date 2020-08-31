class GroupsController < ApplicationController
    before_action :set_recipe, only: [:show, :update, :destroy]
    before_action :authenticate_user!

  def index
    groups = Group.all
    render json: { status: 'SUCCESS', message: 'loaded groups', data: groups }
  end

  def show
    render json: { status: 'SUCCESS', message: 'loaded groups', data: @groups }
  end

  def create
    group = Group.new(group_params)
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

  def set_recipe
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :introduction, :password, :owner_id, :image)
  end
end
