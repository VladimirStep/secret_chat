class Api::V1::ChatAccessesController < ApplicationController
  before_action :authenticate_access_to_chat, only: [:create]
  before_action :set_chat_room, only: [:destroy]

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

  def destroy
    if @chat_room.chat_accesses&.find_by(user: current_user)&.closed!
      render json: { message: 'Access closed' }
    else
      render json: { error: "You don't have permission to change this access" },
             status: :unauthorized
    end
  end

  private

  def authenticate_access_to_chat
    @chat_room = ChatRoom.find_by(id: params[:chat_room_id])
                   &.authenticate(params[:chat_room][:password])
  end

  def set_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end
end
