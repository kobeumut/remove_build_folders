require "remove_build_folders/version"
require "shellwords"
require "tty-prompt"

module RemoveBuildFolders
  class Error < StandardError; end
  class Start
  	prompt = TTY::Prompt.new
        pwd= `pwd`.strip
	continue = prompt.select("Choose your path for delete build folder?") do |menu|
	    menu.default 1
            
	    menu.choice pwd, 1
	    menu.choice File.expand_path('~'), 2
            menu.choice "#{File.expand_path('~')}/Documents", 3
	    menu.choice "#{File.expand_path('~')}/Desktop", 4
	    menu.choice 'I want to write full path', 5
            menu.choice 'Exit', 6
	end
	case continue
        when 1
            continue = pwd
	when 2
	    continue = File.expand_path('~')
	when 3
	    continue = "#{File.expand_path('~')}/Documents"
	when 4
	    continue = "#{File.expand_path('~')}/Desktop"
	when 5
	    continue = prompt.ask("Enter your custom path:")
        when 6
            `return 0`
	end
	unless continue.nil?
	    $stdout.sync = true
	    finishLoading = false
	    print "Searching Build Files: "
	    b = Thread.new { loop { sleep 1; print "#" } }
	    file = Dir["#{continue}/**/build"]
	    b.kill
	    $stdout.sync = false
	    if file.size<1
	        puts "Nothing to found in #{continue}"
	    else
	        file.each do |f|
	            #`rm -R -f #{Shellwords.escape(f)}`
	            puts "#{f}"
	        end
	        puts "Are you sure delete all that files? (Y/n):"
	        continue = gets.chomp
	        if continue.downcase == "y"
	            puts "Starting Delete"
	            file.each { |f| `rm -R -f #{Shellwords.escape(f)}`}
	            puts "Finished Delete process."
	        end
	    end

	end
  end

end
