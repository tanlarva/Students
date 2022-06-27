trigger Trigger_AF_XepLoai on Student__c (after insert, after update) {
    if(Trigger.isInsert){
        Student__c stu = new Student__c();
        for(Student__c stud: Trigger.new){
            stu = stud;
            System.debug('@@@'+stu);
        }
        List<Student__c> stus = [SELECT Id, Name, GPA__c, XepLoai__c FROM Student__c WHERE Id =:stu.Id ];
        for(Student__c stuUp: stus){
            if(stuUp.GPA__c>=8){
                stuUp.XepLoai__c = 'Giỏi';
            }else if(stuUp.GPA__c>=6.5){
                stuUp.XepLoai__c = 'Khá';
            }else if(stuUp.GPA__c>=5){
                stuUp.XepLoai__c = 'Trung Bình';
            }else if(stu.GPA__c>=0){
                stuUp.XepLoai__c = 'Yếu';
            }
        }
        update stus;

    }else if(Trigger.isUpdate){
        Student__c stuNew = new Student__c();
        Student__c stuOld = new Student__c();

        for(Student__c stu :Trigger.old){
            stuOld = stu;
        }
        for(Student__c stu : Trigger.new){
            stuNew = stu;
        }
    
        Student__c temp = stuNew.clone(true,true,true,false);

        List<Student__c> udt = new List<Student__c>();


        System.debug('####'+temp);
        
        if(temp.GPA__c>=8){
            temp.XepLoai__c = 'Giỏi';
        }else if(temp.GPA__c>=6.5){
            temp.XepLoai__c = 'Khá';
        }else if(temp.GPA__c>=5){
            temp.XepLoai__c = 'Trung Bình';
        }else if(temp.GPA__c>=0){
            temp.XepLoai__c = 'Yếu';
        }

        udt.add(temp);

        if(stuOld.XepLoai__c != temp.XepLoai__c){
            upsert udt;
        }
    }
}