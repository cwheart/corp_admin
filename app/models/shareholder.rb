class Shareholder
  include Mongoid::Document
  store_in collection: "shareholder"

  field :corp_no, type: String
  field :name, type: BSON::ObjectId
end
