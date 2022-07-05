/**
* ClassName: AR_ThemMoi_Controller
* ClassDetail: Thêm mới đối tượng
* @created: 2022/07/04 Phan Duy Tân
* @modified:
*/
public with sharing class AR_ThemMoi_Controller {

    @AuraEnabled
    public static void newStudent(Student__c student){
        try {
            insert student;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
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

    public AR_ThemMoi_Controller() {

    }

    
}
