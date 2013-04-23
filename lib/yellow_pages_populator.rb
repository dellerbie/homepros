require 'nokogiri'
require 'open-uri'
require 'socksify/http'

module YellowPagesPopulator
  class BusinessPageYamlBuilder
    DOWNLOAD_DIR = File.join(Rails.root, 'lib', 'yellow_pages', 'business_pages')
    URLS_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'business_page_urls.yml')
    CITIES_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'cities.yml')
    CATEGORIES_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'categories.yml')
    LAST_CITY_CATEGORY = File.join(Rails.root, 'lib', 'yellow_pages', 'last_city_category.txt')
    PORTFOLIO_IMAGE_DIR = File.join(Rails.root, 'lib', 'yellow_pages', 'portfolio_images')
    LOGO_IMAGE_DIR = File.join(Rails.root, 'lib', 'yellow_pages', 'logo_images')
    LAST_LID = File.join(Rails.root, 'lib', 'yellow_pages', 'last_lid.txt')
    LISTINGS_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'listings.yml')
    YP_DOMAIN = "http://www.yellowpages.com"
    
    class << self
      def download_images!
        urls = YAML::load_file URLS_YML
        lids = urls.keys
        last_lid = File.open(LAST_LID).try(:gets) || ""
        
        if last_lid.present?
          puts "Starting to download images from lid: #{last_lid}"
          lids = lids.slice(lids.index(last_lid)..lids.length)
        end
        
        lids.each do |lid|
          last_lid = lid
          puts "*******************************"
          puts "Processing #{lid}.html"
          
          html = File.read(File.join(DOWNLOAD_DIR, "#{lid}.html"))
          
          doc = Nokogiri::HTML(html)
        
          image = doc.css("#gallery-thumbnails .thumbnail img:not(.video-thumb)")
          if image.present?
            image = image.first['src'].gsub('_112x84_crop', '_700')
            
            uri = URI.parse(image)

            Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
              data = http.get(uri.path).body
              
              open(File.join(PORTFOLIO_IMAGE_DIR, "#{lid}.jpg"), 'wb') do |file|
                file.write(data)
                puts "Downloaded portfolio image #{lid}.jpg"
              end
            end
          else
            puts "Skipping #{lid}, image not found #{doc.css('#gallery-thumbnails .thumbnail img')}"
            next
          end
          
          company_logo = doc.css('#business-details p.graphic img').first
          if company_logo.present?
            company_logo = company_logo['src']
            
            uri = URI.parse(company_logo)

            Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
              data = http.get(uri.path).body
              
              open(File.join(LOGO_IMAGE_DIR, "#{lid}.jpg"), 'wb') do |file|
                file.write(data)
                puts "Downloaded logo image #{lid}.jpg"
              end
            end
          end
          
          puts "company_logo: #{company_logo}"
        end
        
      rescue Exception => e
        File.open(LAST_LID, 'w') { |out| out.write(last_lid) }
        raise e
      end
      
      def build_businesses!
        urls = YAML::load_file URLS_YML
        lids = urls.keys
        business_count = 0
        last_lid = nil
        listings = []
        
        last_lid = File.open(LAST_LID).try(:gets) || ""
        
        if last_lid.present?
          puts "Starting to build businesses from lid: #{last_lid}"
          lids = lids.slice(lids.index(last_lid)..lids.length)
        end
        
        lids.take(3).each do |lid|
          last_lid = lid
          puts "*******************************"
          puts "Processing #{lid}.html"
          
          html = File.read(File.join(DOWNLOAD_DIR, "#{lid}.html"))
          
          doc = Nokogiri::HTML(html)
          
          listing = Listing.new
          
          company_name = doc.css('.listings h1.fn.org').text.strip
          listing.company_name = company_name
          
          puts "company_name: #{company_name}"
          
          contact_email = doc.css('.primary-links a.primary-email').first
          if contact_email.present?
            contact_email = contact_email['href'].split("mailto:")[1]
            listing.contact_email = contact_email.strip
          else 
            puts "Skipping #{lid}, contact email not found #{doc.css('.primary-links a.primary-email')}"
            next
          end
          
          puts "contact_email: #{contact_email}"
          
          website = doc.css('.primary-links a.primary-website').first
          
          if website.present?
            listing.website = website['href'].strip
          else
            puts "Skipping #{lid}, website not found #{website}"
            next
          end
          
          puts "website: #{listing.website}"
          
          phone = doc.css('p.phone.tel').text
          listing.phone = phone.strip
          
          puts "phone: #{phone.strip}"
          
          company_description = doc.css('#general-info p')
          listing.company_description = company_description.first.text.strip if company_description.present?
          
          puts "company_description: #{company_description.first.text.strip}" if company_description.present?
          
          image = doc.css("#gallery-thumbnails .thumbnail img:not(.video-thumb)")
          if image.present?
            image = image.first['src'].gsub('_112x84_crop', '_700')
            
            uri = URI.parse(image)

            Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
              data = http.get(uri.path).body
              
              open(File.join(PORTFOLIO_IMAGE_DIR, "#{lid}.jpg"), 'wb') do |file|
                file.write(data)
                puts "Downloaded portfolio image #{lid}.jpg"
              end
              
              listing.portfolio_photo = File.open(TMP_IMAGE)
            end
            
          else
            puts "Skipping #{lid}, image not found #{doc.css('#gallery-thumbnails .thumbnail img')}"
            next
          end
          
          puts "image url: #{image}"
          
          company_logo = doc.css('#business-details p.graphic img').first
          if company_logo.present?
            company_logo = company_logo['src']
            
            uri = URI.parse(company_logo)

            Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
              data = http.get(uri.path).body
              
              open(File.join(LOGO_IMAGE_DIR, "#{lid}.jpg"), 'wb') do |file|
                file.write(data)
                puts "Downloaded logo image #{lid}.jpg"
              end
              
              listing.company_logo_photo = File.open(TMP_IMAGE)
            end
            
          end
          
          puts "company_logo: #{company_logo}"
          
          specialties = doc.css('dd.categories span').first.text.gsub('&nbsp;', '').split(',')
          more_specialties = doc.css('dd.categories span.expand-categories')
          if more_specialties.present?
            specialties << more_specialties.first.text.gsub('&nbsp;', '').split(',')
          end
          
          specialties = Specialty.where(name: specialties)
          
          if specialties.present?
            listing.specialties << specialties
          else 
            puts "Skipping #{lid}, speciality not found #{doc.css('dd.categories span').first.text}"
            next
          end
          
          puts "specialties: #{specialties}"
          
          city = doc.css('.primary-location .city-state .locality').text
          city = City.where(name: city).first
          
          if city.present?
            listing.city = city
          else 
            puts "Skipping #{lid}, city not found #{doc.css('.primary-location .city-state .locality').text}"
            next
          end
          
          puts "city: #{city}"
          
          business_count = business_count + 1
          
          # listing.save!
          
          listings << listing
        end
        
        puts "business_count: #{business_count}"
        
        File.open(LISTINGS_YML, 'a') { |out| YAML::dump(listings, out) } unless listings.empty?
        
        
      rescue Exception => e
        File.open(LAST_LID, 'w') { |out| out.write(last_lid) }
        raise e
      end
      
      def download_pages!
        urls = YAML::load_file URLS_YML
        keys = urls.keys
        
        last_lid = File.open(LAST_LID).try(:gets) || ""
        
        if last_lid.present?
          puts "Starting downloads from lid: #{last_lid}"
          keys = keys.slice(keys.index(last_lid)..keys.length)
        end

        keys.each do |lid| 
          last_lid = lid
          file = File.join(Rails.root, 'lib', 'yellow_pages', 'business_pages', lid + '.html')
          unless File.exists?(file)
            puts "Downloading lid: #{lid}, url: #{urls[lid]}"
            sleep (1..6).to_a.sample
            
            uri = URI.parse(urls[lid])
            Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
              html = http.get(uri.path).body
              File.open(file, 'w') { |f| f.print html }
            end
          end
        end
        
      rescue Exception => e
        save_last_lid(last_lid)
        raise e
      end
      
      def save_last_lid(lid)
        File.open(LAST_LID, 'w') { |out| out.write(lid) }
      end
      
      def build!
        master_urls = YAML::load_file URLS_YML
        urls = {}
        
        categories = YAML::load_file(CATEGORIES_YML)
        cities = YAML::load_file(CITIES_YML)
        last_city_category = File.open(LAST_CITY_CATEGORY).try(:gets) || ""
        
        if last_city_category.present?
          city, cat = last_city_category.split('/')
          puts "Starting from #{city}/#{cat}"
          cities = cities.slice(cities.index(city)..cities.length)
        end
        
        begin
          cities.each do |city|
            categories.each do |category|
              puts "Getting business page urls for #{city}/#{category}..."
            
              last_city_category = "#{city}/#{category}"
            
              url = "#{YP_DOMAIN}/#{city}/#{category}"
              doc = get_business_page_urls(url, urls, master_urls)
              doc.css('.track-pagination li:not(.next) a').each do |node|
                get_business_page_urls(YP_DOMAIN + node['href'], urls, master_urls)
              end

              File.open(URLS_YML, 'a') { |out| YAML::dump(urls, out) } unless urls.empty?
              save_last_city_category(last_city_category)
              
              sleep (1..6).to_a.sample # random sleep
            end
          end
        rescue Exception => e
          save_last_city_category(last_city_category)
          raise e
        end
      end
      
      def get_business_page_urls(url, urls, master_urls)
        puts "opening #{url}"

        uri = URI.parse(url)
        
        Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
          data = http.get(uri.path).body
          doc = Nokogiri::HTML(data)
          doc.css('#results .listing-content .thumbnail a').each do |node|
            url = node['href']
            lid = url.match(/lid=(\d+)/)[1]
            urls[lid] = YP_DOMAIN + url unless master_urls.key?(lid) || urls.key?(lid)
          end
          
          return doc
        end
      end
      
      def save_last_city_category(last_city_category)
        File.open(LAST_CITY_CATEGORY, 'w') { |out| out.write(last_city_category) }
      end
    end
  end
end
