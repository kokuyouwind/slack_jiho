require 'spec_helper'

RSpec.describe SlackJiho::Notify do
  let(:notifier) { double('slack-notifier') }
  before { allow(SlackJiho).to receive(:notifier).and_return(notifier) }

  describe '#notify_jiho' do
    shared_examples '時報を通知する' do |hour, text|
      let(:time) { Time.local(2017, 1, 1, hour) }
      it do
        expect(notifier).to receive(:post).with(text: text)
        described_class.notify_jiho(time)
      end
    end

    it_behaves_like '時報を通知する', 0, 'だいたい午前0時くらいをお知らせします'
    it_behaves_like '時報を通知する', 1, 'だいたい午前1時くらいをお知らせします'
    it_behaves_like '時報を通知する', 11, 'だいたい午前11時くらいをお知らせします'
    it_behaves_like '時報を通知する', 12, 'だいたい午後0時くらいをお知らせします'
    it_behaves_like '時報を通知する', 13, 'だいたい午後1時くらいをお知らせします'
    it_behaves_like '時報を通知する', 23, 'だいたい午後11時くらいをお知らせします'
  end
end
