class RoomsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  expose(:rooms) { current_user.rooms.page params[:page] }
  expose(:room) {
    # TODO Security!
    Room.fetch(params[:id])
  }

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
end
