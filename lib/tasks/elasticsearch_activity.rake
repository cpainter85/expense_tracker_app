namespace :elasticsearch_activity do
  desc "Create a versioned index with an alias"
  task :create_index_with_alias => :environment do
    Activity.__elasticsearch__.create_index!(index: Activity.versioned_index)

    Activity.__elasticsearch__.client.indices.put_alias(
      index: Activity.versioned_index,
      name: Activity.__elasticsearch__.index_name
    )
  end
end