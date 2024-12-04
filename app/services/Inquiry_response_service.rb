class InquiryResponseService
  include HTTParty

  INQUIRY_PLACEHOLDER = "{{ CUSTOMER_EMAIL_INQUIRY }}"
  BATTLECARD_PLACEHOLDER = "{{ BATTLECARD_DATA }}"
  PUBLIC_DOC_PLACEHOLDER = "{{ PUBLIC_DOCS_DATA }}"
  DEFAULT_LLM_MODEL= 'open_ai'


  def self.process_message message, options={}
    opts = options.with_indifferent_access
    return unless message.user_content.present?
    model = opts[:llm_model] || DEFAULT_LLM_MODEL
    public_docs_markdown ||= PUBLIC_DOCS_MARK_DOWN
    response = HTTParty.get(ENV['PUBLIC_DOCS_MARK_DOWN_URL']) unless public_docs_markdown
    public_docs_markdown ||= response.parsed_response if response
    return unless public_docs_markdown
    battle_cards = BattleCard.all.map{|b| {topic: b.topic, response: b.response} }.to_s
    prompt = EMAIL_RESPONSE_PROMPT.gsub(INQUIRY_PLACEHOLDER, message.user_content)
                                  .gsub(BATTLECARD_PLACEHOLDER, battle_cards)
                                  .gsub(PUBLIC_DOC_PLACEHOLDER, public_docs_markdown)
    response = "#{model}_client".camelize.constantize.send_prompt prompt
    email_response = response[:email_response]
    message.llm_model = model
    message.llm_response = response
    message.llm_response_content = response.to_s
    message.user_copy = email_response
    message.save
  end
end