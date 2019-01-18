/**
 * Created by BRITENET on 17.01.2019.
 */

public interface ITrigger {

    void beforeInsert(List<SObject> so);

    void beforeUpdate(List<SObject> oldSo);

//    void beforeDelete(Map<Id, SObject> hospitalMap);

    void beforeDelete(List<SObject> hospitalMap);

    void afterInsert(List<SObject> so);

    void afterUpdate(List<SObject> oldSo);

    void afterDelete(List<SObject> so);

//    void beforeInsert(SObject so);
//
//    void beforeUpdate(SObject oldSo, SObject so);
//
//    void beforeDelete(SObject so);
//
//    void afterInsert(SObject so);
//
//    void afterUpdate(SObject oldSo, SObject so);
//
//    void afterDelete(SObject so);
}