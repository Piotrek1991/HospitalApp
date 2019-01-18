/**
 * Created by BRITENET on 02.01.2019.
 */

@RestResource(urlMapping='/Hospital__c/*')
global with sharing class Hospital_HospitalREST {

    @HttpGet
    global static List<Hospital_HospitalWrapperForRest> getHospitals() {
        Map<String, String> requestParams = RestContext.request.params;
        String query = generateQuery(requestParams);
        if (query == null) {
            return new List<Hospital_HospitalWrapperForRest>();
        }
        List<Hospital__c> rawHospitals = Database.query(query);
        List<Hospital_HospitalWrapperForRest> hospitals = new List<Hospital_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : rawHospitals) {
            hospitals.add(new Hospital_HospitalWrapperForRest(rawHospital));
        }
        return hospitals;
    }

    @HttpPut
    global static List<Hospital_HospitalWrapperForRest> upsertHospitals(List<Hospital_HospitalWrapperForRest> hospitals) {
        List<Hospital__c> hospitalListToInsert = new List<Hospital__c>();
        List<Hospital__c> hospitalListToUpdate = new List<Hospital__c>();
        List<Hospital_HospitalWrapperForRest> hospitalListToInsertWrapper = new List<Hospital_HospitalWrapperForRest>();
        List<Hospital_HospitalWrapperForRest> hospitalListToUpdateWrapper = new List<Hospital_HospitalWrapperForRest>();

        List<String> externalIds = new List<String>();

        for (Hospital_HospitalWrapperForRest hospital : hospitals) {
            if (String.isBlank(hospital.externalId)) {
                hospital.externalId = hospital.name + hospital.city + hospital.country + hospital.street;
            }
            externalIds.add(hospital.externalId);
        }

        List<Hospital__c> listToCompare = [SELECT Id, External_Id__c, Name, City__c, Country__c, Website__c, Street__c, PostalCode__c FROM Hospital__c WHERE External_Id__c IN:externalIds];

        for (Hospital__c hospital : listToCompare) {
            System.debug('Hospital from compare' + hospital);
            for (Hospital_HospitalWrapperForRest hospitalExternal : hospitals) {
                System.debug('Hospital from hospitalExternal' + hospitalExternal);
                if (String.valueOf(hospital.External_Id__c).equals(hospitalExternal.externalId)) {
                    hospital.Name = hospitalExternal.name;
                    hospital.Country__c = hospitalExternal.country;
                    hospital.City__c = hospitalExternal.city;
                    hospital.PostalCode__c = hospitalExternal.postalCode;
                    hospital.Street__c = hospitalExternal.street;
                    hospitalListToUpdate.add(hospital);
                }
            }
        }
        System.debug('hospitalListToUpdate >> ' + hospitalListToUpdate);

        System.debug('hospitals >>> ' + hospitals);

        if (listToCompare.size() == 0) {
            for (Hospital_HospitalWrapperForRest hospitalFrom : hospitals) {
                hospitalListToInsert.add(new Hospital__c(
                        External_Id__c = hospitalFrom.externalId,
                        Name = hospitalFrom.name,
                        Country__c = hospitalFrom.country,
                        City__c = hospitalFrom.city,
                        PostalCode__c = hospitalFrom.postalCode,
                        Street__c = hospitalFrom.street));
            }

        } else {
            for (Hospital_HospitalWrapperForRest hospitalFrom : hospitals) {
                for (Hospital__c hospital : listToCompare) {
                    System.debug('String.valueOf(hospital.External_Id__c)' + String.valueOf(hospital.External_Id__c));
                    System.debug('hospitalFrom.externalId' + hospitalFrom.hospitalId);
                    if (String.isBlank(hospitalFrom.hospitalId) && !String.valueOf(hospital.External_Id__c).equals(hospitalFrom.externalId)) {
                        hospitalListToInsert.add(new Hospital__c(
                                External_Id__c = hospitalFrom.externalId,
                                Name = hospitalFrom.name,
                                Country__c = hospitalFrom.country,
                                City__c = hospitalFrom.city,
                                PostalCode__c = hospitalFrom.postalCode,
                                Street__c = hospitalFrom.street));
                    }
                }
            }
        }


        if (hospitalListToUpdate.size() > 0) {
            List<Database.SaveResult> resultsFromUpdate = Database.update(hospitalListToUpdate, false);
            hospitalListToUpdateWrapper = generateWrapperFromHospital(hospitalListToUpdate);
            generateStatusToRecords(resultsFromUpdate, hospitalListToUpdateWrapper);
        }


        System.debug('hospitalListToInsert' + hospitalListToInsert);
        if (hospitalListToInsert.size() > 0) {
            List<Database.SaveResult> resultsFromInsert = Database.insert(hospitalListToInsert, false);
            hospitalListToInsertWrapper = generateWrapperFromHospital(hospitalListToInsert);
            generateStatusToRecords(resultsFromInsert, hospitalListToInsertWrapper);
        }

        hospitalListToInsert.addAll(hospitalListToUpdate);

        List<Hospital_HospitalWrapperForRest> resultsHospitals = new List<Hospital_HospitalWrapperForRest>();
        resultsHospitals.addAll(hospitalListToUpdateWrapper);
        resultsHospitals.addAll(hospitalListToInsertWrapper);

        return resultsHospitals;
    }

    private static void generateStatusToRecords(List<Database.SaveResult> results, List<Hospital_HospitalWrapperForRest> hospitalListToInsert) {
        for (Integer i = 0; i < results.size(); i++) {
            if (results.get(i).isSuccess()) {
                hospitalListToInsert.get(i).status = true;
            } else {
                hospitalListToInsert.get(i).status = false;
            }
        }
    }

    private static List<Hospital_HospitalWrapperForRest> generateWrapperFromHospital(List<Hospital__c> hospitals) {
        List<Hospital_HospitalWrapperForRest> resultsHospitals = new List<Hospital_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : hospitals) {
            resultsHospitals.add(new Hospital_HospitalWrapperForRest(rawHospital));
        }
        return resultsHospitals;
    }


    @HttpDelete
    global static List<Hospital_HospitalWrapperForRest> deleteHospitals() {
        RestRequest request = RestContext.request;
        String hospitalIds = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        List<String> ids = hospitalIds.split(',');
        System.debug('Id from external service' + ids);
        List<Hospital__c> listToDel = [
                SELECT Id,
                        External_Id__c,
                        Name,
                        Country__c,
                        City__c,
                        PostalCode__c,
                        Street__c
                FROM Hospital__c
                WHERE External_Id__c IN :ids
        ];
        delete listToDel;
        List<Hospital_HospitalWrapperForRest> hospitals = new List<Hospital_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : listToDel) {
            hospitals.add(new Hospital_HospitalWrapperForRest(rawHospital));
        }
        return hospitals;
    }

    private static String generateQuery(Map<String, String> pairsNameValue) {
        String query = 'SELECT Id, External_Id__c, Name, Country__c, City__c, PostalCode__c, Street__c FROM Hospital__c';
        try {
            Set<String> fields = pairsNameValue.keySet();
            if (!fields.isEmpty()) {
                Integer i = 0;
                Map<String, Schema.SObjectField> fieldsWithTypes = Schema.SObjectType.Hospital__c.fields.getMap();
                String fieldType;
                for (String field : fields) {
                    fieldType = fieldsWithTypes.get(field).getDescribe().getType().name();
                    if (i != 0) {
                        query += ' AND ';
                    } else {
                        query += ' WHERE ';
                    }
                    if (fieldType != 'INTEGER' && fieldType != 'DOUBLE' && fieldType != 'CURRENCY' && fieldType != 'DATE' && fieldType != 'BOOLEAN') {
                        query += field + ' LIKE \'' + pairsNameValue.get(field) + '%\'';
                    } else {
                        query += field + ' = ' + pairsNameValue.get(field);
                    }
                    i++;
                }
            }
        } catch (Exception ex) {
            System.debug(ex);
            return null;
        }
        return query;
    }
}