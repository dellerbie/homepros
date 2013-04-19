require 'nokogiri'
require 'open-uri'

module YellowPagesPopulator
  class BusinessPageYamlBuilder
    DOWNLOAD_DIR = File.join(Rails.root, 'lib', 'yellow_pages', 'business_pages')
    URLS_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'business_page_urls.yml')
    CITIES_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'cities.yml')
    CATEGORIES_YML = File.join(Rails.root, 'lib', 'yellow_pages', 'categories.yml')
    LAST_CITY_CATEGORY = File.join(Rails.root, 'lib', 'yellow_pages', 'last_city_category.txt')
    YP_DOMAIN = "http://www.yellowpages.com"
    
    class << self
      def build!
        urls = {}
        
        categories = YAML::load_file(CATEGORIES_YML)
        cities = YAML::load_file(CITIES_YML)
        last_city_category = File.open(File.join(Rails.root, 'lib', 'yellow_pages', 'last_city_category.txt')).try(:gets).try(:chop) || ""
        
        if last_city_category.present?
          city, cat = last_city_category.split('/')
          cities.slice!(cities.index(city)..cities.length)
        end
        
        begin
          cities.each do |city|
            categories.each do |category|
              puts "Getting business page urls for #{city}/#{category}..."
            
              last_city_category = "#{city}/#{category}"
            
              url = "#{YP_DOMAIN}/#{city}/#{category}"
              doc = get_business_page_urls(url, urls)
              doc.css('.track-pagination li:not(.next) a').each do |node|
                get_business_page_urls(YP_DOMAIN + node['href'], urls)
              end

              File.open(URLS_YML, 'a') { |out| YAML::dump(urls, out) }
              save_last_city_category(last_city_category)
              
              sleep (1..6).to_a.sample # random sleep
            end
          end
        rescue
          save_last_city_category(last_city_category)
        end
      end
      
      def get_business_page_urls(url, urls)
        doc = Nokogiri::HTML(open(url))
        doc.css('#results .listing-content .thumbnail a').each do |node|
          url = node['href']
          lid = url.match(/lid=(\d+)/)[1]
          urls[lid] = YP_DOMAIN + url unless urls.key?(lid)
        end
        doc
      end
      
      def save_last_city_category(last_city_category)
        File.open(LAST_CITY_CATEGORY, 'w') { |out| out.write(last_city_category) }
      end
    end
  end
end