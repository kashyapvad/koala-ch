# == Schema Information
#
# Table name: battle_cards
#
#  id         :bigint           not null, primary key
#  topic      :string
#  response   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BattleCard < ApplicationRecord
end
