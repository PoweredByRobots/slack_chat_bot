require 'slack-ruby-client'
require_relative 'lib/api'
require_relative 'lib/message'
require_relative 'lib/pinger'
require_relative 'lib/memory'

SLACK_CONFIG = {
  slack_client_id: ENV['SLACK_CLIENT_ID'],
  slack_api_secret: ENV['SLACK_API_SECRET'],
  slack_verification_token: ENV['SLACK_VERIFICATION_TOKEN']
}.freeze

missing_params = SLACK_CONFIG.select { |_key, value| value.nil? }
if missing_params.any?
  error_msg = missing_params.keys.join(', ').upcase
  raise "Missing Slack config variables: #{error_msg}"
end

$memory = Memory.new(bot_user_id: ENV['BOT_USER_ID'],
                          bot_access_token: ENV['BOT_ACCESS_TOKEN'],
                          access_token: ENV['ACCESS_TOKEN'],
                          channel: 'incident')
