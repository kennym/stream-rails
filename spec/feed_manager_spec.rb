require 'spec_helper'
require 'json'


describe 'StreamRails::FeedManager' do
    subject { feed_manager }

    context "instance from StreamRails" do
      let(:feed_manager) { StreamRails.feed_manager }
      specify { feed_manager.client.should be_an_instance_of Stream::Client }
      specify { feed_manager.get_user_feed(1).should be_an_instance_of Stream::Feed }
      specify { feed_manager.get_user_feed(1).feed_id.should eq 'user:1' }
      specify { feed_manager.get_news_feeds(1).should be_an_instance_of Hash }
      specify { feed_manager.get_news_feeds(1)[:flat].should be_an_instance_of Stream::Feed }
      specify { feed_manager.get_news_feeds(1)[:flat].feed_id.should eq 'flat:1' }
      specify { feed_manager.get_news_feeds(1)[:aggregated].should be_an_instance_of Stream::Feed }
      specify { feed_manager.get_news_feeds(1)[:aggregated].feed_id.should eq 'aggregated:1' }
      specify { feed_manager.get_notification_feed(1).should be_an_instance_of Stream::Feed }
      specify { feed_manager.get_feed('flat', 1).should be_an_instance_of Stream::Feed }
    end

    context "follow and unfollow" do
        let(:feed_manager) { StreamRails.feed_manager }

        specify {
          feed_manager.follow_user(1, 2)
          body = JSON.parse(FakeWeb.last_request.body)
          body['target'].should eq 'user:2'
        }
        specify {
          feed_manager.unfollow_user(1, 2)
          FakeWeb.last_request.method.should eq 'DELETE'
        }

    end

end