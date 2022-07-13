/**
	* Trigger_Student
	* lọc và xử lí dữ liệu trước và sau
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/
trigger Trigger_Student on Student__c (before insert, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TriggerStudentHandle.onBeforeInsert(Trigger.new);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TriggerStudentHandle.onAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            TriggerStudentHandle.onAfterUpdate(Trigger.old, Trigger.new);
        } else if (Trigger.isDelete) {
            TriggerStudentHandle.onAfterDelete(Trigger.old);
        }
    }
}
/**
 * Chú thích :
 * Trigger old - new đều là List
 * Nên dùng dạng Map
 * 
 */