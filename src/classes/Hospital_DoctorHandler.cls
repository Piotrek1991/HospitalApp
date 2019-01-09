/**
 * Created by BRITENET on 13.12.2018.
 */


public with sharing class Hospital_DoctorHandler {
    public static String getDoctorsInJson(List<Doctor__c> doctorsToExport) {
        JSONGenerator generator = JSON.createGenerator(true);

        generator.writeStartArray();

        for (Doctor__c doc : doctorsToExport) {
            generator.writeStartObject();

            generator.writeStringField(Schema.Doctor__c.fields.Name.getDescribe().getLabel(), notBlankField(doc.FirstNameLastName__c));
            generator.writeStringField(Schema.Doctor__c.fields.Email__c.getDescribe().getLabel(), notBlankField(doc.Email__c));
            generator.writeStringField(Schema.Doctor__c.fields.Country__c.getDescribe().getLabel(), notBlankField(doc.Country__c));

            generator.writeEndObject();
        }

        generator.writeEndArray();

        return generator.getAsString();
    }

    private static String notBlankField(String field) {
        if (String.isNotBlank(field)) {
            return field;
        } else {
            return '';
        }
    }
}