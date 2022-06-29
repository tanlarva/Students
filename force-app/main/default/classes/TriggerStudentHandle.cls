/**
* ClassName: TriggerStudentHandle
* ClassDetail: Xử lí trigger cho Student
* @created: 2022/06/28 Phan Duy Tân
* @modified:
*/
public class TriggerStudentHandle {
    /**
	* Contructor
	* init
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/    
    public TriggerStudentHandle() {

    }
    /**
	* onBeforeInsert
	* Xử lí trước insert
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onBeforeInsert(List<Student__c> a){
        for(Student__c stu : a){
            //Check ngày sinh
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
            //Check input điểm
            if(stu.Diem1__c==null){
                stu.Diem1__c.addError(Label.non_DiemHoa);
            }else if(stu.Diem2__c==null){
                stu.Diem2__c.addError(Label.non_DiemLy);
            }else if(stu.Diem3__c==null){
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
    public static void onAfterInsert(List<Student__c> a){
        Student__c student = new Student__c();
        Class__c upClass = new Class__c();
        for(Student__c stu : a){
            student = stu;
            for(Class__c classUpdate:  [SELECT Id, numStu__c, numPass__c, numFail__c FROM Class__c WHERE Id =:stu.Class__c] ){
                upClass = classUpdate;
            }
        }
         //Cập nhật sĩ số
         upClass.numStu__c = upClass.numStu__c+1;
         //Cập nhật đậu rớt
         if(student.Status__c == 'Đậu'){
             upClass.numPass__c = upClass.numPass__c+1;
         }else if(student.Status__c == 'Rớt'){
             upClass.numFail__c = upClass.numFail__c+1;
         }
         update upClass;

         //Xếp loại
         List<Student__c> stus = [SELECT Id, Name, GPA__c, XepLoai__c FROM Student__c WHERE Id =:student.Id ];
         for(Student__c stuUp: stus){
             if(stuUp.GPA__c>=8){
                 stuUp.XepLoai__c = 'Giỏi';
             }else if(stuUp.GPA__c>=6.5){
                 stuUp.XepLoai__c = 'Khá';
             }else if(stuUp.GPA__c>=5){
                 stuUp.XepLoai__c = 'Trung Bình';
             }else if(stuUp.GPA__c>=0){
                 stuUp.XepLoai__c = 'Yếu';
             }
         }
         update stus;
    }
    /**
	* onAfterDelete
	* Xử lí sau khi delete
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onAfterDelete(List<Student__c> a){
        Class__c upClass = new Class__c();
        Student__c student = new Student__c();
        for(Student__c stu: a){
            for(Class__c classUpdate : [SELECT Id, numStu__c, numPass__c, numFail__c FROM Class__c WHERE Id =:stu.Class__c]){
                upClass = classUpdate;
            }
        }
        //Cập nhật số lượng học sinh
        upCLass.numStu__c=upCLass.numStu__c-1;
        
        //Cập nhật số học sinh đậu rớt
        if(student.Status__c=='Đậu'){
            upClass.numPass__c--;
        }else if(student.Status__c=='Rớt'){
            upClass.numFail__c--;
        }

        update upCLass;
    }
    /**
	* onAfterUpdate
	* Xử lí sau khi update
	* @param: 
	* @return: 
	* @created: 2022/06/28 Phan Duy Tân
	* @modified:
	**/  
    public static void onAfterUpdate(List<Student__c> a,List<Student__c> b){
        Class__c classOld = new Class__c();
        Class__c classNew = new Class__c();
        Student__c studentNew = new Student__c();
        Student__c studentOld = new Student__c();
        for(Student__c stuOld : a){
            for(Class__c classMinus : [SELECT Id, numPass__c, numFail__c FROM Class__c WHERE Id =:stuOld.Class__c]){
                classOld = classMinus;
            }
            studentOld = stuOld;
        }
        for(Student__c stuNew : b){
            for(Class__c classAdd : [SELECT Id, numPass__c, numFail__c FROM Class__c WHERE Id =:stuNew.Class__c]){
                classNew = classAdd;
            }
            studentNew = stuNew;
        }
        
        if(classOld!=classNew){
            System.debug('Lớp khác');
            if(studentOld.Status__c=='Đậu'){
                classOld.numPass__c--;
            }else if(studentOld.Status__c=='Rớt'){
                classOld.numFail__c--;
            }
            classOld.numStu__c--;
            update classOld;
    
            if(studentNew.Status__c=='Đậu'){
                classNew.numPass__c++;
            }else if(studentNew.Status__c=='Rớt'){
                classNew.numFail__c++;
            }
            classNew.numStu__c++;
            update classNew;
        }else if(studentOld.Status__c!=studentNew.Status__c){
            System.debug('Lớp cũ');
            if(studentNew.Status__c=='Đậu'){
                classNew.numPass__c++;
                classNew.numFail__c--;
            }else if(studentNew.Status__c=='Rớt'){
                classNew.numPass__c--;
                classNew.numFail__c++;
            }
            update classNew;
        }
       
        //Sao chép đối tượng
        Student__c temp = studentNew.clone(true,true,true,false);

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

        if(studentOld.XepLoai__c != temp.XepLoai__c){
            upsert udt;
        }
    }
}
