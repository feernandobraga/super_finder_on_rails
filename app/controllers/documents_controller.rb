class DocumentsController < ApplicationController
  def home
    @test = params[:term]
  end


  def result(term, path)

    @message = "message not changed"
    documentsFound = {}

    if !File.exist?(path)
      @message = "The path is invalid"
    else
      Dir.chdir(path)
      files = Dir.glob("**/*.txt")

      files.each do |file|
        currentDocument = File.read(file)
        if currentDocument =~ /#{term}/
          documentsFound[file] = File.read(file)
        end
      end

      if documentsFound.empty?
        @message = "Sorry, this text doesn't existi in my library!"
      else

        documentsFound.each do |file, content|
          fullPath = "#{path}/#{file}"
          documentContent = content
          document = Document.new
          document.term = term
          document.path = fullPath
          document.sample = documentContent
          document.save
        end

        @message = "I've found somenthing and saved on the database"
        @document = Document.where('term like ?', "%#{term}%")
        #redirect_to documents_fetch_path(@document)
      end


    end

  end

  def fetch

    #render :action => result

    @term = params[:term]
    @path = params[:path]

    @document = Document.where('term like ?', "%#{@term}%")

    if @document.blank?
      result(@term, @path)
      render documents_result_path
    end


  end




  def document_params
    params.require(:document).permite(:term, :path)

  end


end
