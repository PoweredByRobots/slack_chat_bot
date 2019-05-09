# Slack Chat Bot
A framework for an AI Slack Chat bot

## Setup

### Create Slack App
- Go to Slack and create a new App https://api.slack.com/apps?new_app=1
- Go to the app's "Basic Information" page and add the following values to your environment: 
  - Client ID -> `SLACK_CLIENT_ID`
  - API secret/Client secret -> `SLACK_API_SECRET`
  - Signing secret -> `SLACK_VERIFICATION_TOKEN`
  - Set `ADMIN_ID` to your Slack @<user-id> (without the @)

### Create Slack Bot
- Go to: https://api.slack.com/apps/{app_id}/bots and Add a Bot User.
- Go to "Install App".
- Click "Install App to Workspace".
- Click "Authorize" to install to your workspace.
- Copy the access tokens displayed to environment variables:
  - OAuth Access Token -> `ACCESS_TOKEN`
  - Bot User OAuth Access Token -> `BOT_ACCESS_TOKEN`
- Also set the `BOT_USER_ID` env var to the @<user-id> from the "Default
  username" field of the bot user (without the @).

### Local Postgres
- Set env vars:
  - `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DATABASE` -> name_of_your_choice
  - `POSTGRES_HOST` -> `db`
  - `POSTGRES_PORT` -> `5432`

### After Initial Setup

- get an ngrok public url with the below command.
- note that by default the ngrok url will expire after 8 hours.
```curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.name == "command_line") | .public_url'```

### After ngrok URL is available
- Go to: https://api.slack.com/apps/{app_id}/event-subscriptions and set the request URL to: `https://{ngrok_host}/events`
- Subscribe to the following Bot events:
  - message.channels
  - message.groups
  - message.im
  - message.mpim
- Go to: https://api.slack.com/apps/{app_id}/slash-commands and create an `/chatbot` command with the request URL:
  - https://{ngrok_host}/commands
  - enable _Escape channels, users, and links sent to your app_
- Go to: https://api.slack.com/apps/{app_id}/interactive-messages and set the request URL to:
  - https://{ngrok_host}/buttons
- type `/chatbot` to engage directly with the bot
