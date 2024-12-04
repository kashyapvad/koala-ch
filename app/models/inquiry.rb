# == Schema Information
#
# Table name: inquiries
#
#  id         :bigint           not null, primary key
#  kind       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Inquiry < ApplicationRecord
  enum kind: ['email', 'phone', 'chat']
  has_many :messages, dependent: :destroy
end
