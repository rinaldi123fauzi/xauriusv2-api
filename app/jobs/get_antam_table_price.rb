class GetAntamTablePrice < ApplicationJob 
  queue_as :default 

  def perform(*args)

    doc = HTTParty.get("https://www.logammulia.com/id/harga-emas-hari-ini")
    parse_page = Nokogiri::HTML(doc)

    # cegah parsing nil
    if parse_page

      # disini ada 2 table.
      # ambil table pertama
      table_one = parse_page.css("table")[0]

      puts table_one

      therow = table_one.css('tr')[2..13]

      Antamprice.create({
        antamprice_scaptext: "<table class=\"table table-bordered table-striped table-hover\">
          <thead>
            <tr style='background-color: #000; color: #fff;'>
              <th>Weight</th>
              <th>Sell</th>
              <th>Price</th>
              <th>Buy</th>
            </tr>
          </thead>
          <tbody>
            #{therow}
          </tbody>
        </table>"
      })

    else
      # KIRIMKAN LAPORAN KEPADA ADMIN
      # ATAU MATIKAN APLIKASI (MAINTENANCE MODE KARENA MUNGKIN KESALAHAN HARGA DARI SERVER YANG DIREQUES)

      # ATAU JUGA SERVER YANG SEDANG DI REQUEST SEDANG MATI
    end

    # render inline: "jalan"

    sleep 2    
  end
  
end