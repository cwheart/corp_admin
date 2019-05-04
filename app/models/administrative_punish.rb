# 行政处罚
class AdministrativePunish
  include Mongoid::Document
  store_in collection: "administrative_punish"

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
