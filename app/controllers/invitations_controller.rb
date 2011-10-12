class InvitationsController < BaseRoomController
  respond_to :html, :json

  before_filter :authenticate_user!, :except => [:accept]

  expose(:invitations) { room.invitations.page params[:page] }
  expose(:invitation)

  def index
    respond_with invitations
  end

  def new
    respond_with invitation
  end

  def create
    invitation.user = current_user
    if invitation.save
      flash.notice = 'Invitation was created successfully.'
    end
    respond_with invitation
  end

  def destroy
    invitation.destroy
    respond_with invitation
  end

  def accept
    invitation = Invitation.find_by_token params[:token]
  end
end
