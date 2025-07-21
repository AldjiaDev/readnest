class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new
  end

  def create
    receiver = User.find(params[:receiver_id])
    conversation = Conversation.between(current_user.id, receiver.id).first

    unless conversation
      conversation = Conversation.create(sender: current_user, receiver: receiver)
    end

    redirect_to conversation_path(conversation)
  end
end
