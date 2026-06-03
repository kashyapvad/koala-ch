# Koala

An AI sales-assistance tool that helps sales reps craft fast, on-brand
responses to common customer questions and objections. A React frontend talks
to a Ruby on Rails API that assembles a prompt from the team's battle cards and
public docs, sends it to an LLM, and returns a ready-to-send reply.

**Live demo:** https://koala-web-ui-ch.netlify.app/

## How it works

1. A rep submits a customer inquiry (email, phone, or chat).
2. `InquiryResponseService` builds a prompt by injecting three sources into a
   template — the customer's message, the team's **battle cards**
   (topic/response pairs), and a public-docs knowledge base pulled at runtime.
3. The prompt is dispatched to a **pluggable LLM client**, and the structured
   response (plus a ready-to-send copy) is persisted on the message.

```
React app ──► Rails API (api/v1/ai) ──► InquiryResponseService
                                            ├── BattleCard context
                                            ├── public-docs context
                                            └── {model}_client ──► LLM (OpenAI)
```

## Design notes

- **Provider-agnostic LLM layer** — the service resolves its client dynamically
  (`"#{model}_client".camelize.constantize`), so adding a new LLM provider is a
  new `*_client` class, no changes to the calling code.
- **Prompt templating** — context is injected via named placeholders
  (`{{ CUSTOMER_EMAIL_INQUIRY }}`, `{{ BATTLECARD_DATA }}`,
  `{{ PUBLIC_DOCS_DATA }}`), keeping prompt structure separate from data.
- **Auditable responses** — each `Message` stores the model used, the raw LLM
  response as `jsonb`, and the extracted reply, so generations can be inspected
  and replayed.
- **Versioned API** — endpoints live under `api/v1/ai/...` with JBuilder views,
  leaving room to evolve the contract without breaking the frontend.
- **Extensible domain** — `Inquiry has_many :messages` models a conversation,
  ready to grow into multi-turn threads and additional inquiry channels.

## Tech stack

- **Backend:** Ruby on Rails 7.2, PostgreSQL, JBuilder, rack-cors, HTTParty
- **Frontend:** React (Create React App), deployed on Netlify
- **AI:** OpenAI via a swappable client interface

## Getting started

### API

```bash
bundle install
rails db:create db:migrate db:seed   # seeds battle cards
# set OPENAI_API_KEY and PUBLIC_DOCS_MARK_DOWN_URL in your env
rails server
```

### Frontend

```bash
cd react-app
npm install
npm start
