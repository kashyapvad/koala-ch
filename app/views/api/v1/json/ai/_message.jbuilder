json.id item.id.to_s
json.klass item.class.name
json.resource_name item.class.name.underscore

fields = [
  :user_content,
  :user_copy,
  :llm_response_content,
]

json.(item, *fields, :created_at, :updated_at)

return unless deep
