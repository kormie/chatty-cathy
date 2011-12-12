require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end
  
  describe "feed" do
    before do
      @feed = [
        {
          "id" => "100000359811554_189592254396100",
          "from" => {
            "name" => "David Kormushoff",
            "id" => "100000359811554"
          },
          "story" => "\"is that kalikow?\" on Molly Chen's photo.",
          "story_tags" => {
            "22" => [
              {
                "id" => 2418169,
                "name" => "Molly Chen",
                "offset" => 22,
                "length" => 10
              }
            ]
          },
          "type" => "status",
          "application" => {
            "name" => "Photos",
            "id" => "2305272732"
          },
          "created_time" => "2011-02-16T14:11:51+0000",
          "updated_time" => "2011-02-16T14:11:51+0000",
          "comments" => {
            "count" => 0
          }
        },
        {
          "id" => "100000359811554_177257398985019",
          "from" => {
            "name" => "David Kormushoff",
            "id" => "100000359811554"
          },
          "message" => "Heard at a programming meetup last night while jotting a note:\n\"You use paper???\"",
          "actions" => [
            {
              "name" => "Comment",
              "link" => "https://www.facebook.com/100000359811554/posts/177257398985019"
            },
            {
              "name" => "Like",
              "link" => "https://www.facebook.com/100000359811554/posts/177257398985019"
            }
          ],
          "privacy" => {
            "description" => "Public",
            "value" => "EVERYONE"
          },
          "type" => "status",
          "created_time" => "2011-02-11T15:43:05+0000",
          "updated_time" => "2011-02-11T16:49:32+0000",
          "comments" => {
            "data" => [
              {
                "id" => "100000359811554_177257398985019_2226759",
                "from" => {
                  "name" => "Danny Gornetzki",
                  "id" => "2405339"
                },
                "message" => "man, the computer geek on computer geek violence needs to stop.",
                "created_time" => "2011-02-11T15:53:31+0000"
              },
              {
                "id" => "100000359811554_177257398985019_2226759",
                "from" => {
                  "name" => "Danny Gornetzki",
                  "id" => "2405339"
                },
                "message" => "man, the computer geek on computer geek violence needs to stop.",
                "created_time" => "2011-02-11T15:53:31+0000"
              },
              {
                "id" => "100000359811554_177257398985019_2227152",
                "from" => {
                  "name" => "David Kormushoff",
                  "id" => "100000359811554"
                },
                "message" => "It's getting bad",
                "created_time" => "2011-02-11T16:49:32+0000"
              }
            ],
            "count" => 2
          }
        }
      ]
      @post_comments = [
        {
          "id" => "100000359811554_177257398985019_2226759",
          "from" => {
            "name" => "Danny Gornetzki",
            "id" => "2405339"
          },
          "message" => "man, the computer geek on computer geek violence needs to stop.",
          "created_time" => "2011-02-11T15:53:31+0000"
        },
        {
          "id" => "100000359811554_177257398985019_2226759",
          "from" => {
            "name" => "Danny Gornetzki",
            "id" => "2405339"
          },
          "message" => "man, the computer geek on computer geek violence needs to stop.",
          "created_time" => "2011-02-11T15:53:31+0000"
        },
        {
          "id" => "100000359811554_177257398985019_2227152",
          "from" => {
            "name" => "David Kormushoff",
            "id" => "100000359811554"
          },
          "message" => "It's getting bad",
          "created_time" => "2011-02-11T16:49:32+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'feed').once.and_return(@feed)
    end
    it "gets the user's feed" do
      @user.feed.should == @feed
    end
    
    describe "comments" do
      it "only returns posts with comments" do
        @user.wall_comments.should == @post_comments
      end
    end
    
    describe "friends with comments" do
      it "returns the correct friends and count" do
        @friends_with_comments_hash = [
            {
              name: 'Danny Gornetzki',
              count: 2
            },
            {
              name: 'David Kormushoff',
              count: 1
            }
          ]
        @user.friends_with_comments.should == @friends_with_comments_hash
      end
    end
  end
  
  describe "friends" do
    before do
      @friends = [
        {
          "name" => "Danny Gornetzki",
          "id" => "2405339"
        },
        {
          "name" => "Adam Eisenstein",
          "id" => "2405857"
        },
        {
          "name" => "David Schiff",
          "id" => "2405974"
        },
        {
          "name" => "Ryan McIntosh",
          "id" => "2406480"
        },
        {
          "name" => "Andrew Stern",
          "id" => "2406566"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)      
    end
    it 'retrieves the likes via the graph api' do
      @user.friends.should == @friends
    end

    it 'should memoize the result after the first call' do
      friends1 = @user.friends
      friends2 = @user.friends
      friends2.should equal(friends1)
    end
  end

  describe 'retrieving likes' do
    before do
      @likes = [
        {
          "name" => "The Office",
          "category" => "Tv show",
          "id" => "6092929747",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Flight of the Conchords",
          "category" => "Tv show",
          "id" => "7585969235",
          "created_time" => "2010-08-22T06:33:56+0000"
        },
        {
          "name" => "Wildfire Interactive, Inc.",
          "category" => "Product/service",
          "id" => "36245452776",
          "created_time" => "2010-06-03T18:35:54+0000"
        },
        {
          "name" => "Facebook Platform",
          "category" => "Product/service",
          "id" => "19292868552",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Twitter",
          "category" => "Product/service",
          "id" => "20865246992",
          "created_time" => "2010-05-02T14:07:10+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'likes').once.and_return(@likes)
    end

    describe '#likes' do
      it 'should retrieve the likes via the graph api' do
        @user.likes.should == @likes
      end

      it 'should memoize the result after the first call' do
        likes1 = @user.likes
        likes2 = @user.likes
        likes2.should equal(likes1)
      end
    end

    describe '#likes_by_category' do
      it 'should group by category and sort categories and names' do
        @user.likes_by_category.should == [
          ["Product/service", [
            {
              "name" => "Facebook Platform",
              "category" => "Product/service",
              "id" => "19292868552",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Twitter",
              "category" => "Product/service",
              "id" => "20865246992",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Wildfire Interactive, Inc.",
              "category" => "Product/service",
              "id" => "36245452776",
              "created_time" => "2010-06-03T18:35:54+0000"
            }
          ]],
          ["Tv show", [
            {
              "name" => "Flight of the Conchords",
              "category" => "Tv show",
              "id" => "7585969235",
              "created_time" => "2010-08-22T06:33:56+0000"
            },
            {
              "name" => "The Office",
              "category" => "Tv show",
              "id" => "6092929747",
              "created_time" => "2010-05-02T14:07:10+0000"
            }
          ]]
        ]
      end
    end
  end
end
