# encoding: utf-8

require 'dotenv/load'
require 'slack_jiho'

class Slack < Thor
  desc 'jiho', 'notify current time'
  def jiho
    SlackJiho.notify_jiho(Time.now)
  end

  desc 'notify', 'notify any message'
  def notify(cron_string, webhook_url, message)
    SlackJiho.adhoc_notify(cron_string, webhook_url, message, Time.now)
  end
end
