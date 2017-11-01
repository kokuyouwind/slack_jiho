require 'slack-notifier'
require 'forwardable'

require 'slack_jiho/version'
require 'slack_jiho/notify'

module SlackJiho
  class << self
    extend Forwardable
    delegate notify_jiho: Notify

    def adhoc_notify(cron_string, webhook_url, message, time)
      adhoc_notifier = ::Slack::Notifier.new(webhook_url)
      Notify.adhoc_notify(cron_string, adhoc_notifier, message, time)
    end

    def notifier
      @notifier ||= ::Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
    end

    def cron_string
      ENV['CRON_STRING']
    end
  end
end
