class Api::V1::ChatRoomsController < ApplicationController
  before_action :set_chat_room, except: [:index, :create]

  def index
    chat_rooms = current_user.chat_rooms
    render json: chat_rooms
  end

  def create
    chat_room = current_user.chat_rooms.create(chat_room_params)
    if chat_room.persisted?
      render json: chat_room
    else
      render json: { errors: chat_room.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    if @chat_room
      render json: @chat_room
    else
      render json: { error: 'Chat Room not found' }, status: :not_found
    end
  end

  def update
    if @chat_room.update_attributes(chat_room_params)
      render json: @chat_room
    else
      render json: { errors: @chat_room.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @chat_room.destroy
    render json: { message: 'deleted' }
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:name, :password, :password_confirmation)
  end

  def set_chat_room
    @chat_room = current_user.chat_rooms.find(params[:id])
  end
end
