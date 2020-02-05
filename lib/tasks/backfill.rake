namespace :backfill do
  task :all_events_off => :environment do
    Event.all.each do |e|
      user = e.pet.user
      offset = Time.now.in_time_zone(user.timezone).utc_offset / -3600
      e.happened_at = e.happened_at + offset.hours
      e.save!
    end
  end
end