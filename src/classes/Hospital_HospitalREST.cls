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
        List<Hospital__c> hospitalListToUpdate = new List<Hospital__c>();
        List<Hospital__c> hospitalListToInsert = new List<Hospital__c>();
        Set<Hospital__c> hospitalSetToInsert = new Set<Hospital__c>();
        List<Hospital__c> hospitalListToDelete = new List<Hospital__c>();

        List<Hospital__c> listToCompare = [SELECT Id, External_Id__c, Name, City__c, Country__c, Website__c, Street__c, PostalCode__c FROM Hospital__c];


        for (Hospital_HospitalWrapperForRest hospitalFrom : hospitals) {
            for (Hospital__c hospitalFromDataBase : listToCompare) {
                if (hospitalFrom.hospitalId.equals(hospitalFromDataBase.External_Id__c)) {
                    hospitalFromDataBase.Name = hospitalFrom.name;
                    hospitalFromDataBase.PostalCode__c = hospitalFrom.postalCode;
                    hospitalFromDataBase.City__c = hospitalFrom.city;
                    hospitalFromDataBase.Country__c = hospitalFrom.country;
                    hospitalListToUpdate.add(hospitalFromDataBase);
                    break;
                } else {
                    hospitalSetToInsert.add(new Hospital__c(External_Id__c = hospitalFrom.hospitalId,
                            Name = hospitalFrom.name,
                            Country__c = hospitalFrom.country,
                            City__c = hospitalFrom.city,
                            PostalCode__c = hospitalFrom.postalCode,
                            Street__c = hospitalFrom.street));

                }

            }
        }

        if (hospitalListToUpdate.size() > 0) {
            hospitalSetToInsert.clear();
        }


        for (Hospital__c hospital : hospitalSetToInsert) {
            hospitalListToInsert.add(hospital);
        }
        System.debug('listToCompare >> ' + listToCompare);
        System.debug('hospitalListToInsert >> ' + hospitalListToInsert);
        System.debug('hospitalListToUpdate >> ' + hospitalListToUpdate);

        if (hospitalListToUpdate.size() > 0) {
            update hospitalListToUpdate;
        }
        if (hospitalListToInsert.size() > 0) {
            insert hospitalListToInsert;
        }


        List<Hospital_HospitalWrapperForRest> resultsHospitals = new List<Hospital_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : hospitalListToInsert) {
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
        String query = 'SELECT Id, Name, Country__c, City__c, PostalCode__c, Street__c FROM Hospital__c';
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