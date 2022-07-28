@isTest
public class AR_Student_ControllerTest {

    @isTest
    private static void testMethodConstructor() {
        String error;
        try {
            AR_Student_Controller con = new AR_Student_Controller();
        } catch(Exception e) {
            error = e.getMessage();
        }
        System.assertEquals(null, error);
    }

    @isTest
    private static void testMethodCreateStudent() {
        String error;
        Test.startTest();
            try {
                AR_Student_Controller.createStudent(studentErorr);
            } catch(Exception e) {
                error = (e.getMessage());
            }
            AR_Student_Controller.createStudent(student);
        Test.stopTest();
        Integer output = [SELECT COUNT() FROM Student__c WHERE Id=: student.Id];
        System.assertEquals(1, output);
        System.assert(error != null);
    }

    @isTest
    private static void testMethodUpdateStudent() {
        String output = 'Check';
        String error;
        Test.startTest();
            AR_Student_Controller.createStudent(student);
            student.lastName__c = 'Check'; 
            AR_Student_Controller.updateStudent(student);
            try {
                student.Diem1__c = null;
                AR_Student_Controller.updateStudent(student);
            } catch(Exception e) {
                error = (e.getMessage());
            }
        Test.stopTest();
        Student__c check = [SELECT Id, lastName__c FROM Student__c WHERE Id=: student.Id];
        System.assertEquals(check.lastName__c, output);
        System.assert(error != null);
    }

    @isTest
    private static void testMethodGetDataStudent() {
        Test.startTest();
            Student__c output1 = AR_Student_Controller.getDataStudent(student.Id);
            Student__c output2 = AR_Student_Controller.getDataStudent(listStudent[0].Id);
        Test.stopTest();
        System.assert(output1 == null);
        System.assert(output2 != null);
    }

    @isTest
    private static void testMethodGetListClass() {
        Test.startTest();
            Map<String, String> output = AR_Student_Controller.getListClass();
        Test.stopTest();
        System.assertEquals(listClass.size(), output.size());
    }

    @isTest
    private static void testMethodGetListClassLWC() {
        Test.startTest();
            List<Class__c> output = AR_Student_Controller.getListClassLWC();
        Test.stopTest();
        System.assertEquals(listClass.size(), output.size());
    }


    private static List<Class__c> listClass;
    private static List<Student__c> listStudent;
    private static Student__c student;
    private static Student__c studentErorr;
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
        studentErorr = createStudent('Học Sinh', 'Test', '10/10/2022', true, listClass[0].Id, 8, 8, 8);
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
