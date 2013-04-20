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
    LAST_LID = File.join(Rails.root, 'lib', 'yellow_pages', 'last_lid.txt')
    YP_DOMAIN = "http://www.yellowpages.com"
    
    class << self
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
            sleep 1
            html = open(urls[lid]).read
            File.open(file, 'w') { |f| f.print html }
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
