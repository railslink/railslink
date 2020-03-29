namespace :slack do
  namespace :admin do
    namespace :files do

      desc "Prune files"
      task prune: [:environment] do
        puts "Pruning files..."

        client = Slack::Web::Client.new

        page = 1
        pages = 1
        count = 200
        files = []

        while page <= pages do
          puts " - fetching page #{page} of #{pages}"

          response = client.files_list(
            show_files_hidden_by_limit: true,
            page: page,
            count: count
          )
          pages = response["paging"]["pages"]
          page += 1

          files += response["files"]
        end

        files.sort_by! {|e| e["created"] }

        age_limit = Time.now.to_i - 30*86400 # 90 days ago
        num_deleted = 0
        num_total = 0
        size_deleted = 0
        size_total = 0

        files.each do |file|
          id, created, mimetype, size = file.values_at("id", "created", "mimetype", "size")
          size_total += size
          num_total += 1

          if created < age_limit
            puts " - deleting #{id}, #{mimetype} #{size} bytes"
            num_deleted += 1
            size_deleted += size
          end
        end

        puts
        puts "- Deleted #{num_deleted} of #{num_total} files, #{size_deleted/1048576} of #{size_total/1048576} Mb"
        puts
      end
    end
  end
end
