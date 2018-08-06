require 'csv'

command = system("which imapsync")

if command
  puts "\e[42mImapsync installed.\e[0m"
else
  puts "\e[41mImapsync must be installed, exiting.\e[0m"
  exit
end

print "CSV Column separator? "
colsep = STDIN.gets.chomp

begin
  file = CSV.read(ARGV[0], { :col_sep => colsep})
rescue ArgumentError => e
  puts "No file given."
  retry
end

print "Source host ? "
host1 = STDIN.gets.chomp

print "Destination host ? "
host2 = STDIN.gets.chomp

begin
print "How many accounts to process on the same time ? "
account_slice = Integer(STDIN.gets.chomp)
rescue ArgumentError => e
  puts "Not a whole number."
  retry
end

date = Time.now.day.to_s+"-"+Time.now.month.to_s+"-"+Time.now.year.to_s

def mass_imapsync(f, d, shost, dhost)
  threads = []
  f.each do |el|
    unless el.empty?
      threads << Thread.new {
        system("imapsync --no-modulesversion " +
               "--nosyncacls " +
               "--subscribe "  +
               "--syncinternaldates " +
               "--host1 #{shost} " +
               "--ssl2 " +
               "--user1 #{el[0]} " +
               "--password1 '\"#{el[1]}\"' " +
               "--host2 #{dhost} " +
               "--ssl2 " +
               "--user2 #{el[0]} " +
               "--password2 '\"#{el[1]}\"' " +
               "--automap " +
               "--exclude \"Junk|Trash|Spam\" " +
               "--regextrans2 \"s/[ ]+/_/g\" " +
               "--useuid " +
               "--usecache " +
               "--errorsmax 200 " +
               "--nofoldersizes --skipsize --fast " +
               "--logfile #{el[0]}_#{d}.log")
      }
    end
  end
  threads.each { |t| t.join }
end


file.each_slice(account_slice) do |slice|
  mass_imapsync(slice, date, host1, host2)
end

puts "\e[42mMigration complete!\e[0m"


