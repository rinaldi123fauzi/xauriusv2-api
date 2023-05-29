class GetAntamPrice < ApplicationJob 
  queue_as :default 

  def perform(*args)

    doc = HTTParty.get("https://www.logammulia.com/id/harga-emas-hari-ini")
    parse_page = Nokogiri::HTML(doc)

    # cegah parsing nil
    if parse_page

      # <tr>
      #     <td>1 gr</td>
      #     <td style="text-align:right;">952,000</td>
      #     <td style="text-align:right;">956,000</td> ===> jual
      #     <td style="text-align:right;">960,000</td> ===> beli
      # </tr>
      table = parse_page.css('table')[0].css('tr')[3]

      # pastikan jika td pertama adalah 1 gr
      if table.css('td')[0].text == '1 gr'

        sell_price = table.css('td')[1].text.delete(',').to_f
        puts 'sell_price'
        puts sell_price

        mid_price = table.css('td')[2].text.delete(',').to_f
        puts 'mid_price'
        puts mid_price

        buy_price = table.css('td')[3].text.delete(',').to_f
        puts 'buy_price'
        puts buy_price


        # ambil apakah ini adalah harga pertama
        # jika harga pertama, maka langsung saja simpan didalam tabel
        chartprice_count = Chartprice.where(chartprice_exchange: "logammulia.com").count

        if chartprice_count == 0
          chartprice = Chartprice.create({
            chartprice_exchange: "logammulia.com",
            chartprice_buy: buy_price,
            chartprice_sell: sell_price,
            chartprice_price: mid_price
          })
        else

          # jika ini bukan harga pertama, maka dilihat kewajaran. Jika naik 10% atau turun 10%, maka simpan saja data yang lama dan berikan laporan kepada admin

          # ambil harga mid terakhir
          last_midprice = Chartprice.where(chartprice_exchange: "logammulia.com").last.chartprice_price

          # periksa kenaikan atau penurunan
          percent_change = (((mid_price - last_midprice) / last_midprice) * 100.00).abs

          if percent_change > 10
            # KIRIMKAN LAPORAN KEPADA ADMIN
            # ATAU MATIKAN APLIKASI (MAINTENANCE MODE KARENA MUNGKIN KESALAHAN HARGA DARI SERVER YANG DIREQUES)
          else
            Chartprice.create({
              chartprice_exchange: "logammulia.com",
              chartprice_buy: buy_price,
              chartprice_sell: sell_price,
              chartprice_price: mid_price
            })
          end

        end

        app_cron_our_price
        create_chart

        # render inline: 'oke'
      else
        # KIRIMKAN LAPORAN KEPADA ADMIN
        # ATAU MATIKAN APLIKASI (MAINTENANCE MODE KARENA MUNGKIN KESALAHAN HARGA DARI SERVER YANG DIREQUES)
      end

    end

    sleep 2    
  end

  private 

  def create_chart
    lmprice = Chartprice.where(chartprice_exchange: "logammulia.com").last

    # harga buy selalu harga low 
    low_price = lmprice.chartprice_sell

    # harga sell selalu harga high
    high_price = lmprice.chartprice_buy

    # harga open dan harga close di harga tengah
    open_price = lmprice.chartprice_price
    close_price = lmprice.chartprice_price

    # current time 
    # panduan https://www.rubyguides.com/2015/12/ruby-time/
    time = Time.new 
    time_string = time.strftime("%Y-%m-%d").to_s 
    time_time = time.strftime("%Y-%m-%d")

    # cari dulu, apakah date tersebut sudah ada pada database 
    jumlah = Chart.where(cdatestr: time_string).count 

    if jumlah > 0 
      # update 
      chart = Chart.where(cdatestr: time_string).first 
      chart.copen    = open_price
      chart.cclose   = close_price
      chart.clow     = low_price
      chart.chigh    = high_price
      chart.save
    else  
      # insert 
      chart = Chart.new
      chart.cdate    = time_time 
      chart.cdatestr = time_string 
      chart.copen    = open_price
      chart.cclose   = close_price
      chart.clow     = low_price
      chart.chigh    = high_price
      chart.save
    end

  end

  # dipanggil dari sidekiq-cron
  def app_cron_our_price
    # ambil harga terakhir dari logammulia.com (antam)
    lmprice = Chartprice.where(chartprice_exchange: "logammulia.com").last

    Chartprice.create({
      chartprice_exchange: "app_price",
      chartprice_buy: lmprice.chartprice_buy,
      chartprice_sell: lmprice.chartprice_sell,
      chartprice_price: lmprice.chartprice_price
    })

  end
end