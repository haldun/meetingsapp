class BaseRoomController < ApplicationController
  before_filter :authenticate_user!

  expose(:rooms) { current_user.rooms }
  expose(:room)

  layout :set_layout

  def set_layout
    request.headers['X-PJAX'].present? ? false : 'room'
  end
end