require 'whedon'

module SlackJiho
  module Notify
    class << self
      def notify_jiho(dirty_time)
        # 秒は分に丸める
        time = normalized_time(dirty_time)
        return unless notify_time?(time)
        ampm = time.hour < 12 ? '午前' : '午後'
        hour = time.hour < 12 ? time.hour : time.hour - 12
        SlackJiho.notifier.post(text: "だいたい#{ampm}#{hour}時くらいをお知らせします")
      end

      private

      def normalized_time(time)
        time.sec < 30 ? time - time.sec : time - time.sec + 60
      end

      def notify_time?(time)
        return true unless SlackJiho.cron_string
        parser = Whedon::Schedule.new(SlackJiho.cron_string)
        return true if parser.matches?(time)
      end
    end
  end
end
