class InvitationsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!, :except => [:accept]

  expose(:invitations) { current_user.invitations.page params[:page] }
  expose(:invitation)

  def index
    respond_with invitations
  end

  def show
    respond_with invitation
  end

  def new
    respond_with invitation
  end

  def edit
    respond_with invitation
  end

  def create
    if invitation.save
      flash.notice = 'Invitation was created successfully.'
    end
    respond_with invitation
  end

  def update
    if invitation.save
      flash.notice = 'Invitation was updated successfully.'
    end
    respond_with invitation
  end

  def destroy
    invitation.destroy
    respond_with invitation
  end

  def accept
    @invitation = Invitation.find_by_token params[:token]
  end
end
