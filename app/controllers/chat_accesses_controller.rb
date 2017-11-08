class ChatAccessesController < ApplicationController
  before_action :set_chat_room, only: [:create]

  def create
    unless @chat_room
      render json: { error: "You don't have permission to access this chat" },
             status: :unauthorized and return
    end

    access = ChatAccess.where(user: current_user, chat_room: @chat_room)
               .first_or_create(status: 'opened')
    access.opened!
    render json: { message: 'Access opened' }
  end

  def update
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find_by(id: params[:chat_room_id])
                        &.authenticate(params[:chat_room][:password])
  end
end
