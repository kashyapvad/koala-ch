# == Schema Information
#
# Table name: messages
#
#  id                   :bigint           not null, primary key
#  user_content         :string
#  user_copy            :string
#  llm_model            :string
#  llm_response         :jsonb
#  llm_response_content :string
#  inquiry_id           :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Message < ApplicationRecord
  belongs_to :inquiry

  def type
    inquiry.type
  end
end
