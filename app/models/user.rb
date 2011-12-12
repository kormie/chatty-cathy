class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def friends
    @friends ||= graph.get_connections(uid, 'friends')
  end
  
  def feed
    @feed ||= graph.get_connections(uid, 'feed')
  end
  
  def wall_comments
    feed.collect do |post|
      post['comments']['data'] if post['comments']['count'] > 0
    end.flatten.compact
  end
  
  def friends_with_comments
    @commenter_name_and_frequency ||= wall_comments.group_by{|comment| comment['from']['name']}.collect do |comment|
      {name: comment[0], count: comment[1].size}
    end.sort_by{|commenter| commenter[:frequency]}
  end
end
