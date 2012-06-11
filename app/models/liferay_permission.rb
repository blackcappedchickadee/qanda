class LiferayPermission
  
  def initialize()

      @liferay_server_protocol = Rails.configuration.liferayserverprotocol
      @liferay_server_user = Rails.configuration.liferayserveruser
      @liferay_server_pass = Rails.configuration.liferayserverpass
      @liferay_server_url = Rails.configuration.liferayserverurl
      @liferay_axis_secure = Rails.configuration.liferayaxissecure
      @liferay_wsdl_permission_service = Rails.configuration.liferaywsdlpermissionsservice

      @liferay_url = "#{@liferay_server_protocol}#{@liferay_server_user}:#{@liferay_server_pass}@#{@liferay_server_url}#{@liferay_axis_secure}#{@liferay_wsdl_permission_service}?wsdl"
      puts "Liferay PermissionsService wsdl = #{@liferay_url}"
      @client = Savon::Client.new(@liferay_url)
   end
   
   def add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
     begin
       response = @client.request :set_individual_resource_permissions, body: {groupId: group_id, 
         companyId: company_id, name: name, primKey: prim_key, roleId: role_id, actionIds:{ actionId: action_ids}}

       if response.success?
         return "applied"
       end

     rescue Savon::Error => error
       Rails.logger.warn.to_s
       return "notapplied"
     end

   end
  
end