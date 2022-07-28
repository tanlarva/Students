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
            con.getResults();
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
            con.sId = '';
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

    @isTest
    private static void testMethodUpdateStudent() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        con.sId = listStudent[3].Id;
        Test.startTest();
            Pagereference check = con.updateStudent();
        Test.stopTest();
        String output = '/apex/vf_capnhat?id='+listStudent[3].Id;
        System.assertEquals(output, check.getUrl());
    }

    @isTest
    private static void testMethodDetailStudent() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        con.sId = listStudent[3].Id;
        Test.startTest();
            Pagereference check = con.detailStudent();
        Test.stopTest();
        String output = '/apex/vf_chitiet?id='+listStudent[3].Id;
        System.assertEquals(output, check.getUrl());
    }
    
    @isTest
    private static void testMethodNewStudent() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
            Pagereference check = con.newStudent();
        Test.stopTest();
        String output = '/apex/vf_themmoi';
        System.assertEquals(output, check.getUrl());
    }

    @isTest
    private static void testMethodDeleteMNStudent() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        con.getResults();
        con.result[0].isSelected = true;
        con.result[1].isSelected = true;
        Test.startTest();
            con.deleteMNStudent();
            con.result = null;
            con.deleteMNStudent();
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Student__c];
        System.assertEquals(3, check);
    }

    @isTest
    private static void testMethodGetPageNumber() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        con.getResults();
        Test.startTest();
            String check = con.getPageNumber();
        Test.stopTest();
        String output = '1';
        System.assertEquals(output, check);
    }

    @isTest
    private static void testMethodCreateQuery() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
            // Trường hợp đầy đủ
            String query1 = con.createQuery(con.dataSearch = new VF_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '2012-10-10', '2012-10-11', true));

            //Trường hợp thiếu tên
            String query2 = con.createQuery(con.dataSearch = new VF_TimKiem_Controller.dataSearch(null, listClass[0].Id, '2012-10-10', '2012-10-11', true));
            
            //Trường hợp thiếu lớp
            String query3 = con.createQuery(con.dataSearch = new VF_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, null, '2012-10-10', '2012-10-11', true));

            //Trường hợp thiếu startdate
            String query4 = con.createQuery(con.dataSearch = new VF_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, null, '2012-10-11', true));

            //Trường hợp thiếu endate
            String query5 = con.createQuery(con.dataSearch = new VF_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '2012-10-10', null, true));

            //Trường hợp không có gì
            String query6 = con.createQuery(con.dataSearch = new VF_TimKiem_Controller.dataSearch(null, null, null, null, false));
        Test.stopTest();

        List<Object> output1 = Database.query(query1);
        List<Object> output2 = Database.query(query2);
        List<Object> output3 = Database.query(query3);
        List<Object> output4 = Database.query(query4);
        List<Object> output5 = Database.query(query5);
        List<Object> output6 = Database.query(query6);
        
        System.assertEquals(1, output1.size());
        System.assertEquals(2, output2.size());
        System.assertEquals(1, output3.size());
        System.assertEquals(1, output4.size());
        System.assertEquals(1, output5.size());
        System.assertEquals(5, output6.size());
    }

    @isTest
    private static void testMethodUpdateStu() {
        VF_TimKiem_Controller con = new VF_TimKiem_Controller();
        Test.startTest();
            PageReference check = con.updateStu(listStudent[0].Id);
        Test.stopTest();
        System.assertEquals('/apex/vf_capnhat?id='+listStudent[0].Id, check.getUrl());
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
