trigger Trigger_BF_Diem on Student__c (before insert) {
    for(Student__c stu: Trigger.new){
        if(stu.Diem1__c==null){
            stu.Diem1__c.addError(Label.non_DiemHoa);
        }else if(stu.Diem2__c==null){
            stu.Diem2__c.addError(Label.non_DiemLy);
        }else if(stu.Diem3__c==null){
            stu.Diem3__c.addError(Label.non_DiemToan);
        }
    }
}