class Api::V1::Ai::InquiriesController < Api::EndpointController

  def klass() 
    Inquiry 
  end

  def on_email_crafter data
    email_body = data[:email_body]
    @item = Inquiry.create(kind: 'email')
    m = @item.messages.create(user_content: email_body)
    InquiryResponseService.process_message m
  end

  protected

  def collection_scope
    #Inquiry.all
  end

  def strong_params
    params.require(@resource_name).permit()
  end
end
