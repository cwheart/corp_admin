class BreakItem
  include Mongoid::Document
  store_in collection: "break_item"

  field :corp_id, type: BSON::ObjectId
  field :corp_no, type: String
  field :remote_id, type: String
  field :iname, type: String
  field :case_code, type: String
  field :reg_date, type: String

  def self.data
    pipeline = [
        {'$group': {'_id': '$corp_no', 'count': {  '$sum': 1 } }},
    ]
    BreakItem.collection.aggregate(pipeline)
  end
end
