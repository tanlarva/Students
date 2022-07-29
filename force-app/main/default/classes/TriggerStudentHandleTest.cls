/*
 * ClassName: TriggerStudentHandleTest
 * ClassDetail: Test Class cho TriggerStudentHandle
 * @create: 2022/07/28 Phan Duy Tân
 * @modify:
 */
@isTest
public class TriggerStudentHandleTest {
    /*
     * testMethodConstructor
     * Dùng để test cho method constructor
     * @create: 2022/07/28 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodConstructor() {
        String error;
        Test.startTest();
            try {
                TriggerStudentHandle con = new TriggerStudentHandle();
            } catch(Exception e) {
                error = (e.getMessage());
            }
        Test.stopTest();
        System.debug('Error: ' + error);
        System.assertEquals(null, error);
    }

    /*
     * testMethodOnBeforeInsert
     * Dùng để test cho method onBeforeInsert()
     * @create: 2022/07/28 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodOnBeforeInsert() {
        String error;
        Test.startTest();
            try {
                TriggerStudentHandle.onBeforeInsert(listStudentError);
            } catch(Exception e) {
                error = (e.getMessage());
            }
        Test.stopTest();
        System.debug('Error: ' + error);
        System.assertEquals(null, error);
    }

    /*
     * testMethodOnBeforeUpdate
     * Dùng để test cho method onBeforeUpdate()
     * @create: 2022/07/28 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodOnBeforeUpdate() {
        String error;
        insert listStudent;
        List<Student__c> getData = [SELECT Id, firstName__c, Class__c, lastName__c, Sex__c, dayOfBirth__c, Diem1__c,Diem2__c, Diem3__c FROM Student__c WHERE lastName__c = 'Test'];
        //Không ngày sinh
        getData[0].dayOfBirth__c = null;
        //Ngày sinh không hợp lệ
        getData[1].dayOfBirth__c = date.parse('10/10/2022');
        //Không có Điểm 1, Điêm 2 < 0
        getData[2].Diem1__c = null;
        getData[2].Diem2__c = -8;
        //Không có Điểm 2, Điểm 3 < 0
        getData[3].Diem2__c = null;
        getData[3].Diem3__c = -8;
        //Không có Điểm 3, Điểm 1 < 0
        getData[4].Diem3__c = null;
        getData[4].Diem1__c = -8;

        Test.startTest();
            try {
                TriggerStudentHandle.onBeforeUpdate(getData);
            } catch(Exception e) {
                error = (e.getMessage());
            }
        Test.stopTest();
        System.debug('Error: ' + error);
        System.assertEquals(null, error);
    }

    /*
     * testMethodOnAfterInsert
     * Dùng để test cho method onAfterInsert()
     * @create: 2022/07/28 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodOnAfterInsert() {

        Test.startTest();
            insert listStudent;
        Test.stopTest();

        Class__c Lop_0 = [SELECT nameClass__c, numStu__c, numFail__c, numPass__c FROM Class__c WHERE Id =: listClass[0].Id];
        List<Student__c> output = [SELECT Id, Name, GPA__c, XepLoai__c FROM Student__c WHERE Id IN : listStudent];
        List<String> check = new List<String>();
        for (Student__c item : output) {
            check.add(item.XepLoai__c);
        }
        System.assertEquals(3, Lop_0.numStu__c);
        System.assertEquals(2, Lop_0.numPass__c);
        System.assertEquals(1, Lop_0.numFail__c);
        System.assertEquals(checkXepLoai, check);
    }

    /*
     * testMethodOnAfterDelete
     * Dùng để test cho method onAfterDelete()
     * @create: 2022/07/28 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodOnAfterDelete() {
        Test.startTest();
            insert listStudent;
            delete listStudent[0]; //xóa học sinh Lớp 0 Giỏi
        Test.stopTest();
        Class__c Lop_0 = [SELECT nameClass__c, numStu__c, numFail__c, numPass__c FROM Class__c WHERE Id =: listClass[0].Id];
        System.assertEquals(2, Lop_0.numStu__c);
        System.assertEquals(1, Lop_0.numPass__c);
        System.assertEquals(1, Lop_0.numFail__c);
    }

    /*
     * testMethodOnAfterUpdate
     * Dùng để test cho method onAfterUpdate()
     * @create: 2022/07/28 Phan Duy Tân
     * @modify:
     */
    @isTest
    private static void testMethodOnAfterUpdate() {
        Test.startTest();
            insert listStudent;
            System.debug('listStudent[3]: ' + [SELECT Id, Name, GPA__c, XepLoai__c, Status__c FROM Student__c WHERE Id =: listStudent[3].Id]);

            listStudent[2].Diem1__c = 8;
            listStudent[2].Diem2__c = 8;
            listStudent[2].Diem3__c = 8;
            listStudent[3].Diem1__c = 1;
            listStudent[3].Diem2__c = 1;
            listStudent[3].Diem3__c = 1;

            listStudent[0].Class__c = listClass[1].Id;
            update listStudent; //Giỏi học sinh Lớp 0 Giỏi sang lớp 1 và chuyển hs Lớp 0 yếu rớt thành giỏi đậu và Học sinh lớp 1 Trung bình thành yếu;
        Test.stopTest();
        Class__c Lop_0 = [SELECT nameClass__c, numStu__c, numFail__c, numPass__c FROM Class__c WHERE Id =: listClass[0].Id];
        Class__c Lop_1 = [SELECT nameClass__c, numStu__c, numFail__c, numPass__c FROM Class__c WHERE Id =: listClass[1].Id];
        System.debug('Lop_0: ' + Lop_0);
        System.debug('Lop_1: ' + Lop_1);
        System.debug('listStudent[2]: ' + [SELECT Id, Name, GPA__c, XepLoai__c, Status__c FROM Student__c WHERE Id =: listStudent[2].Id]);
        System.assertEquals(2, Lop_0.numStu__c);
        System.assertEquals(2, Lop_0.numPass__c);
        System.assertEquals(0, Lop_0.numFail__c);
        System.assertEquals(2, Lop_1.numStu__c);
        System.assertEquals(1, Lop_1.numPass__c);
        System.assertEquals(1, Lop_1.numFail__c);
    }

    private static List<Class__c> listClass; //Danh sách lớp đã tạo
    private static List<Student__c> listStudent;    //Danh sách học sinh đã tạo
    private static List<Student__c> listStudentError;   //Danh sách học sinh dữ liệu lỗi
    private static List<String> checkXepLoai;   //Danh sách xếp loại của listStudent
    private static Student__c student;  //Học sinh đúng
    private static Student__c studentErorr; //Học sinh lỗi
    final static Integer NUM_CLASS = 5; //Số lớp được tạo
    final static Integer NUM_STUDENT = 5;   //Số học sinh được tạo
    //DataTest
    static {
        listClass = new List<Class__c>();
        for (Integer i = 0; i < NUM_CLASS; i++) {
            listClass.add(createClass('Lớp '+ i));
        }
        insert listClass;

        listStudent = new List<Student__c>();
        //Lớp 0 Đậu Giỏi
        listStudent.add(createStudent('Học Sinh', 'Test', '10/30/2012', true, listClass[0].Id, 9, 9, 9));
        //Lớp 0 Đậu Khá
        listStudent.add(createStudent('Học Sinh', 'Test', '10/10/2012', true, listClass[0].Id, 7, 7, 7));
        //Lớp 0 Rớt Yếu
        listStudent.add(createStudent('Học Sinh', 'Test', '10/10/2012', true, listClass[0].Id, 1, 1, 1));
        //Lớp 1 Đậu Trung Bình
        listStudent.add(createStudent('Học Sinh', 'Test', '10/10/2012', true, listClass[1].Id, 6, 6, 6));
        //Lớp 2 Đậu Giỏi
        listStudent.add(createStudent('Học Sinh', 'Test', '10/10/2012', true, listClass[2].Id, 8, 8, 8));

        listStudentError = new List<Student__c>();
        //Không có ngày sinnh
        listStudentError.add(createStudent('Học Sinh', 'A', null, true, listClass[0].Id, 8, 8, 8));
        //Ngày sinh không hợp lệ
        listStudentError.add(createStudent('Học Sinh', 'B', '10/10/2022', true, listClass[0].Id, 8, 8, 8));
        //Không có Điểm 1, Điêm 2 < 0
        listStudentError.add(createStudent('Học Sinh', 'C', '10/10/2012', true, listClass[1].Id, null, -8, 8));
        //Không có Điểm 2, Điểm 3 < 0
        listStudentError.add(createStudent('Học Sinh', 'D', '10/10/2012', true, listClass[2].Id, 8, null, -8));
        //Không có Điểm 3, Điểm 1 < 0
        listStudentError.add(createStudent('Học Sinh', 'E', '10/10/2012', true, listClass[3].Id, -8, 8, null));

        checkXepLoai = new List<String>();
        checkXepLoai.add('Giỏi');
        checkXepLoai.add('Khá');
        checkXepLoai.add('Yếu');
        checkXepLoai.add('Trung Bình');
        checkXepLoai.add('Giỏi');

        student = createStudent('Học Sinh', 'Test', '10/10/2012', true, listClass[0].Id, 8, 8, 8);
        studentErorr = createStudent('Học Sinh', 'Test', '10/10/2022', true, listClass[0].Id, 8, 8, 8);
    }
    //Tạo học sinh
    private static Student__c createStudent(String fName, String lName, String dayOfBirth, Boolean Sex, String idClass, Integer Diem1, Integer Diem2, Integer Diem3) {
        Student__c result = new Student__c();
        result.firstName__c = fName;
        result.lastName__c = lName;
        result.dayOfBirth__c = (!string.isBlank(dayOfBirth)) ? date.parse(dayOfBirth) : null ;
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
}
