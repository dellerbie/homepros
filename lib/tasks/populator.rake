namespace :populator do
  desc "downloads the index pages for a given city and category"
  task :index_pages => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.build!
  end
  
  desc "downloads the business pages"
  task :download_pages => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.download_pages!
  end
  
  desc "downloads the business images"
  task :download_images => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.download_images!
  end
  
  desc "creates the business objects"
  task :create_businesses => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.build_businesses!
  end
end