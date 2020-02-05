namespace :backfill do
  task :all_events_off => :environment do
    Event.all.each do |e|
      user = e.pet.user
      offset = Time.now.in_time_zone(user.timezone).utc_offset / -3600
      e.happened_at = e.happened_at + offset.hours
      e.save!
    end
  end

  task :populate_test_info => %i[environment logger] do
    Rails.logger.info(event: "adding_test_data")
    time_start = Time.now.utc

    (1..5).each do
      u = User.new(
        first_name: Faker::Name.unique.first_name,
        last_name: Faker::Name.unique.last_name,
        email: "pt-fake-#{Faker::Alphanumeric.unique.alphanumeric(number: 15)}@example.com",
        password: "passwordpassword",
        timezone: "America/Chicago",
      )
      u.save!

      (1..3).each do 
        p = Pet.new(
          name: Faker::Name.unique.first_name,
          kind: "Dog",
          breed: "Beagle",
          birthday: Faker::Time.backward,
          user_id: u.id,
        )

        p.save!

        (-30..-1).each do |i| 
          current_date = Time.now.in_time_zone(u.timezone) + i.days
          pee_hours = [7,9,10,12,14,16,18,21,22,23]
          poo_hours = [7,12,16,22]
          treat_hours = [7,12,14,18,22]
          nap_starts = [8,13,15,19]

          types = {}
          types["pee"] = pee_hours
          types["poo"] = poo_hours
          types["treat"] = treat_hours
          types["sleep"] = nap_starts

          types.each do |type, vals|
            vals.each do |v|
              kind = type

              kind += "_start" if kind == "sleep"

              diff = Faker::Number.between(from: -10, to: 10)
              ha = current_date.change(hour: v) + diff.minutes
              e = Event.new(
                pet_id: p.id,
                kind: kind,
                happened_at: ha,
                created_at: ha,
              )
              e.save!

              if kind == "sleep_start"
                diff = Faker::Number.between(from: -10, to: 10)
                ha = e.happened_at + (diff.minutes + 60.minutes)
                e_end = Event.new(
                  pet_id: p.id,
                  kind: "sleep_end",
                  happened_at: ha,
                  created_at: ha,
                )
                e.save!
              end
            end
          end
        end
      end
    end

    Rails.logger.info(
      event: "add_test_info_end",
      duration: Time.now.utc.to_i - time_start.to_i
    )
  end

  task :logger do
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.level = Logger::INFO
  end
end