/**
 * Created by BRITENET on 17.01.2019.
 */

global class Hospital_LogsBatchDeleteSchedule implements Schedulable {

    public static String timeSchedule = Hospital_DoctorUtils.getCsValue('DeleteHospitalLogsSchedule');

    global static String scheduleDeleteBatch() {
        Hospital_LogsBatchDeleteSchedule hospitalSchedule = new Hospital_LogsBatchDeleteSchedule();
        return System.schedule('Delete hospital Job', timeSchedule, hospitalSchedule);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Hospital_LogsBatchDelete(),200);
    }
}