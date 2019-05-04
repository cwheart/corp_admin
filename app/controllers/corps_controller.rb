class CorpsController < ApplicationController
  before_action :set_corp, only: [:show, :edit, :update, :destroy]

  # GET /corps
  # GET /corps.json
  def index
    @corps = Corp.all
    scopes = []
    scopes << { d101t: true } if params[:d101t]
    scopes << { d101a: true } if params[:d101a]
    scopes << { d110t: true } if params[:d110t]
    scopes << { d110a: true } if params[:d110a]
    @corps = @corps.or(scopes)
    @corps.where('no.in': BidItem.suit_nos) if params[:bid]
    @corps.where('no.in': BlackListItem.suit_nos) if params[:black_list]
    @corps.where('no.in': AbnormalOperation.suit_nos) if params[:manage]
    @corps.where('no.in': BlackListItem.suit_nos) if params[:law]

    @corps = @corps.where('doc_count.gt': 20) if params[:law]
  end

  # GET /corps/1
  # GET /corps/1.json
  def show
  end

  def export
    @corps = Corp.all
    file_path = Rails.root.join('public', 'exports', "export-#{Time.now.to_i}.csv")
    File.open(file_path, 'w') do |f|
      @corps.each do |corp|
        f.write("#{corp.name},#{corp.no}\r\n")
      end
    end
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
end
