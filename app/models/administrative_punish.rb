# 行政处罚
class AdministrativePunish
  store_in collection: "administrative_punish"
  include Mongoid::Document
  field :corp_id, type: BSON::ObjectId
  field :corp_no, type: String

  # 黑名单
  def self.data

    pipeline = [
        {'$group': {'_id': '$corp_no', 'count': {  '$sum': 1 } }},
    ]
    AdministrativePunish.collections.aggregate(pipeline)
  end
end
