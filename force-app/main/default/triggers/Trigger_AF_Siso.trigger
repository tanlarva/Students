trigger Trigger_AF_Siso on Student__c (after insert, after delete, after update) {
    if(Trigger.isInsert){
        for( Student__c stu : Trigger.new){
            for(Class__c classUpdate : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stu.Class__c]){
                classUpdate.numStu__c++;
                update classUpdate;
            }   
        }
    }else if(Trigger.isDelete){
        for( Student__c stu : Trigger.old){
            for(Class__c classUpdate : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stu.Class__c]){
                classUpdate.numStu__c--;
                update classUpdate;
            }   
        }
    }else if(Trigger.isUpdate){
        for(Student__c stuOld : Trigger.old){
            for(Class__c classMinus : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stuOld.Class__c]){
                classMinus.numStu__c++;
                update classMinus;
            }   
        }
        for(Student__c stuNew : Trigger.new){
            for(Class__c classAdd : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stuNew.Class__c]){
                classAdd.numStu__c++;
                update classAdd;
            }   
        }
    }  
}