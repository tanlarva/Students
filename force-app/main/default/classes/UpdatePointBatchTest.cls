/*
 * ClassName: UpdatePointBatchTest
 * ClassDetail: Test Class cho UpdatePoint
 * @create: 2022/07/29 Phan Duy Tân
 * @modify:
 */
@isTest
public class UpdatePointBatchTest {
    /*
     * testMethodExcute
     * Dùng để test cho method execute()
     * @create: 2022/07/29 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodExcute() {
        Test.startTest();
            Database.executeBatch(new UpdatePoint());
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Diem__c];
        System.assertEquals(15, check);
    }

    /*
     * testMethodExcuteButDeleteSome
     * Dùng để test cho method execute() khi mà dữ liệu mất một phần
     * @create: 2022/07/29 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodExcuteButDeleteSome() {
        insert listPoint;
        System.debug('listPoint: ' + listPoint);
        delete listPoint[3];
        delete listPoint[2];
        delete listPoint[7];
        Test.startTest();
            Database.executeBatch(new UpdatePoint());
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Diem__c];
        System.assertEquals(15, check);
    }

    /*
     * testMethodExcuteButUpdateSome
     * Dùng để test cho method execute() khi dữ liệu bị thay đổi
     * @create: 2022/07/29 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodExcuteButUpdateSome() {
        insert listPoint;
        System.debug('listPoint: ' + listPoint);
        listPoint[0].Diem__c = 1;
        listPoint[1].Diem__c = 1;
        listPoint[2].Diem__c = 1;
        update listPoint;
        Test.startTest();
            Database.executeBatch(new UpdatePoint());
        Test.stopTest();
        Integer check = [SELECT COUNT() FROM Diem__c];
        List<Diem__c> getDiem = [SELECT Diem__c FROM Diem__c LIMIT 3];
        System.assertEquals(getDiem[0].Diem__c, 8);
        System.assertEquals(15, check);
    }

    /*
     * testMethodSchedulable
     * Dùng để test cho method schedule.execute -- đặt lịch chạy batch
     * @create: 2022/07/29 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodSchedulable() {
        Test.startTest();
            final String TIME_TEST = '0 0 0 30 9 ? 2022';   //Batch sẽ chạy vào ngày 30/09/2022 00:00:00
            String jobId = System.schedule('TestClassBatch', TIME_TEST, new UpdatePoint());
           
        Test.stopTest();
         //láy thông tin CronTrigger API object 
         CronTrigger check = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
         //Kiểm tra the expressions
         System.assertEquals(TIME_TEST, check.CronExpression); 
         //Kiểm tra batch đã chạy chưa
         System.assertEquals(0, check.TimesTriggered); 
         //Kiểm tra thời gian bắt đầu chạy 
         System.assertEquals('2022-09-30 00:00:00', String.valueOf(check.NextFireTime));  
    }

    private static List<Class__c> listClass;    //Danh sách lớp đã tạo
    private static List<Student__c> listStudent;    //Danh sách học sinh đã tạo
    private static List<Diem__c> listPoint; //Danh sách điểm của học sinh
    final static Integer NUM_CLASS = 5; //Số lớp được tạo
    final static Integer NUM_STUDENT = 5;   //Số học sinh được tạo
    //Data Test
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

        listPoint = createPoint(listStudent);
    }
    //Tạo học sinh
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
    //Tạo lớp
    private static Class__c createClass(String nameClass) {
        Class__c result = new Class__c();
        result.nameClass__c = nameClass;
        result.numStu__c = 0;
        result.numPass__c = 0;
        result.numFail__c = 0;
        return result;
    }
    //Tạo điểm
    private static List<Diem__c> createPoint(List<Student__c> students) {
        List<Diem__c> listDiem = new List<Diem__c>();

        for (Student__c student : students) {
            Diem__c diemHoa = new Diem__c();
            diemHoa.Student__c = student.Id;
            diemHoa.Subject__c = 'Hóa';
            diemHoa.Diem__c = student.Diem1__c;
            Diem__c diemToan = new Diem__c();
            diemToan.Student__c = student.Id;
            diemToan.Subject__c = 'Toán';
            diemToan.Diem__c = student.Diem2__c;
            Diem__c diemLy = new Diem__c();
            diemLy.Student__c = student.Id;
            diemLy.Subject__c = 'Lý';
            diemLy.Diem__c = student.Diem3__c;
            listDiem.add(diemHoa);
            listDiem.add(diemToan);
            listDiem.add(diemLy);
        }

        return listDiem;
    }
}
