# Basic Slackbot stuff
class SlackBot
  attr_reader :bot, :app, :user_id

  def initialize(user_id)
    @app = create_slack_client($memory.access_token)
    @bot = create_slack_client($memory.bot_access_token)
    @user_id = user_id
  end

  def dm(text)
    return unless text && user_id
    channel_id = open_channel
    if text.is_a? Hash
      text[:as_user] ||= true
      text[:channel] ||= channel_id
      bot.chat_postMessage(text)
    else
      bot.chat_postMessage(as_user: 'true', channel: channel_id, text: text)
    end
  end

  def dialog(trigger_id, message)
    bot.dialog_open(trigger_id: trigger_id, dialog: message)
  end

  def close_dm(channel)
    bot.im_close(channel: channel)
  end

  def delete_message(channel_id, ts)
    bot.chat_delete(channel: channel_id, ts: ts)
  end

  def post_to_channel(text, channel = home[:channel_id])
    if text.is_a? Hash
      text[:as_user] ||= false
      text[:channel] ||= channel
      bot.chat_postMessage(text)
    else
      bot.chat_postMessage(as_user: 'false', channel: channel, text: text)
    end
  end

  def update_form(form, channel_id, ts)
    form[:channel] = channel_id
    form[:ts] = ts
    bot.chat_update(form)
  end

  def open_channel
    bot.im_open(user: user_id)['channel']['id']
  rescue => error
    puts 'open_channel: ' + error.message
  end

  def channel_id(channel_name)
    bot.channels_info(channel: "##{channel_name}")['channel']['id']
  end

  def channel_name(id)
    bot.channels_info(channel: id)['channel']['name']
  end

  def username(id)
    return 'unknown' if id.nil?
    bot.users_info(user: id)['user']['name']
  end

  def create_channel(channel_name)
    puts "Creating channel #{channel_name}"
    app.channels_create(name: channel_name)['channel']['id']
  rescue => error
    puts 'create channel: ' + error.message
  end

  private

  def usergroups
    @usergroups ||= app.usergroups_list.usergroups
  end

  def group_id(group_name)
    usergroups.select { |g| g.handle == group_name }.first.id
  rescue => error
    puts "Group ID lookup error (#{group_name})"
    puts error.message
  end

  def create_slack_client(api_secret)
    Slack.configure do |config|
      config.token = api_secret
      raise 'Missing API token' unless config.token
    end
    Slack::Web::Client.new
  end
end
