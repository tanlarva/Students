public with sharing class VF_TimKiem_Controller {
    private static final Integer INT_LIMIT_QUERY = 50000;
    String chooseCLass;
    public dataSearch dataSearch {get; set; }
    
    List<studentDTO> result;
    public VF_TimKiem_Controller() {
        dataSearch = new dataSearch();
    }


    //Tạo selection cho Lớp
    public SelectOption[] getSelectCLass(){
        SelectOption[] options = new SelectOption[]{};
        for(Class__c oneClass : [SELECT Id, nameClass__c FROM Class__c]){
            options.add(new SelectOption(
                            oneClass.Id, oneClass.nameClass__c));
        }
        return options;
    }
    public String getChooseCLass(){
        return chooseCLass;
    }
    public void setChooseCLass(String value){
        this.chooseCLass = value;
        this.dataSearch.idCLass = value;
    }

    public List<Student__c> search(){
        return null;
    }

    

    public boolean deleteStu(){
        return false;
    }

    class dataSearch{
        public Student__c student {get; set;}
        public String nameStudent {get; set;}
        public String idCLass {get; set;}
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        public dataSearch(){
            student = new Student__c();
        }
    }
    class studentDTO{
        public Student__c student {get; set;}
        public boolean isSelected {get; set;}
    }
}
