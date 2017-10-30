require 'slack-notifier'
require 'forwardable'

require 'slack_jiho/version'
require 'slack_jiho/notify'

module SlackJiho
  class << self
    extend Forwardable
    delegate notify_jiho: Notify

    def notifier
      @notifier ||= ::Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
    end
  end
end
