namespace :populator do
  desc "downloads the index pages for a given city and category"
  task :index_pages => :environment do
    YellowPagesPopulator::BusinessPageYamlBuilder.build!
  end
end