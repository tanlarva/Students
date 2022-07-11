/**
 * ClassName: AR_Student_Controller
 * ClassDetail: Hỗ trợ cho các page Them moi, Cap nhat
 * @Create: 2022/06/06 Phan Duy Tân
 * @Modify: 
 */
public with sharing class AR_Student_Controller {
    /**
	* Contructor
	* init
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    public AR_Student_Controller() {}

    /**
	* createStudent
	* Tạo mới Student
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static void createStudent(Student__c dataStudent){
        try {
            insert dataStudent;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
	* updateStudent
	* Cập Nhật lại Student
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static void updateStudent(Student__c dataStudent){
        try {
            update dataStudent;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    /**
	* getDataStudent
	* Lấy dữ liệu học sinh bằng Id
	* @param: 
	* @return: Student__c
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static Student__c getDataStudent(Id id){
        try {
            Student__c dataStudent = [SELECT Id, firstName__c, Class__c, lastName__c, Sex__c, dayOfBirth__c, Diem1__c,Diem2__c, Diem3__c, GPA__c, Status__c, XepLoai__c FROM Student__c WHERE Id =:id];
            return dataStudent; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
	* getListClass
	* Lấy danh sách lớp cho lựa chọn
	* @param: 
	* @return: Map<String,String>
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static Map<String,String> getListClass(){
        Map<String,String> options = new Map<String,String>();
        for(Class__c item : [SELECT Id, nameClass__c FROM Class__c]){
            options.put(item.Id, item.nameClass__c);
        }
        return options;
    }

}
