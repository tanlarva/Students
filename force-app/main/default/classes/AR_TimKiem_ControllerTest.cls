@isTest
public class AR_TimKiem_ControllerTest {

    @isTest
    private static void testMethodConstructor() {
        String error;
        try {
            AR_TimKiem_Controller con = new AR_TimKiem_Controller();
        } catch(Exception e) {
            error = e.getMessage();
        }
        System.assertEquals(null, error);
    }

    @isTest
    private static void testMethodSearchStudent() {
        AR_TimKiem_Controller con = new AR_TimKiem_Controller();
        Test.startTest();
            // Trường hợp đầy đủ
            List<Object> output1 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '2012-10-10', '2012-10-11', true));

            //Trường hợp thiếu tên
            List<Object> output2 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch(null, listClass[0].Id, '2012-10-10', '2012-10-11', true));
            
            //Trường hợp thiếu lớp
            List<Object> output3 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, null, '2012-10-10', '2012-10-11', true));
            
            //Trường hợp thiếu startdate
            List<Object> output4 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, null, '2012-10-11', true));

            //Trường hợp thiếu Endate
            List<Object> output5 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '2012-10-10', null, true));

            //Trường hợp không có gì
            List<Object> output6 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch());
        Test.stopTest();
        
        System.assertEquals(1, output1.size());
        System.assertEquals(2, output2.size());
        System.assertEquals(1, output3.size());
        System.assertEquals(1, output4.size());
        System.assertEquals(1, output5.size());
        System.assertEquals(5, output6.size());
    }

    @isTest
    private static void testMethodSearchStudentLWC() {
        AR_TimKiem_Controller con = new AR_TimKiem_Controller();
        Test.startTest();
            // Trường hợp đầy đủ
            List<Object> output1 = AR_TimKiem_Controller.searchStudentLWC(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '2012-10-10', '2012-10-11', true));

            //Trường hợp thiếu tên
            List<Object> output2 = AR_TimKiem_Controller.searchStudentLWC(con.dataSearch = new AR_TimKiem_Controller.dataSearch(null, listClass[0].Id, '2012-10-10', '2012-10-11', true));
            
            //Trường hợp thiếu lớp 
            List<Object> output3 = AR_TimKiem_Controller.searchStudent(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, null, '2012-10-10', '2012-10-11', true));

            //Trường hợp thiếu startdate
            List<Object> output4 = AR_TimKiem_Controller.searchStudentLWC(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '', '2012-10-11', true));

            //Trường hợp thiếu Endate
            List<Object> output5 = AR_TimKiem_Controller.searchStudentLWC(con.dataSearch = new AR_TimKiem_Controller.dataSearch(listStudent[0].lastName__c, listClass[0].Id, '2012-10-10', '', true));

            //Trường hợp không có gì
            List<Object> output6 = AR_TimKiem_Controller.searchStudentLWC(con.dataSearch = new AR_TimKiem_Controller.dataSearch());
        Test.stopTest();
        
        System.assertEquals(1, output1.size());
        System.assertEquals(2, output2.size());
        System.assertEquals(1, output3.size());
        System.assertEquals(1, output4.size());
        System.assertEquals(1, output5.size());
        System.assertEquals(5, output6.size());
    }

    @isTest
    private static void testMethodGetAllStudent() {
        Test.startTest();
            List<Student__c> check = AR_TimKiem_Controller.getAllStudent();
        Test.stopTest();
        System.assertEquals(listStudent.size(), check.size());
    }
    
    @isTest
    private static void testMethodDeleteStudent() {
        String error;
        List<Student__c> listError = new List<Student__c>();
        listError.add(student);
        List<Student__c> listDone = new List<Student__c>();
        listDone.add(listStudent[0]);
        listDone.add(listStudent[1]);
        Test.startTest();
            try {
                AR_TimKiem_Controller.deleteStudent(listError);
            } catch(Exception e) {
                error = (e.getMessage());
            }
            AR_TimKiem_Controller.deleteStudent(listDone);
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Student__c];
        System.assertEquals(3, check);
        System.assert(error != null);
    }

    @isTest
    private static void testMethodGetListClass() {
        Test.startTest();
            Map<String, String> output = AR_TimKiem_Controller.getListClass();
        Test.stopTest();
        System.assertEquals(listClass.size(), output.size());
    }

    private static List<Class__c> listClass;
    private static List<Student__c> listStudent;
    private static Student__c student;
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

        student = createStudent('Học Sinh', 'Test', '10/10/2012', true, listClass[0].Id, 8, 8, 8);
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
