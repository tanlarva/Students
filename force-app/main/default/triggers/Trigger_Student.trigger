/**
	* Trigger_Student
	* lọc và xử lí dữ liệu trước và sau
	* @param: 
	* @return:  
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/
trigger Trigger_Student on Student__c (before insert, after insert, after update, after delete) {
    if(Trigger.isBefore){
        if (Trigger.isInsert) {
            List<Student__c> stu = new List<Student__c>();
            for(Student__c s : Trigger.new){
                stu.add(s);
            }
            TriggerStudentHandle.onBeforeInsert(stu);
        }
    }else if(Trigger.isAfter){
        if(Trigger.isInsert){
            List<Student__c> stu = new List<Student__c>();
            for(Student__c s : Trigger.new){
                stu.add(s);
            }
            TriggerStudentHandle.onAfterInsert(stu);
        }else if (Trigger.isUpdate) {
            List<Student__c> stuOld = new List<Student__c>();
            for(Student__c s : Trigger.old){
                stuOld.add(s);
            }
            List<Student__c> stuNew = new List<Student__c>();
            for(Student__c s : Trigger.new){
                stuNew.add(s);
            }
            TriggerStudentHandle.onAfterUpdate(stuOld, stuNew);
        }else if(Trigger.isDelete){
            List<Student__c> stu = new List<Student__c>();
            for(Student__c s : Trigger.old){
                stu.add(s);
            }
            TriggerStudentHandle.onAfterDelete(stu);
        }
    }
}