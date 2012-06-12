class LiferayDocument

  attr_reader :name, :description

  def initialize()
    
     @liferay_server_protocol = Rails.configuration.liferayserverprotocol
     @liferay_server_user = Rails.configuration.liferayserveruser
     @liferay_server_pass = Rails.configuration.liferayserverpass
     @liferay_server_url = Rails.configuration.liferayserverurl
     @liferay_axis_secure = Rails.configuration.liferayaxissecure
     @liferay_wsdl_document_service = Rails.configuration.liferaywsdlfileentryservice

     @liferay_url = "#{@liferay_server_protocol}#{@liferay_server_user}:#{@liferay_server_pass}@#{@liferay_server_url}#{@liferay_axis_secure}#{@liferay_wsdl_document_service}?wsdl"
     #puts "LiferayDocument wsdl = #{@liferay_url}"
     @client = Savon::Client.new(@liferay_url)
     
  end
  
  def add(groupId, folderId, name, description, fileAsBase64)
    begin
      #puts "in add -----#{@liferay_url} #{groupId}, #{folderId}, #{name}, #{description}, #{fileAsBase64}"
      
      response = @client.request :add_file_entry, body: { groupId: groupId, folderId: folderId, name: name, 
                                title: name, description: description, changeLog: "", extraSettings: "", 
                                bytes: fileAsBase64, serviceContext: ""}
 
      if response.success?
        #Nokogiri object is returned when calling response.doc
        @doc_name = response.doc.css("name").inner_text
        puts "success ------------- #{response.to_json}"
        return @doc_name
      end
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notadded"
    end
    
  end
  
  def update(groupId, folderId, name, title, description, fileAsBase64)
    begin
      response = @client.request :update_file_entry, body: { groupId: groupId, folderId: folderId, name: name, sourceFileName: title, 
                              title: title, description: description, changeLog: "", majorVersion: false, extraSettings: "", 
                              bytes: fileAsBase64, serviceContext: ""}
      if response.success?
         #puts "success ------------- #{response.to_json}"
         return "updated"
       end                       
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notupdated"
    end
  end
  
  def get(groupId, folderId, name)
    begin
      response = @client.request :get_file_entry, body: { groupId: groupId, folderId: folderId, name: name}
       if response.success?
         #puts "success ------------- #{response.to_json}"
         return "found"
       end
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notfound"
    end
  end
  
  def delete(groupId, folderId, name)
    begin
      response = @client.request :delete_file_entry, body: { groupId: groupId, folderId: folderId, name: name}
      if response.success?
         #puts "success ------------- #{response.to_json}"
         return "deleted"
       end
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notdeleted"
    end
  end
  
  def delete_by_file_title_and_extension(groupId, folderId, fileNameWithExtension)
    begin
      response = @client.request :delete_file_entry_by_title, body: { groupId: groupId, folderId: folderId, titleWithExtension: fileNameWithExtension}
      if response.success?
         #puts "success ------------- #{response.to_json}"
         return "deleted"
       end
    rescue Savon::Error => error
      Rails.logger.warn.to_s
      return "notdeleted"
    end
  end


end
