namespace :elasticsearch_activity do
  desc "Create a versioned index with an alias"
  task :create_index_with_alias => :environment do
    Activity.__elasticsearch__.create_index!(index: Activity.versioned_index)

    Activity.__elasticsearch__.client.indices.put_alias(
      index: Activity.versioned_index,
      name: Activity.__elasticsearch__.index_name
    )
  end

  desc "Replace index"
   task :replace_index => :environment do
     Activity.__elasticsearch__.create_index!(index: Activity.versioned_index)

     Activity.__elasticsearch__.client.reindex(
       body: {
         source: {
           index: Activity.versioned_index(preceding: true)
         },
         dest: {
           index: Activity.versioned_index
         }
       }
     )

     Activity.__elasticsearch__.client.indices.update_aliases(
       body: {
         actions: [
           { remove: { index: Activity.versioned_index(preceding: true), alias: Activity.index_name } },
           { add: { index: Activity.versioned_index, alias: Activity.index_name } }
         ]
       }
     )
   end

end