class BlackListItem
  store_in collection: "black_list_item"

  include Mongoid::Document
  field :corp_id, type: BSON::ObjectId
  field :corp_no, type: String

  # 黑名单
  def self.data

    pipeline = [
        {'$group': {'_id': '$corp_no', 'count': {  '$sum': 1 } }},
    ]
    BlackListItem.collections.aggregate(pipeline)
  end

  def self.suit_nos

  end
end
