//Generated by wsdl2apex

public class Hosp_MaciejSoapForDoctorsWebService {
    public class getDoctors_element {
        public String lastName;
        public String firstName;
        public String city;
        public String country;
        private String[] lastName_type_info = new String[]{'lastName','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] firstName_type_info = new String[]{'firstName','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'lastName','firstName','city','country'};
    }
    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] level_type_info = new String[]{'level','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class address {
        public String city;
        public String country;
        public String countryCode;
        public String geocodeAccuracy;
        public String postalCode;
        public String state;
        public String stateCode;
        public String street;
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] countryCode_type_info = new String[]{'countryCode','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] geocodeAccuracy_type_info = new String[]{'geocodeAccuracy','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] postalCode_type_info = new String[]{'postalCode','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] state_type_info = new String[]{'state','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] stateCode_type_info = new String[]{'stateCode','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] street_type_info = new String[]{'street','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'city','country','countryCode','geocodeAccuracy','postalCode','state','stateCode','street'};
    }
    public class deleteDoctorsResponse_element {
        public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class getDoctorsResponse_element {
        public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
    public class DebuggingHeader_element {
        public Hosp_MaciejSoapForDoctorsWebService.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public class upsertDoctor_element {
        public String doctorId;
        public String lastName;
        public String firstName;
        public String city;
        public String country;
        private String[] doctorId_type_info = new String[]{'doctorId','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] lastName_type_info = new String[]{'lastName','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] firstName_type_info = new String[]{'firstName','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'doctorId','lastName','firstName','city','country'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class upsertDoctorResponse_element {
        public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class location {
        public Double latitude;
        public Double longitude;
        private String[] latitude_type_info = new String[]{'latitude','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] longitude_type_info = new String[]{'longitude','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'latitude','longitude'};
    }
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    public class deleteDoctors_element {
        public String[] doctorsIds;
        private String[] doctorsIds_type_info = new String[]{'doctorsIds','http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService','true','false'};
        private String[] field_order_type_info = new String[]{'doctorsIds'};
    }
    public class Hosp_SoapForDoctorsWebService {
        public String endpoint_x = 'https://eu16.salesforce.com/services/Soap/class/Hosp_SoapForDoctorsWebService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public Hosp_MaciejSoapForDoctorsWebService.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public Hosp_MaciejSoapForDoctorsWebService.DebuggingInfo_element DebuggingInfo;
        public Hosp_MaciejSoapForDoctorsWebService.SessionHeader_element SessionHeader;
        public Hosp_MaciejSoapForDoctorsWebService.CallOptions_element CallOptions;
        public Hosp_MaciejSoapForDoctorsWebService.DebuggingHeader_element DebuggingHeader;
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService', 'Hosp_MaciejSoapForDoctorsWebService', 'http://soap.sforce.com/schemas/class/Hosp_DoctorWrapperForSoap', 'Hosp_MaciejDoctorWrapperForSoap'};
        public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap[] deleteDoctors(String[] doctorsIds) {
            Hosp_MaciejSoapForDoctorsWebService.deleteDoctors_element request_x = new Hosp_MaciejSoapForDoctorsWebService.deleteDoctors_element();
            request_x.doctorsIds = doctorsIds;
            Hosp_MaciejSoapForDoctorsWebService.deleteDoctorsResponse_element response_x;
            Map<String, Hosp_MaciejSoapForDoctorsWebService.deleteDoctorsResponse_element> response_map_x = new Map<String, Hosp_MaciejSoapForDoctorsWebService.deleteDoctorsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',
              'deleteDoctors',
              'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',
              'deleteDoctorsResponse',
              'Hosp_MaciejSoapForDoctorsWebService.deleteDoctorsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap upsertDoctor(String doctorId,String lastName,String firstName,String city,String country) {
            Hosp_MaciejSoapForDoctorsWebService.upsertDoctor_element request_x = new Hosp_MaciejSoapForDoctorsWebService.upsertDoctor_element();
            request_x.doctorId = doctorId;
            request_x.lastName = lastName;
            request_x.firstName = firstName;
            request_x.city = city;
            request_x.country = country;
            Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element response_x;
            Map<String, Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element> response_map_x = new Map<String, Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',
              'upsertDoctor',
              'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',
              'upsertDoctorResponse',
              'Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap[] getDoctors(String lastName,String firstName,String city,String country) {
            Hosp_MaciejSoapForDoctorsWebService.getDoctors_element request_x = new Hosp_MaciejSoapForDoctorsWebService.getDoctors_element();
            request_x.lastName = lastName;
            request_x.firstName = firstName;
            request_x.city = city;
            request_x.country = country;
            Hosp_MaciejSoapForDoctorsWebService.getDoctorsResponse_element response_x;
            Map<String, Hosp_MaciejSoapForDoctorsWebService.getDoctorsResponse_element> response_map_x = new Map<String, Hosp_MaciejSoapForDoctorsWebService.getDoctorsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',
              'getDoctors',
              'http://soap.sforce.com/schemas/class/Hosp_SoapForDoctorsWebService',
              'getDoctorsResponse',
              'Hosp_MaciejSoapForDoctorsWebService.getDoctorsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}