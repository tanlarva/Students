@isTest
public class VF_TimKiem_ControllerTest {

    @isTest
    private static void methodTestConstructor() {
        Test.startTest();
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    private static void methodTestGetResults() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
        List<Object> getList = con.getResults();
        Test.stopTest();
        System.assertEquals(3, getList.size());
        System.assertEquals(listStudent.size(), con.totalSearch);
    }

    @isTest
    private static void testMethodGetListClass() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
            SelectOption[] getList = con.getSelectCLass();
            con.setChooseClass(listClass[0].Id);
            String checkChooseClass = con.getChooseClass();
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Class__c];
        System.assertEquals(check, getList.size());
        System.assertEquals(listClass[0].Id, checkChooseClass);
    }

    @isTest
    private static void testMethodDeleteStudent() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
            con.sId = listStudent[0].Id;
            con.deleteStudent();
            List<Object> checkStudent = con.getResults();
        Test.stopTest();
        Integer output = [SELECT COUNT() FROM Student__c];
        System.assertEquals(output, con.totalSearch);
    }

    @isTest
    private static void testMethodSearchStudent() {
        ApexPages.currentPage().getParameters().put('nameStu','B');
        ApexPages.currentPage().getParameters().put('strDate', '2012-10-10');
        ApexPages.currentPage().getParameters().put('endDate','2012-10-11');
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
            con.searchStudent();
        Test.stopTest();
        System.assertEquals(1, con.totalSearch);
    }
    
    @isTest
    private static void testMethodPage() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        List<Object> getList = con.getResults();
        Test.startTest();
            con.firstPage();
            Integer firstPage = con.pageCurrent;
            con.lastPage();
            Integer lastPage = con.pageCurrent;
            con.prePage();
            Integer prePage = con.pageCurrent;
            con.nextPage();
            Integer nextPage = con.pageCurrent;
        Test.stopTest();
        System.assertEquals(1, firstPage);
        System.assertEquals(con.totalPage, lastPage);
        System.assertEquals(con.totalPage -1, prePage);
        System.assertEquals(con.totalPage, nextPage);

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
