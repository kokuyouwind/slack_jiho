require 'spec_helper'

RSpec.describe SlackJiho::Notify do
  let(:notifier) { double('slack-notifier') }
  before do
    allow(SlackJiho).to receive(:notifier).and_return(notifier)
    allow(SlackJiho).to receive(:cron_string).and_return(cron_string)
  end

  describe '#notify_jiho' do
    shared_examples '時報を通知する' do |hour, text|
      let(:time) { Time.local(2017, 1, 1, hour) }
      it do
        expect(notifier).to receive(:post).with(text: text)
        described_class.notify_jiho(time)
      end
    end

    shared_examples '時報を通知しない' do |hour|
      let(:time) { Time.local(2017, 1, 1, hour) }
      it do
        expect(notifier).not_to receive(:post)
        described_class.notify_jiho(time)
      end
    end

    shared_examples '30秒未満のズレがあっても時報を通知する' do |diff|
      let(:time) { Time.local(2017, 1, 1, 10) + diff }
      it do
        expect(notifier).to receive(:post).with(text: 'だいたい午前10時くらいをお知らせします')
        described_class.notify_jiho(time)
      end
    end

    shared_examples '30秒以上のズレがあったら時報を通知しない' do |diff|
      let(:time) { Time.local(2017, 1, 1, 10) + diff }
      it do
        expect(notifier).not_to receive(:post)
      end
    end

    context 'cron設定がないとき' do
      let(:cron_string) { nil }
      it_behaves_like '時報を通知する', 0, 'だいたい午前0時くらいをお知らせします'
      it_behaves_like '時報を通知する', 1, 'だいたい午前1時くらいをお知らせします'
      it_behaves_like '時報を通知する', 11, 'だいたい午前11時くらいをお知らせします'
      it_behaves_like '時報を通知する', 12, 'だいたい午後0時くらいをお知らせします'
      it_behaves_like '時報を通知する', 13, 'だいたい午後1時くらいをお知らせします'
      it_behaves_like '時報を通知する', 23, 'だいたい午後11時くらいをお知らせします'
    end

    context 'cron設定があるとき' do
      let(:cron_string) { '0 10-19 * * *' }
      it_behaves_like '時報を通知しない', 0
      it_behaves_like '時報を通知しない', 9
      it_behaves_like '時報を通知する', 10, 'だいたい午前10時くらいをお知らせします'
      it_behaves_like '時報を通知する', 12, 'だいたい午後0時くらいをお知らせします'
      it_behaves_like '時報を通知する', 19, 'だいたい午後7時くらいをお知らせします'
      it_behaves_like '時報を通知しない', 20
      it_behaves_like '時報を通知しない', 23

      it_behaves_like '30秒未満のズレがあっても時報を通知する', 29
      it_behaves_like '30秒未満のズレがあっても時報を通知する', -29
      it_behaves_like '30秒以上のズレがあったら時報を通知しない', 30
      it_behaves_like '30秒以上のズレがあったら時報を通知しない', -30
    end
  end
end
