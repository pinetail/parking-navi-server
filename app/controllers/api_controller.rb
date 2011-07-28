class ApiController < ApplicationController
  def export
    
    # データベースからの検索処理
#    @shops = Shop.all
    @shops = Shop.where('use_flg = 1')
    
    # 出力ファイルのコンテンツタイプの決定
    cntnt_type = ""
    if request.user_agent =~ /windows/i then
      # クライアント環境がWindowsの場合はExcel形式で返す
      cntnt_type = "application/vnd.ms-excel"
    else
      # それ以外の場合にはCSV形式で返す
      cntnt_type = "text/csv"
    end
    
        # ファイル名称の設定
    file_name = Time.now.strftime("%Y%m%d")
    tmp_zip = "#{RAILS_ROOT}/public/system/files/#{file_name}.zip"
    
    # CSVオブジェクトを生成し、データをセットしていく
    csv_text = FasterCSV.generate(:force_quotes => true) do |csv|
#    CSV::Writer.generate(output = "") do |csv|
      for shop in @shops
        csv << [shop.name, shop.address, shop.tel, shop.gotochi_category, shop.tabelog_id, shop.business_hours, 
        shop.holiday, shop.latitude, shop.longitude, shop.score, shop.tabelog_url, shop.tabelog_mobile_url, 
        shop.station, shop.memo]
      end
    end
    
    Zip::Archive.open(tmp_zip, Zip::CREATE) do |ar|
      ar.add_buffer("#{file_name}.csv", NKF.nkf('-U -s -Lw', csv_text))
    end

    # CSVファイルの出力
#    send_data(NKF.nkf('-U -s -Lw', output), :type => cntnt_type, :filename => file_name)

  end

end
