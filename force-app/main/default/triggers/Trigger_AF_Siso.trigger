trigger Trigger_AF_Siso on Student__c (after insert, after delete, after update) {
    if(Trigger.isInsert){
        for( Student__c stu : Trigger.new){
            Class__c upCLass = new Class__c();
            for(Class__c classUpdate : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stu.Class__c]){
                upClass = classUpdate;
            }
            upCLass.numStu__c= upCLass.numStu__c+1;
            update upCLass;   
        }
    }else if(Trigger.isDelete){
        for( Student__c stu : Trigger.old){
            Class__c upCLass = new Class__c();
            for(Class__c classUpdate : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stu.Class__c]){
                upClass = classUpdate;
            }
            upCLass.numStu__c=upCLass.numStu__c-1;
            update upCLass;   
        }
    }else if(Trigger.isUpdate){
        for(Student__c stuOld : Trigger.old){
            Class__c reCLass = new Class__c();
            for(Class__c classMinus : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stuOld.Class__c]){
                reClass = classMinus;
            }
            reCLass.numStu__c=reCLass.numStu__c-1;
            update reCLass;  
        }
        for(Student__c stuNew : Trigger.new){
            Class__c upCLass = new Class__c();
            for(Class__c classAdd : [SELECT Id, numStu__c FROM Class__c WHERE Id =:stuNew.Class__c]){
                upClass = classAdd;
            }
            upCLass.numStu__c=upClass.numStu__c+1;
            update upCLass;
        }
    }  
}