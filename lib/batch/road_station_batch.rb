require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'nkf'
require 'rexml/document'
require 'fastercsv'
require 'uri'
require "mysql2"
include REXML
require 'digest/md5'

class RoadStationBatch
  
  @geocode_url = "http://maps.google.com/maps/api/geocode/xml?sensor=false&address="
  @url_list = []
  # 北海道
#  @station_list = ["http://www.hokkaido-michinoeki.jp/road/station/road-station_hkd.html"]
  # 東北
#  @station_list = ["http://www.thr.mlit.go.jp/road/koutsu/roadstation/thktop/station/road-station_thk.html"]
  # 関東
#  @station_list = ["http://www.ktr.mlit.go.jp/kyoku/road/eki/station/road-station_knt.html"]
  # 北陸
#  @station_list = ["http://www.hrr.mlit.go.jp/road/station/road-station_hkr.html"]
  # 中部
#  @station_list = ["http://www.cbr.mlit.go.jp/michinoeki/station/road-station_cyb.html"]
  # 近畿
#  @station_list = ["http://ggmap.pinetail.jp/road.sjis.html"]
#  @station_list = ["http://www.kkr.mlit.go.jp/road/station/road-station_knk.html"]
  # 中国
  @station_list = ["http://www.cgr.mlit.go.jp/chiki/doyroj/michinoeki/station/road-station_cgk.html"]
  # 四国
#  @station_list = ["http://www.skr.mlit.go.jp/road/michinoeki/station/road-station_skk.html"]
  # 九州
#  @station_list = ["http://www.qsr.mlit.go.jp/n-michi/michi_no_eki/station/station/road-station_ksy.html"]
  @category = "road_station"
  @file_name = "/tmp/" + @category + "_" + Time.now.strftime("%Y%m%d%H%M%S") + '.csv'
  @csv = ''
  @station = ''
  @client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "parking-navi-server_development")
  @day = Time.now

  def self.execute
    FasterCSV.open(@file_name, "w") do |@csv|
      @station_list.each do |@station|
        page = open(@station)
        html = Nokogiri::HTML(NKF.nkf('-wS', page.read), nil, "UTF-8")
#        p html.search('//table/tbody/tr[2]/td/table/tbody/tr[2]/td[3]/table[2]/tbody/tr')

        if @station == 'http://www.qsr.mlit.go.jp/n-michi/michi_no_eki/station/station/road-station_ksy.html' then
          # 九州
          list = html.search('//table/tr/td[2]/table/tr[2]/td[3]/table[2]/tr')
        elsif @station == 'http://www.hokkaido-michinoeki.jp/road/station/road-station_hkd.html' then
          list = html.search('//table/tr[2]/td/table/tr[2]/td[3]/table[2]/tr')
        # 東北
        elsif @station == 'http://www.thr.mlit.go.jp/road/koutsu/roadstation/thktop/station/road-station_thk.html' then
          list = html.search('//table/tr[2]/td/table/tr[2]/td[3]/table[2]/tr')
        # 関東
        elsif @station == 'http://www.ktr.mlit.go.jp/kyoku/road/eki/station/road-station_knt.html' then
          list = html.search('//table/tr/td[2]/table/tr[2]/td[3]/table[2]/tr')
        # 北陸
        elsif @station == 'http://www.hrr.mlit.go.jp/road/station/road-station_hkr.html' then
          list = html.search('//table/tr/td[2]/table/tr[2]/td[3]/table[2]/tr')
        # 中部
        elsif @station == 'http://www.cbr.mlit.go.jp/michinoeki/station/road-station_cyb.html' then
          list = html.search('//table/tr[2]/td/table/tr[2]/td[3]/div[3]/table/tr')
        # 近畿
        elsif @station == 'http://ggmap.pinetail.jp/road.sjis.html' then
          list = html.search('//table/tr[2]/td/table/tr[2]/td[3]/table[2]/tr')
        # 中国
        elsif @station == 'http://www.cgr.mlit.go.jp/chiki/doyroj/michinoeki/station/road-station_cgk.html' then
          list = html.search('//table/tr[2]/td/table/tr[2]/td[3]/table[2]/tr')
        else
          # 北海道〜四国
          list = html.search('//table/tbody/tr[2]/td/table/tbody/tr[2]/td[3]/table[2]/tbody/tr')
        end
      p list
#        list = html.search('//table/tr[2]/td/table/tr[2]/td[3]/table[2]/tr')
#        list = html.search('//table[@class="j10"]/tr')
        self::scrapingShop(list)
        sleep 5
      end
    end
  end
  
  def self.scrapingShop(list)
    
    name        = ''
    address     = ''
    road        = ''
    tel         = ''
    use_flg     = ''
    information = ''
    shop        = ''
    restaurant  = ''
    park        = ''
    rest_room   = ''
    station_url = ''
    etc         = ''
    lat         = ''
    lng         = ''
    uid         = ''
      
    list.each_with_index do |tr, idx|
      if idx >= 2 && idx%2 == 1 then
        tr.xpath('td').each_with_index { |element, idx2|
          etc = element.inner_text
        }
        
#        begin
          p name
          uid = Digest::MD5.new.update(name + tel)
          p uid.to_s
          esc_name             = @client.escape(name)
          esc_address          = @client.escape(address)
          esc_tel              = @client.escape(tel)
          esc_category         = @client.escape(@category)
          esc_uid              = @client.escape(uid.to_s)
          esc_latitude         = @client.escape(lat)
          esc_longitude        = @client.escape(lng)
          esc_parking_url      = @client.escape(station_url)
          esc_road             = @client.escape(road)
          esc_memo             = @client.escape(etc)
          
          select = "SELECT * FROM shops WHERE uid = '" + esc_uid + "'"
          results  = @client.query(select)
          if results.count == 0 then
            query = "INSERT INTO shops (name, address, tel, category, uid, latitude, longitude, parking_url, " +
                    "road, information, shop, restaurant, park, rest_room, use_flg, memo, created_at, updated_at) values ('" + esc_name + "', '" +
                    esc_address + "',' " + esc_tel + "', '" + esc_category + "', '" + esc_uid + "', '" + esc_latitude + "', '" + esc_longitude + "', '" + 
                    esc_parking_url + "', '" + esc_road.to_s + "', '" + information.to_s + "', '" + shop.to_s + "', '" + restaurant.to_s + "', '" + park.to_s + "', '" +
                    rest_room.to_s + "', '" + use_flg.to_s + "', '" + esc_memo + "', '" + @day.strftime("%Y-%m-%d %H:%M:%S") + "', '" + @day.strftime("%Y-%m-%d %H:%M:%S") + "')"
          else
            query = "UPDATE shops SET name = '#{esc_name}', address = '#{esc_address}', tel = '#{esc_tel}', " +
                    " parking_url = '#{esc_parking_url}', road = '#{esc_road.to_s}', information = '#{information.to_s}', " +
                    " shop = '#{shop.to_s}', restaurant = '#{restaurant.to_s}', park = '#{park.to_s}', rest_room = '#{rest_room.to_s}', use_flg = '#{use_flg.to_s}', " +
                    " memo = '#{esc_memo}', updated_at = '" +  @day.strftime("%Y-%m-%d %H:%M:%S") + "' WHERE uid = '" + esc_uid + "'"
          end
          puts query
          results = @client.query(query)
#        rescue => exc
#          puts exc
#        end

#        p name
#        p address
#        p lat
#        p lng


      elsif idx >= 2 && idx%2 == 0 then
          tr.xpath('td').each_with_index { |element, idx2|
          val = element.inner_text.strip
#          p idx2
#          p val
          case idx2
          when 1
            name        = val.gsub(/(\r\n|\n)[\t ]*/, '')
            station_url = element.xpath("a/@href").inner_text
            
            if station_url == '' then
              station_url = element.xpath("span/a/@href").inner_text
            end
            
            if station_url == '' then
              station_url = element.xpath("div/a/@href").inner_text
            end

            
            if /www\.cbr\.mlit\.go\.jp/ =~ @station
              address     = self::getAddress(station_url.gsub(/\.\.\//, 'http://www.cbr.mlit.go.jp/michinoeki/'))
            elsif station_url == "../michi_no_eki/contents/eki/o07_tottopark/index.html"
              address     = self::getAddress(station_url.gsub(/\.\.\//, 'http://www.kkr.mlit.go.jp/road/'))
            elsif station_url == "../michi_no_eki/contents/eki/w19_ichimaiiwa/index.html"
              address     = self::getAddress(station_url.gsub(/\.\.\//, 'http://www.kkr.mlit.go.jp/road/'))
            elsif station_url == "../michi_no_eki/contents/eki/w20_shirasaki/index.html"
              address     = self::getAddress(station_url.gsub(/\.\.\//, 'http://www.kkr.mlit.go.jp/road/'))
            elsif station_url == "../michi_no_eki/contents/eki/w22_nachi/index.html"
              address     = self::getAddress(station_url.gsub(/\.\.\//, 'http://www.kkr.mlit.go.jp/road/'))
            elsif station_url == "../../rstation/station/katuura.html"
              address     = self::getAddress(station_url.gsub(/\.\.\/\.\.\//, 'http://www.skr.mlit.go.jp/road/'))
            else
              address     = self::getAddress(station_url)
            end
            
            begin

              # 緯度経度の取得
              latlng = self::getLatLng(address)
              lat = latlng[0]
              lng = latlng[1]
              
            rescue => exc
              puts exc
            end

          when 2
#            address     = val
          when 3
            road        = val
          when 4
            tel         = val.gsub(/(\r\n|\n)[\t ]*/, '')
          when 5
            p val
            use_flg     = (val == '供用中') ? 1 : 0
          when 6
            information = (val == '○') ? 1 : 0
          when 7
            shop        = (val == '○') ? 1 : 0
          when 8
            restaurant  = (val == '○') ? 1 : 0
          when 9
            park        = (val == '○') ? 1 : 0
          when 10
            rest_room   = (val == '○') ? 1 : 0
          end
        }

      end
      
#      
    end
  
  end

  def self.getLatLng(address)
    page = open(@geocode_url + URI.encode(address.gsub(/<br \/>/, ' ')))
    html = Nokogiri::HTML(page.read, nil, "UTF-8")
    
    lat = html.search("//geometry/location/lat").inner_text
    lng = html.search("//geometry/location/lng").inner_text

    return [lat, lng]
  end
  
  def self.getAddress(url)
    p url
    page = open(url)
    
    address = ''
    
    # 北海道
    if /www\.hkd\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      
      page2 = open(html.search('//frame/@src').inner_text)
      html2 = Nokogiri::HTML(page2.read, nil, "Shift_JIS")
      address = html2.search('//table/tr/td[2]/table[2]/tr[3]/td[2]').inner_text
    # 東北
    elsif /www\.thr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      address = html.search('//div[@id="Main_left"]/table/tr[3]/td[3]').inner_text
      
    # 関東
    elsif /www\.ktr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      address = html.search('//table/tr/td/table/tr[5]/td[2]/table[2]/tr/td/table/tr[1]/td[2]').inner_text.gsub(/〒[0-9\-　]*/, '')
      
    # 北陸
    elsif /www\.hrr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      html.search('//table/tbody/tr/td[3]/text()').each_with_index { |element, idx| 
        case idx
          when 1
            address = element.inner_text.strip
        end
      }
      
    # 中部
    elsif /www\.cbr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      page2 = open('http://www.cbr.mlit.go.jp/michinoeki/' + html.search('//frame[2]/@src').inner_text)
      html2 = Nokogiri::HTML(page2.read, nil, "Shift_JIS")
      address = html2.search('//dd[@class="adressText"]').inner_text.strip
      
    # 近畿
    elsif /www\.kkr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      address = html.search('//table[@class="pt14"]/tr[2]/td[3]').inner_text.strip
      
    # 中国
    elsif /www\.cgr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      html.search('//table[3]/tr[2]/td[2]/font').each_with_index { |element, idx| 
        case idx
          when 0
            address = element.inner_text.strip
        end
      }
      
    # 四国
    elsif /www\.skr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(NKF.nkf('-wS', page.read), nil, "UTF-8")
      page2 = open('http://www.skr.mlit.go.jp/road/rstation/station/' + html.search('//frame[2]/@src').inner_text)
      html2 = Nokogiri::HTML(NKF.nkf('-wS', page2.read), nil, "UTF-8")
      html2.search('//table[2]/tbody/tr/td[2]/ul/li[4]/text()').each_with_index { |element, idx| 
        case idx
          when 0
            address = element.inner_text.strip
        end
      }
      
    # 九州・沖縄
    elsif /www\.qsr\.mlit\.go\.jp/ =~ url
      html = Nokogiri::HTML(page.read, nil, 'Shift_JIS')
      address = html.search('//table/tr[2]/td[1]/div/table[3]/tr[2]/td[1]/div/table[2]/tr[3]/td[1]/table/tr[1]/td[2]').inner_text.strip

    end
    
    sleep 3
    
    return address.gsub(/(\r\n|\n)[\t ]*/, '')
  end
end