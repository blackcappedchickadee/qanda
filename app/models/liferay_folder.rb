class LiferayFolder

  attr_reader :name, :description, :folderid
  


  def initialize
    
    @liferay_server_protocol = Rails.configuration.liferayserverprotocol
    @liferay_server_user = Rails.configuration.liferayserveruser
    @liferay_server_pass = Rails.configuration.liferayserverpass
    @liferay_server_url = Rails.configuration.liferayserverurl
    @liferay_axis_secure = Rails.configuration.liferayaxissecure
    @liferay_wsdl_folder_service = Rails.configuration.liferaywsdlfolderservice

    @liferay_url = "#{@liferay_server_protocol}#{@liferay_server_user}:#{@liferay_server_pass}@#{@liferay_server_url}#{@liferay_axis_secure}#{@liferay_wsdl_folder_service}?wsdl"
    
    @client = Savon::Client.new(@liferay_url)
     
  end
  
  def getdetails(folderId)
    begin
       response = @client.request :get_folder, body: { folderId: folderId}
       if response.success?
         #Nokogiri object is returned when calling response.doc
         @name = response.doc.css("name").inner_text
         @description = response.doc.css("description").inner_text
         return "folderName:#{@name}, folderDesc:#{@description} "
       end
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notfound"
    end
     
  end
  
  def add(group_id, parent_folder_id, name, description)
    begin
      
      response = @client.request :add_folder, body: {groupId: group_id, folderId: parent_folder_id, name: name, description: description, 
              serviceContext: ""}
              
      if response.success?
        #Nokogiri object is returned when calling response.doc
        @folderid = response.doc.css("#id2").inner_text #in soap response, <multiRef id="id2" ... element contains the newly-created folder id.
      end
  
      return @folderid
      
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notfound"
    end

  end


end
