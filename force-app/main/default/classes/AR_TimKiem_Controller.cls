/**
 * ClassName: AR_TimKiem_Controller
 * ClassDetail: Hỗ trợ cho việc tìm kiếm
 * @Create: 2022/07/06 Phan Duy Tân
 * @Modify: 
 */
public with sharing class AR_TimKiem_Controller {



    public AR_TimKiem_Controller() {}

    /**
    * ClassName: dataSearch
    * ClassDetail: chứa dữ liệu search
    * @created: 2022/07/06 Phan Duy Tân
    * @modified:
    */
    class dataSearch{
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
        public dataSearch(){}
        public dataSearch(String nameStudent, String idCLass, String startDate, String endDate, Boolean sortName){
            this.nameStudent = nameStudent;
            this.idCLass = idCLass;
            this.startDate = startDate;
            this.endDate = endDate;
            this.sortName = sortName;
        }
        public void setStartDate(String day){
            this.startDate = day;
        }
        public void setEndDate(String day){
            this.endDate = day;
        }
        
    }

    @AuraEnabled
    public static Map<String,String> getListClass(){
        Map<String,String> options = new Map<String,String>();
        for(Class__c item : [SELECT Id, nameClass__c FROM Class__c]){
            options.put(item.Id, item.nameClass__c);
        }
        return options;
    }
}
