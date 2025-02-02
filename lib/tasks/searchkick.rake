namespace :searchkick do
  desc "reindex a model (specify CLASS)"
  task reindex: :environment do
    class_name = ENV["CLASS"]
    abort "USAGE: rake searchkick:reindex CLASS=Product" unless class_name

    model = class_name.safe_constantize
    abort "Could not find class: #{class_name}" unless model
    abort "#{class_name} is not a searchkick model" unless Searchkick.models.include?(model)

    puts "Reindexing #{model.name}..."
    model.reindex
    puts "Reindex successful"
  end

  namespace :reindex do
    desc "reindex all models"
    task all: :environment do
      # eager load models to populate Searchkick.models
      if Rails.respond_to?(:autoloaders) && Rails.autoloaders.zeitwerk_enabled?
        # fix for https://github.com/rails/rails/issues/37006
        Zeitwerk::Loader.eager_load_all
      else
        Rails.application.eager_load!
      end

      Searchkick.models.each do |model|
        puts "Reindexing #{model.name}..."
        model.reindex
      end
      puts "Reindex complete"
    end
  end

  desc "full index a model (specify CLASS)"
  task full_index: :environment do
    class_name = ENV["CLASS"]
    abort "USAGE: rake searchkick:full_index CLASS=Product" unless class_name

    model = class_name.safe_constantize
    abort "Could not find class: #{class_name}" unless model
    abort "#{class_name} is not a searchkick model" unless Searchkick.models.include?(model)

    puts "Full indexing #{model.name}..."
    model.full_index
    puts "Full index successful"
  end

  namespace :full_index do
    desc "full index all models"
    task all: :environment do
      Searchkick.models.each do |model|
        puts "Full indexing #{model.name}..."
        model.full_index
      end
      puts "Full index complete"
    end
  end
end
