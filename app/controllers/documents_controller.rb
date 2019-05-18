class DocumentsController < ApplicationController
  def home

  end

  # this method is called by fetch when no record was found on the database
  # and therefore needs to be searched on the HDD
  def result(term, path)

    # a hash that will store all found documents where they key is the filename
    # and the value is the file content
    documentsFound = {}

    # check if the path is valid and if not sends a message to the view using
    # the @message instance variable
    if !File.exist?(path)
      @message = "The path is invalid!"
    else
      # if the path is valid it looks for .txt files recursively and stores it
      # on the documentsFound hash
      Dir.chdir(path)
      files = Dir.glob("**/*.txt")

      files.each do |file|
        currentDocument = File.read(file)
        if currentDocument =~ /#{term}/
          documentsFound[file] = File.read(file)
        end
      end

      # if no document contains the term, it will send a message to the view
      # using the @message variable again
      if documentsFound.empty?
        @message = "Sorry, I couldn't find what you're looking for"
      else

        # for every document found it will create a new entry on the database
        # with the term searched, the full path to the file and the file's content
        documentsFound.each do |file, content|
          fullPath = "#{path}/#{file}"
          documentContent = content
          document = Document.new
          document.term = term
          document.path = fullPath
          document.sample = documentContent
          document.save
        end

        # this will pass to the view all documents with the given term
        @document = Document.where('term like ?', "%#{term}%")
      end

    end

  end


  # this method answers to POST to /documents/home and
  # checks if the given term and path has been already stored on the database
  def fetch

    # retrieve the arguments and stores it on instance variables
    @term = params[:term]
    @path = params[:path]

    # run a query on the database first to see if the term and path has already been found
    @document = Document.where('term like ? AND path like ?', "%#{@term}%", "#{@path}%")

    # if it can't find the term on the database then it will search on the hard drive
    if @document.blank?
      result(@term, @path)
      render documents_result_path
    end

  end


  # route from GET to /documents/all
  # it's called by a button in the home view and it retrieves all content from the database
  # and stores it on the instance variable @document
  def all
    @document = Document.all
  end


  def document_params
    params.require(:document).permite(:term, :path)

  end


end
