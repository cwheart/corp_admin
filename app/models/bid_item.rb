class BidItem
  include Mongoid::Document
  field :corp_id, type: BSON::ObjectId
  field :corp_no, type: String
  field :bid_id, type: BSON::ObjectId
  field :published_at, type: DateTime
  field :title, type: String
  field :channel, type: String

  # 近两年中标数量小于3个
  def self.latest_two_years
    begin_time = 2.years.ago
    pipeline = [
        {'$match': {'channel': '中标公告', 'published_at': {'$gt': two_years_ago} } },
        {'$group': {'_id': '$corp_no', 'count': {  '$sum': 1 } }},
    ]
    BidItem.collection.aggregate(pipeline)
  end

  # 半年内没有招投标
  def self.latest_six_months
    begin_time = 6.months.ago
    pipeline = [
        {'$match': {'channel': '招标公告', 'published_at': {'$gt': begin_time} } },
        {'$group': {'_id': '$corp_no', 'count': {  '$sum': 1 } }},
    ]
    BidItem.collection.aggregate(pipeline)
  end

  def self.suit_nos
    []
  end
end
