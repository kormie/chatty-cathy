require 'spec_helper'

describe FacebookController do

  describe 'index with GET' do
    before do
      @user = User.new(mock('graph'), 42)
      @oauth = mock('oauth')
      @graph = mock('graph')
      Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
    end

    context 'when logged into facebook' do
      before do
        user_info = {'access_token' => '1234567890', 'uid' => 42}
        @oauth.should_receive(:get_user_info_from_cookie).and_return(user_info)
        Koala::Facebook::GraphAPI.should_receive(:new).with('1234567890').and_return(@graph)
        User.should_receive(:new).and_return(@user)
        @likes = mock('likes')
        @friends = mock('friends')
        @user.should_receive(:likes_by_category).and_return(@likes)
        @user.should_receive(:friends).and_return(@friends)

        get :index
      end

      it do
        response.should be_success
      end

      it 'should assign likes' do
        assigns[:likes_by_category].should == @likes
      end

      it "assigns friends" do
        assigns[:friends].should == @friends
      end
    end

    context 'when not logged into facebook' do
      before do
        @oauth.should_receive(:get_user_info_from_cookie).and_return(nil)

        get :index
      end

      it 'should redirect to the login page' do
        response.should redirect_to(:action => :login)
      end
    end
  end
  
  describe "show with GET" do
    before do
      @user = User.new(mock('graph'), 42)
      @oauth = mock('oauth')
      @graph = mock('graph')
      user_info = {'access_token' => '1234567890', 'uid' => 42}
      Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
      @oauth.should_receive(:get_user_info_from_cookie).and_return(user_info)
      @friend = User.new(@graph, 2405339)
      
      get :show, id: 2405339
    end
    
    it "is successful" do
      response.should be_success
    end
    
    it "assigns the friend" do
      assigns[:friend].uid.should == @friend.uid
    end

    
  end

  describe 'login with GET' do
    before do
      get :login
    end

    it do
      response.should be_success
    end
  end
end
