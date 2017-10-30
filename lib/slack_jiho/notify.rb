module SlackJiho
  module Notify
    def self.notify_jiho(time)
      ampm = time.hour < 12 ? '午前' : '午後'
      hour = time.hour < 12 ? time.hour : time.hour - 12
      SlackJiho.notifier.post(text: "だいたい#{ampm}#{hour}時くらいをお知らせします")
    end
  end
end
