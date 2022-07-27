@isTest
public class VF_ThemMoi_ControllerTest {
    @isTest
    private static void testMethodConstructor() {
        Test.startTest();
        VF_ThemMoi_Controller con = new VF_ThemMoi_Controller();
        Test.stopTest();
        Schema.SObjectType output = Schema.Student__c.getSObjectType();
        System.assertEquals(output, con.student.getSObjectType());
    }

    @isTest
    private static void testMethodSave() {
        VF_ThemMoi_Controller con = new VF_ThemMoi_Controller();
        con.student = createStudent('Học Sinh', 'checkSave', '10/10/2012', true, listClass[0].Id, 8, 8, 8);
        Test.startTest();
            con.save();
        Test.stopTest();
        Student__c check = [SELECT Id, lastName__c FROM Student__c WHERE lastName__c =:'checkSave'];
        System.assertEquals(check.lastName__c, con.student.lastName__c);
    }

    @isTest
    private static void testMethodSaveError() {
        VF_ThemMoi_Controller con = new VF_ThemMoi_Controller();
        con.student = createStudent('Học Sinh', 'checkSave', '10/10/2022', true, listClass[0].Id, 0, 0, 0);
        Test.startTest();
            con.save();
        Test.stopTest();
        List<Student__c> check = [SELECT Id, lastName__c FROM Student__c WHERE lastName__c =:'checkSave'];
        System.assert(check.size() == 0);
    }
    
    @isTest
    private static void testMethodGetListClass() {
        VF_ThemMoi_Controller con = new VF_ThemMoi_Controller();
        Test.startTest();
            SelectOption[] getList = con.getSelectCLass();
            con.setChooseClass(listClass[0].Id);
            String checkChooseClass = con.getChooseClass();
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Class__c];
        System.assertEquals(check, getList.size());
        System.assertEquals(listClass[0].Id, checkChooseClass);
    }

    private static List<Class__c> listClass;
    private static List<Student__c> listStudent;
    final static Integer NUM_CLASS = 5;
    final static Integer NUM_STUDENT = 5;
    static {
        listClass = new List<Class__c>();
        for (Integer i = 0; i < NUM_CLASS; i++) {
            listClass.add(createClass('Lớp '+ i));
        }
        insert listClass;

        listStudent = new List<Student__c>();
        listStudent.add(createStudent('Học Sinh', 'A', '10/10/2012', true, listClass[0].Id, 8, 8, 8));
        listStudent.add(createStudent('Học Sinh', 'B', '10/10/2012', true, listClass[0].Id, 8, 8, 8));
        listStudent.add(createStudent('Học Sinh', 'C', '10/10/2012', true, listClass[1].Id, 2, 2, 2));
        listStudent.add(createStudent('Học Sinh', 'D', '10/10/2012', true, listClass[2].Id, 3, 3, 3));
        listStudent.add(createStudent('Học Sinh', 'E', '10/10/2012', true, listClass[3].Id, 8, 8, 8));
        insert listStudent;
    }

    private static Student__c createStudent(String fName, String lName, String dayOfBirth, Boolean Sex, String idClass, Integer Diem1, Integer Diem2, Integer Diem3) {
        Student__c result = new Student__c();
        result.firstName__c = fName;
        result.lastName__c = lName;
        result.dayOfBirth__c = date.parse(dayOfBirth);
        result.Sex__c = Sex;
        result.Class__c = idClass;
        result.Diem1__c = Diem1;
        result.Diem2__c = Diem2;
        result.Diem3__c = Diem3;
        return result;
    }

    private static Class__c createClass(String nameClass) {
        Class__c result = new Class__c();
        result.nameClass__c = nameClass;
        result.numStu__c = 0;
        result.numPass__c = 0;
        result.numFail__c = 0;
        return result;
    }
}
