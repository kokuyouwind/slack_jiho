require 'whedon'

module SlackJiho
  module Notify
    class << self
      def notify_jiho(time)
        return unless notify_time?(time)
        ampm = time.hour < 12 ? '午前' : '午後'
        hour = time.hour < 12 ? time.hour : time.hour - 12
        SlackJiho.notifier.post(text: "だいたい#{ampm}#{hour}時くらいをお知らせします")
      end

      private

      def notify_time?(time)
        return true unless SlackJiho.cron_string
        parser = Whedon::Schedule.new(SlackJiho.cron_string)
        parser.matches?(time)
      end
    end
  end
end
