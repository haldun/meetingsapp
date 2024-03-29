class RoomsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  expose(:rooms) { current_user.rooms.page params[:page] }
  expose(:room)

  def index
    respond_with rooms
  end

  def show
    respond_with room
  end

  def new
    respond_with room
  end

  def edit
    respond_with room
  end

  def create
    room.owner = current_user
    if room.save
      room.memberships.create! user: current_user, role: :admin
      flash.notice = 'Room was created successfully.'
    end
    respond_with room
  end

  def update
    if room.save
      flash.notice = 'Room was updated successfully.'
    end
    respond_with room
  end

  def destroy
    room.destroy
    respond_with room
  end

  layout :set_layout

  def set_layout
    request.headers['X-PJAX'].present? ? false : 'application'
  end
end
