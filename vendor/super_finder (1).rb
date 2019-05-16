class SuperFinder


  def set_path(mainPath)              # first, this method stores the entered path inside @mainPath, and then
                                      # it check if the path exists. If it does, it changes the program
    @mainPath = mainPath              # directory to the entered path, otherwise it will return false
                                      # if the path doesn't exist.
    if File.exist?(@mainPath)
      Dir.chdir(@mainPath)
    else
      puts "The path is invalid"
      return false
    end

  end

  def set_query(userQuery)            # stores the entered sentence at @mainQuery
    @mainQuery = userQuery
  end

  def fetchTerm
    documentsFound = {}

    @files = Dir.glob("**/*.txt")                     # @files will store every .txt file in the directory
    @files.each do |file|                             # and then it will be looped through, so @currentDocument
      @currentDocument = File.read(file)              # can read every one of them and compare to the query.
      if @currentDocument =~ /#{@mainQuery}/          # If the sentence is found within the document, the hash
        documentsFound[file] = File.readlines(file)   # called documentsFound will store the document name
      end                                             # as key, and its content(in a form an array of lines)
    end                                               # as the value.

    if documentsFound.empty?          #if the hash is empty, it means that no matches were made
      puts "\nSorry, this text doesn't exist in my library!"
    else                              #otherwise, it will print some of the document's content
      puts "\nI've found #{documentsFound.length} occurrences for \"#{@mainQuery}\" on:\n\n"

      documentsFound.each do |key, value|
        puts "\nfile: #{key}:"
        @occurrence = 0

        value.each do |eachLine|    #this nested each loop scans the array for each value in the hash and
          @occurrence = @occurrence + eachLine.scan(/#{@mainQuery}/).count  # and counts how many times
        end                                                                 # the query has occurred

        if value.length > 2           # if the array that contains the whole document has more than
          puts "Sample:"              # 3 lines, this block makes the program print only
          for count in 0..2           # the first 3 lines
            puts value[count]
          end

        else
          puts "Content: #{value[0]}" # otherwise, it will only print the first line
        end
        puts "- The sentence appeared #{@occurrence} time(s) in this file"
      end

    end

  end

end



userSearch = SuperFinder.new         # creates the main object userSearch



puts "Please enter a term or a phrase to search:"   # prompt the user to enter a path and stores it
userQuery = STDIN.gets.downcase.chomp!

puts "\nNow please enter a valid path:"             # prompt the user to enter a path and stores it
mainPath = STDIN.gets.downcase.chomp!

userSearch.set_query(userQuery)                     # calls the setter method
validPath = userSearch.set_path(mainPath)           # if the path is incorrect, validPath will be false


userSearch.fetchTerm if validPath    # if the valid path is true, it will run the method that fetches the term


