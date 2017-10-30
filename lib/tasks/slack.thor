# encoding: utf-8

require 'dotenv/load'
require 'slack_jiho'

class Slack < Thor
  desc 'jiho', 'notify current time'
  def jiho
    SlackJiho.notify_jiho(Time.now)
  end
end
