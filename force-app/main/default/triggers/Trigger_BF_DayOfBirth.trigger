trigger Trigger_BF_DayOfBirth on Student__c (before insert) {
    for(Student__c stu: Trigger.new){
        if(stu.dayOfBirth__c==null){
            //Check đã nhập ngày sinh chưa
            stu.dayOfBirth__c.addError(Label.null_dayOfBirth);
        }else{
            //Đã nhập rồi thì kiểm tra phù hợp chưa
            integer[] month;
            
            Date present_date = System.today();
            Integer present_Day =  present_date.Day();
            Integer present_month = present_date.Month();
            Integer present_year =  present_date.Year();
	   
            if(math.mod(present_year,4)==0){
                month = new list <integer>{ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
            }else{
                month = new list <integer>{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
            }

            Date birth_date = stu.dayOfBirth__c;
            Integer birth_Day =  birth_date.Day();
	        Integer birth_month = birth_date.Month();
	        Integer birth_year = birth_date.Year();    
            
        
            if (birth_day > present_day) {
                present_day = present_day + month[birth_month - 1];
                present_month = present_month - 1;
            } 
            
                
            if (birth_month > present_month) {
            present_year = present_year - 1;
            present_month = present_month + 12;
            }   
    
        
            integer final_day = present_day - birth_day;
            integer final_month = present_month - birth_month;
            integer final_year = present_year - birth_year;

            if(final_year<6 || final_year>18){
                stu.dayOfBirth__c.addError(Label.illegal_dayOfBirth);
            }
        }
    }
}