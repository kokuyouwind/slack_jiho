require 'whedon'

module SlackJiho
  module Notify
    class << self
      def notify_jiho(dirty_time)
        # 秒は分に丸める
        time = normalized_time(dirty_time)
        ampm = time.hour < 12 ? '午前' : '午後'
        hour = time.hour < 12 ? time.hour : time.hour - 12
        message = "だいたい#{ampm}#{hour}時くらいをお知らせします"
        notify(SlackJiho.cron_string, SlackJiho.notifier, message, time)
      end

      def adhoc_notify(cron_string, notifier, message, dirty_time)
        # 秒は分に丸める
        time = normalized_time(dirty_time)
        notify(cron_string, notifier, message, time)
      end

      private

      def notify(cron_string, notifier, message, time)
        return unless notify_time?(time, cron_string)
        notifier.post(text: message)
      end

      def normalized_time(time)
        time.sec < 30 ? time - time.sec : time - time.sec + 60
      end

      def notify_time?(time, cron_string)
        return true unless cron_string
        parser = Whedon::Schedule.new(cron_string)
        return true if parser.matches?(time)
      end
    end
  end
end
