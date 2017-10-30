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

    def cron_string
      ENV['CRON_STRING']
    end
  end
end
