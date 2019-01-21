/**
 * Created by BRITENET on 20.01.2019.
 */

global class Hospital_ErrorsBatchDeleteSchedule implements Schedulable {
    public static String timeSchedule = Hospital_DoctorUtils.getCsValue('DeleteHospitalLogsSchedule');

    global static String scheduleErrorDeleteBatch() {
        Hospital_ErrorsBatchDeleteSchedule hospitalSchedule = new Hospital_ErrorsBatchDeleteSchedule();
        return System.schedule('Delete errors Job', timeSchedule, hospitalSchedule);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Hospital_ErrorsBatchDelete(),200);
    }
}