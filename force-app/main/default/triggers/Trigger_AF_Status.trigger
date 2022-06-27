trigger Trigger_AF_Status on Student__c (after insert, after delete, after update) {
    if(Trigger.isInsert){
        for( Student__c stu : Trigger.new){
            for(Class__c classUpdate : [SELECT Id, numPass__c, numFail__c FROM Class__c WHERE Id =:stu.Class__c]){
                if(stu.Status__c=='Đậu'){
                    classUpdate.numPass__c++;
                }else if(stu.Status__c=='Rớt'){
                    classUpdate.numFail__c++;
                }
                update classUpdate;
            }   
        }
    }else if(Trigger.isDelete){
        for( Student__c stu : Trigger.old){
            for(Class__c classUpdate : [SELECT Id, numPass__c, numFail__c FROM Class__c WHERE Id =:stu.Class__c]){
                if(stu.Status__c=='Đậu'){
                    classUpdate.numPass__c--;
                }else if(stu.Status__c=='Rớt'){
                    classUpdate.numFail__c--;
                }
                update classUpdate;
            }   
        }
    }else if(Trigger.isUpdate){
        for(Student__c stuOld : Trigger.old){
            for(Class__c classMinus : [SELECT Id, numPass__c, numFail__c FROM Class__c WHERE Id =:stuOld.Class__c]){
                if(stuOld.Status__c=='Đậu'){
                    classMinus.numPass__c--;
                }else if(stuOld.Status__c=='Rớt'){
                    classMinus.numFail__c--;
                }
                update classMinus;
            }   
        }
        for(Student__c stuNew : Trigger.new){
            for(Class__c classAdd : [SELECT Id, numPass__c, numFail__c FROM Class__c WHERE Id =:stuNew.Class__c]){
                if(stuNew.Status__c=='Đậu'){
                    classAdd.numPass__c++;
                }else if(stuNew.Status__c=='Rớt'){
                    classAdd.numFail__c++;
                }
                update classAdd;
            }   
        }
    }
}