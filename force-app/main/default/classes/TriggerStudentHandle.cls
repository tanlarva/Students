/**
* ClassName: TriggerStudentHandle
* ClassDetail: Xử lí trigger cho Student
* @created: 2022/06/28 Phan Duy Tân
* @modified:
*/
public class TriggerStudentHandle {
    //Tuổi lớn nhất
    private static final Integer MAX_AGE = 18;
    //Tuổi nhỏ nhât
    private static final Integer MIN_AGE = 6;
    //Đậu
    private static final String PASS = 'Đậu';
    //Rớt
    private static final String FAIL = 'Rớt';
    /**
	* Contructor
	* init
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/    
    public TriggerStudentHandle() {}
    /**
	* onBeforeInsert
	* Xử lí trước insert
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onBeforeInsert(List<Student__c> triggerNew) {
        for(Student__c stu : triggerNew) {
            //Check ngày sinh
            if (stu.dayOfBirth__c == null) {
                //Check đã nhập ngày sinh chưa
                stu.dayOfBirth__c.addError(Label.null_dayOfBirth);
            } else {
                //Đã nhập rồi thì kiểm tra phù hợp chưa
                integer[] month;
                
                Date presentDate = System.today();
                Integer presentDay =  presentDate.Day();
                Integer presentMonth = presentDate.Month();
                Integer presentYear =  presentDate.Year();


           
                if (math.mod(presentYear,4) == 0) {
                    month = new list <integer>{ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
                } else {
                    month = new list <integer>{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
                }
    
                Date birthDate = stu.dayOfBirth__c;
                Integer birthDay =  birthDate.Day();
                Integer birthMonth = birthDate.Month();
                Integer birthYear = birthDate.Year();    
                
            
                if (birthDay > presentDay) {
                    presentDay = presentDay + month[birthMonth - 1];
                    presentMonth = presentMonth - 1;
                } 
                
                    
                if (birthMonth > presentMonth) {
                presentYear = presentYear - 1;
                presentMonth = presentMonth + 12;
                }   
        
            
                integer finalDay = presentDay - birthDay;
                integer finalMonth = presentMonth - birthMonth;
                integer finalYear = presentYear - birthYear;
    
                if (finalYear < MIN_AGE || finalYear > MAX_AGE) {
                    stu.dayOfBirth__c.addError(Label.illegal_dayOfBirth);
                }
            }
            //Check input điểm
            if (stu.Diem1__c == null) {
                stu.Diem1__c.addError(Label.non_DiemHoa);
            }else if (stu.Diem2__c == null) {
                stu.Diem2__c.addError(Label.non_DiemLy);
            }else if (stu.Diem3__c == null) {
                stu.Diem3__c.addError(Label.non_DiemToan);
            }
            //Check 
        }
    }
    /**
	* onAfterInsert
	* Xử lí sau khi Insert
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onAfterInsert(List<Student__c> triggerNew) {
        List<Class__c> updateClass = new List<Class__c>();
        String checkIdClass = 'null';
        for(Student__c stu : triggerNew) {
            String temp = stu.Class__c;
            //Lấy class
            if (checkIdClass != temp) {
                checkIdClass = temp;
                for(Class__c classUpdate:  [SELECT Id, numStu__c, numPass__c, numFail__c FROM Class__c WHERE Id =: stu.Class__c] ) {
                    updateClass.add(classUpdate);
                }
            }
        }

        for(Class__c upClass : updateClass) {
            for(Student__c stu : triggerNew) {
                if (upClass.Id == stu.Class__c) {
                    //Cập nhật sĩ số
                    upClass.numStu__c = upClass.numStu__c+1;
                    //Cập nhật đậu rớt
                    if (stu.Status__c == PASS) {
                        upClass.numPass__c = upClass.numPass__c+1;
                    } else if (stu.Status__c == FAIL) {
                        upClass.numFail__c = upClass.numFail__c+1;
                    }
                }
            }
        }

        try{
            update updateClass;
        }catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        

         //Xếp loại
         List<Student__c> listStudent = [SELECT Id, Name, GPA__c, XepLoai__c FROM Student__c WHERE Id IN : triggerNew];
         for (Student__c stuUp: listStudent) {
             if (stuUp.GPA__c >= 8) {
                 stuUp.XepLoai__c = 'Giỏi';
             } else if (stuUp.GPA__c >= 6.5) {
                 stuUp.XepLoai__c = 'Khá';
             } else if (stuUp.GPA__c >= 5) {
                 stuUp.XepLoai__c = 'Trung Bình';
             }else if (stuUp.GPA__c >= 0) {
                 stuUp.XepLoai__c = 'Yếu';
             }
         }
        
        try{
            update listStudent;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
         
    }
    /**
	* onAfterDelete
	* Xử lí sau khi delete
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onAfterDelete(List<Student__c> triggerNew) {
        String checkIdClass;
        List<Class__c> updateClass = new List<Class__c>();
        
        checkIdClass = 'null';
        for(Student__c stu: triggerNew) {
            String temp = stu.Class__c;
            if (checkIdClass != temp) {
                checkIdClass = temp;
                for(Class__c classUpdate : [SELECT Id, numStu__c, numPass__c, numFail__c FROM Class__c WHERE Id =:stu.Class__c]){
                    updateClass.add(classUpdate);
                }
            }
        }

        for(Class__c upClass : updateClass) {
            for(Student__c stu : triggerNew) {
                if (upClass.Id == stu.Class__c) {
                    upClass.numStu__c--;
                    if(stu.Status__c == PASS){
                        upClass.numPass__c--;
                    }else if(stu.Status__c == FAIL){
                        upClass.numFail__c--;
                    }
                }
            }
        }
        
        try {
            update updateClass;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
       
    }
    /**
	* onAfterUpdate
	* Xử lí sau khi update
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onAfterUpdate(List<Student__c> triggerNew, List<Student__c> triggerOld) {
        List<Class__c> updateClass = [SELECT Id,numStu__c , numPass__c, numFail__c FROM Class__c];
        for(Integer i = 0; i < triggerNew.size(); i++) {
            if (triggerNew[i].Class__c != triggerOld[i].Class__c) {
                for(Class__c c : updateClass) {
                    if (triggerNew[i].Class__c == c.Id) {
                        c.numStu__c--;
                        if (triggerNew[i].Status__c == PASS) {
                            c.numPass__c--;
                        } else if (triggerNew[i].Status__c == FAIL) {
                            c.numFail__c--;
                        }
                    }
                    if (triggerOld[i].Class__c == c.Id) {
                        c.numStu__c++;
                        if (triggerOld[i].Status__c == PASS) {
                            c.numPass__c++;
                        } else if (triggerOld[i].Status__c == FAIL) {
                            c.numFail__c++;
                        }
                    }
                }
            } else {
                for(Class__c c : updateClass) {
                    if (triggerOld[i].Status__c != triggerNew[i].Status__c) {
                        if (triggerOld[i].Status__c == PASS) {
                            c.numPass__c++;
                            c.numFail__c--;
                        } else if (triggerOld[i].Status__c == FAIL) {
                            c.numFail__c++;
                            c.numPass__c--;
                        }
                    }
                }
            }
        }

        try {
            update updateClass;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
        List<Student__c> udt = new List<Student__c>();

        for(Student__c stu : triggerOld){
            Student__c temp = stu.clone(true,true,true,false);
            if (temp.GPA__c >= 8) {
                temp.XepLoai__c = 'Giỏi';
            } else if (temp.GPA__c >= 6.5) {
                temp.XepLoai__c = 'Khá';
            } else if (temp.GPA__c >= 5) {
                temp.XepLoai__c = 'Trung Bình';
            } else if (temp.GPA__c >= 0) {
                temp.XepLoai__c = 'Yếu';
            }
            udt.add(temp);
        }
        
        for(Integer i = 0; i < triggerNew.size(); i++) {
            if (triggerNew[i].XepLoai__c != udt[i].XepLoai__c) {
                try {
                    upsert udt[i];
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                }
            }
        }
    }
}