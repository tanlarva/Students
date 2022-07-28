@isTest
public class UpdatePointBatchTest {
    
    @isTest
    private static void testMethodExcute() {
        List<Diem__c> listDel = [SELECT Diem__c FROM Diem__c];
        System.debug('listDel: ' + listDel);
        delete listDel;
        Test.startTest();
            Database.executeBatch(new UpdatePoint());
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Diem__c];
        System.assertEquals(15, check);
    }
    
    @isTest
    private static void testMethodExcuteButDeleteSome() {
        List<Diem__c> listDel = [SELECT Id FROM Diem__c];
        System.debug('listDel: ' + listDel);
        delete listDel[3];
        Test.startTest();
            Database.executeBatch(new UpdatePoint());
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Diem__c];
        System.assertEquals(15, check);
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

        Database.executeBatch(new UpdatePoint());
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
