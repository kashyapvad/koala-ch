# == Schema Information
#
# Table name: messages
#
#  id               :bigint           not null, primary key
#  user_content     :string
#  response_content :string
#  user_copy        :string
#  llm_model        :string
#  llm_response     :jsonb
#  inquiry_id       :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Message < ApplicationRecord
  belongs_to :inquiry

  def type
    inquiry.type
  end
end
