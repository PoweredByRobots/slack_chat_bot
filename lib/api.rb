require 'sinatra/base'
require_relative 'controller'
require_relative 'view'

# Slack event handling server
class API < Sinatra::Base
  attr_reader :request_data, :user_id

  configure do
    set :root, ENV['PWD']
  end

  before do
    case request.fullpath
    when '/buttons'
      @request_data = JSON.parse(request.params['payload'])
      @user_id = request_data['user']['id']
    when '/commands'
      @request_data = request.params
      @user_id = request_data['user_id']
    when '/events'
      @request_data = JSON.parse(request.body.read)
      event = request_data['event']
      @user_id = event['user'] if event
    end
    security_check
  end

  post '/buttons' do
    case callback_id
    when 'main_menu'
      controller.main_menu(action)
    else
      controller.invalid_callback_id
    end
    status 200
  end

  post '/commands' do
    view.main_menu
    status 200
  end

  post '/events' do
    case event_type
    when 'message'
      controller.message
    when 'url_verification'
      body controller.url_verification
    else
      throw_error
    end
    status 200
  end

  get '/favicon.ico' do
    status 200
  end

  private

  def event_type
    return request_data['type'] if request_data['type'] == 'url_verification'
    request_data['event']['type'] if request_data['event']
  end

  def url_verification?
    event_type == 'url_verification'
  end

  def callback_id
    return request_data['callback_id'] if dialog_submission?
    request_data['original_message']['attachments'].first['callback_id']
  end

  def dialog_submission?
    request_data['type'] == 'dialog_submission'
  end

  def action
    request_data['actions'].first['name']
  end

  def security_check
    return if ignorable? || verified? || url_verification?
    halt 403
  end

  def token
    return unless request_data
    request_data['token']
  end

  def verified?
    SLACK_CONFIG[:slack_verification_token] == token
  end

  def ignorable?
    request.path == '/favicon.ico'
  end

  def throw_error
    puts "Unexpected event:\n#{request_data}"
  end

  def view
    View.new(request_data, user_id)
  end

  def controller
    Controller.new(request_data, user_id)
  end
end
