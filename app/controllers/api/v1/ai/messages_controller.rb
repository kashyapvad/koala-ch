class Api::V1::Ai::MessagesController < Api::EndpointController

  def klass() 
    Message 
  end

  protected

  def collection_scope
    Message.all
  end

  def strong_params
    params.require(@resource_name).permit(:user_copy)
  end
end