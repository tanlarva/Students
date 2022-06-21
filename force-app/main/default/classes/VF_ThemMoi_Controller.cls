public class VF_ThemMoi_Controller {
    public Student__c student {get; private set;}
    String chooseCLass;

    public VF_ThemMoi_Controller() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        student = (id == null) ? new Student__c() : [SELECT lastName__c, firstName__c, Sex__c, Class__c, Status__c, Diem3__c, Diem2__c, Diem1__c, GPA__c FROM Student__c WHERE Name  = :id];
    }

    public Pagereference save(){
        try {
            upsert(student);
        } catch (System.DmlException ex){
            ApexPages.addMessages(ex);
            return null;
        }
        PageReference redirectSuccess = new ApexPages.StandardController(Student).view();
        return (redirectSuccess);
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
        this.student.Class__c = value;
    }

}
