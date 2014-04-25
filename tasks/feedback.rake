namespace :feedback do

  task reset: :environment do
    count =  Feedback.unscoped.delete_all
    puts "Deleted all #{count} feedback records!"
  end

  task clear: :environment do
    count = Feedback.outdated.delete_all
    puts "Deleted #{count} outdated feedback records!"
  end

  task debug: :environment do
    puts "Feedback records"
    puts "----------------"
    puts "Current: #{Feedback.unscoped.count}"
    puts "Outdated: #{Feedback.outdated.count}"
    puts "Total: #{Feedback.count}"
  end

end
