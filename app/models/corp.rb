class Corp
  include Mongoid::Document
  field :name, type: String
  field :no, type: String
  field :legal_person, type: String
  field :area, type: String
  field :address, type: String
  field :corp_type, type: String
  field :phone, type: String
  field :created_at, type: DateTime
  field :email, type: String
  field :register_amount, type: String
  field :regcap_cur, type: String
  field :est_date, type: String
  field :regcaption, type: String
  field :doc_count, type: Integer
  field :pension_insurance, type: Integer
  field :tax_amount, type: String
  field :bid_count, type: Integer
  field :d101a, type: Boolean
  field :d101t, type: Boolean
  field :d110a, type: Boolean
  field :d110t, type: Boolean

  def scopes
    result = []
    result << '房建特级' if d101t
    result << '房建一级' if d101a
    result << '市政特级' if d110t
    result << '市政一级' if d110a
    result.join('/')
  end
end
