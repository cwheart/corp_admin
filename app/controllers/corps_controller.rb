class CorpsController < ApplicationController
  before_action :set_corp, only: [:show, :edit, :update, :destroy]
  before_action :search_crops, only: [:index, :export]

  # GET /corps
  # GET /corps.json
  def index
    @corps = @corps.page(params[:page]).per(50)
  end

  # GET /corps/1
  # GET /corps/1.json
  def show
    blacks = BlackListItem.data.map(&:values).to_h
    break_items = BreakItem.data.map(&:values).to_h
    punishe_list = AdministrativePunish.data.map(&:values).to_h
    manage_list = AbnormalOperation.data.map(&:values).to_h
    bid_list = BidItem.data.map(&:values).to_h

    black_lists = {}
    # 黑名单
    blacks.each do |k, v|
      black_lists[k] ||= 0
      black_lists[k] += v
    end
    # 行政处罚
    punishe_list.each do |k, v|
      black_lists[k] ||= 0
      black_lists[k] += v
    end
    # 经营异常
    manage_list.each do |k, v|
      black_lists[k] ||= 0
      black_lists[k] += v
    end

    @blacklist_count = black_lists[@corp.no] || 0
    @black_count = blacks[@corp.no] || 0
    @punishe_count = punishe_list[@corp.no] || 0
    @manage_risk_count = manage_list[@corp.no] || 0
    @law_rist_count = @corp.doc_count
    @bid_count = bid_list[@corp.no] || 0
    @break_count = break_items[@corp.no] || 0
  end

  def export
    file_path = Rails.root.join('public', 'exports', "export-#{Time.now.to_i}.xls")
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).concat %w{企业名称 企业统一信用代码 法人 邮箱 电话 注册资本 成立日期 黑名单数量 行政处罚 工商异常数量 严重违法 法院诉讼数量 招投标数据 纳税额 公司社保缴纳人数}

    blacks = BlackListItem.data.map(&:values).to_h
    break_items = BreakItem.data.map(&:values).to_h
    punishe_list = AdministrativePunish.data.map(&:values).to_h
    manage_list = AbnormalOperation.data.map(&:values).to_h
    bid_list = BidItem.data.map(&:values).to_h

    black_lists = {}
    # 黑名单
    blacks.each do |k, v|
      black_lists[k] ||= 0
      black_lists[k] += v
    end
    # 行政处罚
    punishe_list.each do |k, v|
      black_lists[k] ||= 0
      black_lists[k] += v
    end
    # 经营异常
    manage_list.each do |k, v|
      black_lists[k] ||= 0
      black_lists[k] += v
    end

    @corps.each_with_index do |corp, index|
      blacklist_count = black_lists[corp.no] || 0
      black_count = blacks[corp.no] || 0
      punishe_count = punishe_list[corp.no] || 0
      manage_risk_count = manage_list[corp.no] || 0
      law_rist_count = corp.doc_count
      bid_count = bid_list[corp.no] || 0
      row = sheet.row(index + 1)
      row.push corp.name
      row.push corp.no
      row.push corp.legal_person
      row.push corp.email
      row.push corp.phone
      row.push corp.regcaption
      row.push corp.est_date
      row.push blacklist_count
      row.push punishe_count
      row.push manage_risk_count
      row.push black_count
      row.push law_rist_count
      row.push bid_count
      row.push '暂无数据'
      row.push '暂无数据'
    end

    book.write file_path
    send_file file_path, type: 'text/plain', disposition: 'attachment'
  end

  # GET /corps/new
  def new
    @corp = Corp.new
  end

  # GET /corps/1/edit
  def edit
  end

  # POST /corps
  # POST /corps.json
  def create
    @corp = Corp.new(corp_params)

    respond_to do |format|
      if @corp.save
        format.html { redirect_to @corp, notice: 'Corp was successfully created.' }
        format.json { render :show, status: :created, location: @corp }
      else
        format.html { render :new }
        format.json { render json: @corp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /corps/1
  # PATCH/PUT /corps/1.json
  def update
    respond_to do |format|
      if @corp.update(corp_params)
        format.html { redirect_to @corp, notice: 'Corp was successfully updated.' }
        format.json { render :show, status: :ok, location: @corp }
      else
        format.html { render :edit }
        format.json { render json: @corp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corps/1
  # DELETE /corps/1.json
  def destroy
    @corp.destroy
    respond_to do |format|
      format.html { redirect_to corps_url, notice: 'Corp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corp
      @corp = Corp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def corp_params
      params.require(:corp).permit(:name, :no)
    end

    def search_crops
      if params[:form].blank?
        params[:d101t] = true
        params[:d101a] = true
        params[:d110a] = true
        params[:blacklist] = true
        params[:manage] = true
        params[:bid] = true
        params[:law] = true
        params[:tax] = true
        params[:shixin] = true
      end
      @corps = Corp.all
      scopes = []
      scopes << { d101t: true } if params[:d101t]
      scopes << { d101a: true } if params[:d101a]
      scopes << { d110a: true } if params[:d110a]
      scopes = {no: 'unknown'} if scopes.blank?
      @corps = @corps.or(scopes)

      if params[:blacklist]
        # 黑名单
        black_lists = {}
        BlackListItem.data.each do |item|
          black_lists[item['_id']] ||= 0
          black_lists[item['_id']] += item['count']
        end
        # 行政处罚
        AdministrativePunish.data.each do |item|
          black_lists[item['_id']] ||= 0
          black_lists[item['_id']] += item['count']
        end
        # 经营异常
        AbnormalOperation.data.each do |item|
          black_lists[item['_id']] ||= 0
          black_lists[item['_id']] += item['count']
        end
        nos = black_lists.select{|k, v| v >= 10 }.keys
        Rails.logger.info(nos)
        @corps = @corps.where(no: {'$nin': nos })
      end

      # 工商经营异常（即经营异常大于0）
      if params[:manage]
        nos = AbnormalOperation.data.select {|item| item['count'] > 0 }.map { |item| item['_id'] }
        @corps = @corps.where(no: { '$in': nos})
      end

      # 法院诉讼大于20个
      @corps = @corps.where(doc_count: { '$gt': 20 }) if params[:law]
      @corps = @corps.where(no: { '$nin': BidItem.suit_nos }) if params[:bid]

      if params[:shixin]
        nos = BreakItem.data.select {|item| item['count'] <= 10 }.map { |item| item['_id'] }
        @corps = @corps.where(no: { '$in': nos})
      end
    end
end
