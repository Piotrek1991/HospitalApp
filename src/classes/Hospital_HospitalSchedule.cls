/**
 * Created by BRITENET on 16.01.2019.
 */

global class Hospital_HospitalSchedule implements Schedulable{

    public static String timeSchedule = Hospital_DoctorUtils.getCsValue('InsertHospitalSchedule');

    global static String scheduleMe() {
        Hospital_HospitalSchedule hospitalSchedule = new Hospital_HospitalSchedule();
        return System.schedule('Insert hospital Job', timeSchedule, hospitalSchedule);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Hospital_HospitalBatch(),200);
    }
}