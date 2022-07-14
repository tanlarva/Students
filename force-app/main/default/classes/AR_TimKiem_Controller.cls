/**
 * ClassName: AR_TimKiem_Controller
 * ClassDetail: Hỗ trợ cho việc tìm kiếm
 * @Create: 2022/07/06 Phan Duy Tân
 * @Modify: 
 */
public with sharing class AR_TimKiem_Controller {
    @AuraEnabled
    public dataSearch dataSearch {get; set; }// Chứa dự liệu search

    /**
	* Contructor
	* init
	* @param: 
	* @return: 
	* @created: 2022/07/07 Phan Duy Tân
	* @modified:
	**/
    public AR_TimKiem_Controller() {}

    /**
	* searchStudent
	* queery dữ liệu với điều kiện nằm trong datasearch
	* @param: 
	* @return: List<Student__c>
	* @created: 2022/07/07 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static List<Student__c> searchStudent(dataSearch dataInput) {
        try{
            String query = dataInput.createQuery(dataInput);
            List<Student__c> data = Database.query(query);
            return data;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
	* getAllStudent
	* lấy toàn bộ danh sách học sinh ở trang tìm kiếm bắt đầu
	* @param: 
	* @return: List<Student__c>
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static List<Student__c> getAllStudent() {
        List<Student__c> data = new List<Student__c>();
        try {
            data = [SELECT Id, firstName__c, lastName__c, Sex__c, dayOfBirth__c, Diem1__c,Diem2__c, Diem3__c, GPA__c, Status__c FROM Student__c];
            return data;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
	* deleteStudent
	* xóa List học sinh
	* @param: 
	* @return: 
	* @created: 2022/07/07 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static void deleteStudent(List<Student__c> deleteStudent) {
        try {
            List<Student__c> listDelete = new List<Student__c>();
            for(Student__c s : [SELECT Id FROM Student__c WHERE Id IN: deleteStudent]) {
                listDelete.add(s);
            }
            if(listDelete.size()>0){
                delete listDelete;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    /**
    * ClassName: dataSearch
    * ClassDetail: chứa dữ liệu search
    * @created: 2022/07/06 Phan Duy Tân
    * @modified:
    */
    class dataSearch {
        @AuraEnabled
        public String nameStudent {get; set;}
        @AuraEnabled
        public String idCLass {get; set;}
        @AuraEnabled
        public String startDate {get; set;}
        @AuraEnabled
        public String endDate {get; set;}
        @AuraEnabled
        public Boolean sortName {get; set;}
        public dataSearch() {}
        public dataSearch(String nameStudent, String idCLass, String startDate, String endDate, Boolean sortName) {
            this.nameStudent = nameStudent;
            this.idCLass = idCLass;
            this.startDate = startDate;
            this.endDate = endDate;
            this.sortName = sortName;
        }
        public void setStartDate(String day) {
            this.startDate = day;
        }
        public void setEndDate(String day) {
            this.endDate = day;
        }

        /**
        * createQuery
        * Tạo truy vấn
        * @param: 
        * @return: String 
        * @created: 2022/07/07 Phan Duy Tân
        * @modified:
        **/
        public String createQuery(dataSearch dataSearch) {
            String query = 'SELECT Class__c, dayOfBirth__c,Diem1__c,Diem3__c,Diem2__c,firstName__c,GPA__c,Id,lastName__c,Sex__c,Status__c, Name FROM Student__c WHERE ';
            String query1, query2, query3, query4;
            System.debug('@@@' + (dataSearch));
            if (dataSearch != null) {
                if (dataSearch.nameStudent != null) {
                    query1 = ' (lastName__c LIKE \'%' + String.escapeSingleQuotes(dataSearch.nameStudent) + '%\')';
                }
                if ((dataSearch.startDate != '') && (dataSearch.endDate != '')) {
                    query2 = ' (dayOfBirth__c >= '+ String.escapeSingleQuotes(dataSearch.startDate) +' AND dayOfBirth__c <= '+ String.escapeSingleQuotes(dataSearch.endDate) +')';
                }else if (dataSearch.endDate != '') {
                    query2 = ' (dayOfBirth__c <= '+ String.escapeSingleQuotes(dataSearch.endDate)+')';
                }else if (dataSearch.startDate != '') {
                    query2 = ' (dayOfBirth__c >= '+ String.escapeSingleQuotes(dataSearch.startDate)+')';
                }
                if (dataSearch.idCLass != '' && dataSearch.idCLass != '0000000000TOTAL') {
                    query3 = ' Class__c = \''+ String.escapeSingleQuotes(dataSearch.idCLass) +'\'';
                }
                if (dataSearch.sortName) {
                    query4 = ' ORDER BY lastName__c ';
                }
            }

            query = query + (query1 != null ?  query1 : '')
                        + (((query1 != null) && (query2 != null)) ? ' AND ' + query2 : (query2 != null ? query2 : ''))
                        + ((((query1 != null) || (query2 != null)) && (query3 != null)) ? ' AND ' + query3 : (query3 != null ? query3 : ''))
                        + (query4 != null ? query4 : '');
            System.debug('@@@' + query);
            return query;
        }
        
    }

    /**
	* getListClass
	* Lấy danh sách lớp
	* @param: 
	* @return: Map<String,String>
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    @AuraEnabled
    public static Map<String, String> getListClass() {
        Map<String, String> options = new Map<String, String>();
        for(Class__c item : [SELECT Id, nameClass__c FROM Class__c]) {
            options.put(item.Id, item.nameClass__c);
        }
        return options;
    }
}