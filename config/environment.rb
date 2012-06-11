# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Qanda::Application.initialize!


#application configuration parameters
Qanda::Application.config.liferayserveruser = ENV['LIFERAY_SERVER_USER']
Qanda::Application.config.liferayserverpass = ENV['LIFERAY_SERVER_USER_PASS']

Qanda::Application.config.liferay2012monitoringfolderid = '16031'
Qanda::Application.config.liferaymcocgroupid = '10702'
Qanda::Application.config.liferayserverprotocol = 'http://'
Qanda::Application.config.liferayserverurl = '127.0.0.1:8090'
Qanda::Application.config.liferayaxissecure = '/tunnel-web/secure/axis/'

Qanda::Application.config.liferaywsdlfolderservice = 'Portlet_DL_DLFolderService'
Qanda::Application.config.liferaywsdlfileentryservice = 'Portlet_DL_DLFileEntryService'

Qanda::Application.config.questionnairefilename = '2012-questionnaire.pdf'

Qanda::Application.config.doclibrootstem = "http://localhost:8090"
Qanda::Application.config.doclibrootmainecoc = "/group/maine-continuum-of-care/documents/-/document_library/view/"


