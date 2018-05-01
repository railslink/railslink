namespace :fu do

  desc "Update Pending Invites from HTML"
  task :update_pending_invites, [:file] => ["environment"] do |_t, args|
    pending_invites_str = nil
    File.open(args.file) do |f|
      f.each_line do |line|
        if line =~ /boot_data\.pending_invites = (.*);$/ 
          pending_invites_str = $1 
          break
        end
      end
    end

    pending_invites = JSON.parse(pending_invites_str)

    puts "Updating #{pending_invites.size} pending invites..."

    pending_invites.each do |invite|
      email = invite["email"].downcase
      puts " - #{email}"

      submission = SlackMembershipSubmission.find_by(email: email) ||
                   SlackMembershipSubmission.new

      if invite["bouncing"]
        submission.rejected! if submission.persisted?
        next
      end

      if submission.new_record?
        submission.update!(
          first_name: "n/a",
          last_name: "n/a",
          email: email,
          created_at: Time.at(invite["date_create"].to_i),
          updated_at: Time.at(invite["date_create"].to_i),
        )
      end

      submission.approved! if submission.pending?

      user = SlackUser.find_by(email: email)
      if user
        submission.user = user
        submission.rejected! if user.is_deleted?
      elsif submission.created_at <= 6.months.ago
        submission.ignored!
      end
    end

  end

  desc "Import typeform CSV data"
  task :typeform_import, [:file] => ["environment"] do |_t, args|
    require 'csv'
    puts "Importing typeform csv data..."
    CSV.foreach(args.file, headers: true) do |row|
      puts " - #{row[0]}"

      _, first_name, last_name, email, 
        location, introduction, how_hear, 
        linkedin_url, github_url, website_url, 
        _, submit_date, _ = row.values_at

      first_name.strip! unless first_name.nil?
      first_name = "n/a" if first_name.blank?

      last_name.strip! unless last_name.nil?
      last_name = "n/a" if last_name.blank?

      email = email.to_s.strip.downcase
      email = nil if email.blank?

      location.strip! unless location.nil?
      introduction.strip! unless introduction.nil?
      how_hear.strip! unless how_hear.nil?
      submitted_at = Time.parse(submit_date)

      linkedin_url = nil if linkedin_url.blank? || linkedin_url == "http://"
      linkedin_url = URI.parse(linkedin_url).to_s rescue nil
      github_url = nil if github_url.blank? || github_url == "http://"
      github_url = URI.parse(github_url).to_s rescue nil
      website_url = nil if website_url.blank? || website_url == "http://"
      website_url = URI.parse(website_url).to_s rescue nil

      submission = SlackMembershipSubmission.find_by(email: email) ||
                   SlackMembershipSubmission.new

      submission.assign_attributes(
        first_name: first_name,
        last_name: last_name,
        email: email,
        location: location,
        introduction: introduction,
        how_hear: how_hear,
        linkedin_url: linkedin_url,
        github_url: github_url,
        website_url: website_url,
        created_at: submitted_at,
        updated_at: submitted_at,
      )

      if !submission.valid?
        submission.errors.keys.select {|k| k =~ /url/}.each do |attr|
          submission.assign_attributes(attr => nil)
        end
      end

      submission.save!

      user = SlackUser.find_by(email: email)
      if user
        submission.user = user
        submission.rejected! if user.is_deleted?
        submission.approved! unless user.is_deleted?
      elsif submission.created_at <= 6.months.ago
        submission.ignored!
      end
    end
  end
end
