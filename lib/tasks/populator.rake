namespace :populator do
  desc "downloads the index pages for a given city and category"
  task :index_pages => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.build!
  end
  
  desc "downloads the business pages"
  task :index_pages => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.download_pages!
  end
end