class Api::V1::MessagesController < ApplicationController
  before_action :set_chat_room
  before_action :set_message, except: [:index, :create]
  before_action :check_authorship, only: [:update, :destroy]

  def index
    messages = @chat_room.messages
    render json: messages
  end

  def create
    message = @chat_room.messages.create(message_params)
    if message.persisted?
      render json: message
    else
      render json: { errors: message.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    if @message
      render json: @message
    else
      render json: { error: 'Message not found' }, status: :not_found
    end
  end

  def update
    if @message.update_attributes(message_params)
      render json: @message
    else
      render json: { errors: @message.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    render json: { message: 'deleted' }
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end

  def set_message
    @message = @chat_room.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body).merge(author: current_user)
  end

  def check_authorship
    unless @message.user_is_author?(current_user)
      render json: { error: "You don't have permission to update this message" },
             status: :unauthorized and return
    end
  end
end
