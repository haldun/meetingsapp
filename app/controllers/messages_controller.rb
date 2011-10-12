class MessagesController < BaseRoomController
  respond_to :html, :json
  before_filter :authenticate_user!

  expose(:room) {
    Room.fetch params[:room_id]
  }
  expose(:messages) { room.messages.includes(:author) }
  expose(:message)

  def index
    respond_with messages
  end

  def show
    respond_with message
  end

  def new
    respond_with message
  end

  def edit
    respond_with message
  end

  def create
    if message.save
      flash.notice = 'Message was created successfully.'
    end
    respond_with message
  end

  def update
    if message.save
      flash.notice = 'Message was updated successfully.'
    end
    respond_with message
  end

  def destroy
    message.destroy
    respond_with message
  end
end
