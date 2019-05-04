# 经营异常
class AbnormalOperation
  store_in collection: "abnormal_operation"

  include Mongoid::Document
  field :corp_id, type: BSON::ObjectId
  field :corp_no, type: String

  # 经营异常
  def self.data
    pipeline = [
        {'$group': {'_id': '$corp_no', 'count': {  '$sum': 1 } }},
    ]
    AbnormalOperation.collections.aggregate(pipeline)
  end
end
