class InquiryResponseService
  include HTTParty

  PROMPT = "You are an AI assistant that helps sales representatives compose response emails to customer inquiries. The sales reps use your service to generate these emails. You have been provided with:\n\nBattle Card Data: A list of topics with corresponding responses about the product or service the sales rep's company offers.\nPublic Documentation: Additional information provided as plain text, which may include helpful links.\nCustomer's Email Inquiry: The email body containing the customer's questions.\nYour Task:\n\nFirst, search through the Battle Card Data to find answers to the customer's inquiries.\nThen, select relevant links from the Public Documentation that are applicable to the customer's inquiry.\nExtract the exact questions from the customer's email inquiry without altering them.\nFor each question, provide an answer based solely on the Battle Card Data and Public Documentation.\nIf an answer to a question is not available in the Battle Card Data or Public Documentation, respond with \"answer\": \"N/A\" for that question in the answers segment only.\nCompose a professional and helpful email response from the sales rep to the customer, incorporating all the answers you found and including the relevant link(s).\nDo not include any 'N/A' answers or mention questions for which you could not find answers in the email.\nEnsure that relevant links from the Public Documentation are included in the email when applicable.\nUse the answers and links to address the most important concerns in the customer's inquiry.\nEnsure the email:\nIs written from the perspective of the sales rep's company (not Koala).\nDoes not mention Koala or indicate that an AI assistant or service was used to generate the email.\nIs clear, concise, and maintains a friendly and respectful tone.\nAvoid using any Markdown formatting in the email (e.g., no ** for bold or [text](link) for hyperlinks).\nFormat links by placing the URL in parentheses immediately after the link text. For example: \"Please visit our Integration Guide (https://yourcompany.com/integration-guide) for more details.\"\nDo Not include any information not found in the Battle Card Data or Public Documentation.\nDo Not hallucinate or make up any information.\nOutput Format:\n\nProvide your response in a JSON format without any code block formatting or Markdown:\n\n{ \"email_response\": \"Your composed email response here.\", \"answers\": [ { \"question\": \"Question 1 from the customer's email.\", \"answer\": \"Answer 1 based on Battle Card Data or Public Documentation.\" }, { \"question\": \"Question 2 from the customer's email.\", \"answer\": \"Answer 2 based on Battle Card Data or Public Documentation.\" } // Add more question-answer pairs as needed. ] }\n\nNote: If an answer to a question is not available in the Battle Card Data or Public Documentation, respond with \"answer\": \"N/A\" for that question in the answers segment only. The \"email_response\" should only include information based on the answers found and should not mention unanswered questions or include 'N/A'.\nBattle Card Data:\n\n{{ BATTLECARD_DATA }}\n\nPublic Documentation:\n\n{{ PUBLIC_DOCS_DATA }}\n\nCustomer's Email Inquiry:\n\n{{ CUSTOMER_EMAIL_INQUIRY }}"
  INQUIRY_PLACEHOLDER = "{{ CUSTOMER_EMAIL_INQUIRY }}"
  BATTLECARD_PLACEHOLDER = "{{ BATTLECARD_DATA }}"
  PUBLIC_DOC_PLACEHOLDER = "{{ PUBLIC_DOCS_DATA }}"
  DEFAULT_LLM_MODEL= 'open_ai'


  def self.process_message message, options={}
    opts = options.with_indifferent_access
    return unless message.user_content.present?
    model = opts[:llm_model] || DEFAULT_LLM_MODEL
    response = HTTParty.get(ENV['PUBLIC_DOCS_MARK_DOWN'])
    public_docs_markdown ||= PUBLIC_DOCS_MARK_DOWN
    public_docs_markdown ||= response.parsed_response if response.success?
    return unless public_docs_markdown
    battle_cards = BattleCard.all.map{|b| {topic: b.topic, response: b.response} }.to_s
    prompt = PROMPT.gsub(INQUIRY_PLACEHOLDER, message.user_content)
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

  def self.search_battlecards message, options={}
    opts = options.with_indifferent_access
    
  end

end