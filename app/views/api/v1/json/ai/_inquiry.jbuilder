json.id item.id.to_s
json.klass item.class.name
json.resource_name item.class.name.underscore

fields = [
  :kind
]

json.(item, *fields, :created_at, :updated_at)

return unless deep

messages = item.messages

json.messages messages do |message|
  json.id message.id.to_s
  json.slug "ai/messages/#{message.id}"
  json.partial! 'api/v1/json/ai/message', item: message, deep: true
end 
