/**
* ClassName: UpdatePoint
* ClassDetail: Chạy Batch cho Object Điểm
* @created: 2022/07/14 Phan Duy Tân
* @modified:
*/
public class UpdatePoint implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    //Các thay đổi được đưa vào đây
    public List<Diem__c> showJob;

    /**
	* execute
	* Hẹn giờ chạy batch
	* @param: SchedulableContex
	* @return: 
	* @created: 2022/07/14 Phan Duy Tân
	* @modified:
	**/ 
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdatePoint());
    }

    /**
	* start
	* Thực hiện QueryLocator trên Student__c
	* @param:
	* @return: Database.QueryLocator
	* @created: 2022/07/14 Phan Duy Tân
	* @modified:
	**/ 
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Diem1__c, Diem2__c, Diem3__c FROM Student__c');
    }

    /**
	* execute
	* Cập nhật lại Object điểm nếu có thay đổi, số lượng quy đinh trên schedulable
	* @param:
	* @return:
	* @created: 2022/07/14 Phan Duy Tân
	* @modified:
	**/ 
    public void execute(Database.BatchableContext BC, List<Student__c> scope) {
        List<Diem__c> listDiem = [SELECT Student__c, Subject__c, Diem__c FROM Diem__c WHERE Student__c IN: scope];
        List<Diem__c> updateDiem = new List<Diem__c>();
        Map<String, List<Diem__c>> mapDiem = getMergePoint(listDiem);
        for(Student__c student : scope){
            if (mapDiem.containsKey(student.Id)) {
                List<Diem__c> temp = mapDiem.get(student.Id);
                checkFullPoint(temp, updateDiem, student);
            } else {
                newPoint(updateDiem, student);
            }
        }

        if (showJob != null){
            for(Diem__c x : updateDiem){
                showJob.add(x);
            }
        } else {
            showJob = updateDiem;
        }

        upsert updateDiem;
    }

    /**
	* finish
	* Show những thay đổi sai khi kết thúc batch
	* @param: 
	* @return:
	* @created: 2022/07/14 Phan Duy Tân
	* @modified:
	**/ 
    public void finish(Database.BatchableContext BC) {
        System.debug('Change data: ' + showJob);
    }

    /**
	* getMergePoint
	* Map lại Điểm theo từng học sinh
	* @param: List<Diem__c>
	* @return: Map<String, List<Diem__c>>
	* @created: 2022/07/14 Phan Duy Tân
	* @modified:
	**/  
    public Map<String, List<Diem__c>> getMergePoint(List<Diem__c> listPoint) {
        Map<String, List<Diem__c>> listMPoint = new Map<String, List<Diem__c>>();
        if (listPoint != null) {
            for(Diem__c diem : listPoint) {
                if (listMPoint.containsKey(diem.Student__c)) {
                    listMPoint.get(diem.Student__c).add(diem);
                } else {
                    List<Diem__c> addPoint = new List<Diem__c>();
                    addPoint.add(diem);
                    listMPoint.put(diem.Student__c, addPoint);
                }
            }
            return listMPoint;
        } else {
            return null;
        }
    }

    /**
	* newPoint
	* Nếu xóa 1 điểm thì tự thêm mới
	* @param: List<Diem__c>, Student__c
	* @return:
	* @created: 2022/07/15 Phan Duy Tân
	* @modified:
	**/ 
    public void newPoint(List<Diem__c> listDiem, Student__c student) {
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

    /**
	* checkFullPoint
	* Nếu xóa 1 điểm thì tự thêm mới không thì so sanhs thay đổi
	* @param: List<Diem__c>, List<Diem__c>, Student__c
	* @return:
	* @created: 2022/07/15 Phan Duy Tân
	* @modified:
	**/  
    public void checkFullPoint(List<Diem__c> inMap, List<Diem__c> updateDiem, Student__c student) {
        if (inMap.size() == 3) {
            for(Diem__c x : inMap){
                if (x.Subject__c == 'Hóa' && x.Diem__c != student.Diem1__c) {
                    x.Diem__c = student.Diem1__c;
                    updateDiem.add(x);
                } else if (x.Subject__c == 'Toán' && x.Diem__c != student.Diem2__c) {
                    x.Diem__c = student.Diem2__c;
                    updateDiem.add(x);
                } else if (x.Subject__c == 'Lý' && x.Diem__c != student.Diem3__c) {
                    x.Diem__c = student.Diem3__c;
                    updateDiem.add(x);
                }
            }
        } else {
            Map<String, Diem__c> temp = new Map<String, Diem__c>();
            List<Diem__c> pointNow = new List<Diem__c>();
            newPoint(pointNow, student);
            for (Diem__c x : inMap) {
                temp.put(x.Subject__c, x);
            }
            for(Diem__c x : pointNow){
                if (!temp.containsKey(x.Subject__c)) {
                    temp.put(x.Subject__c, x);
                    updateDiem.add(x);
                } else {
                    if (temp.get(x.Subject__c).Diem__c != x.Diem__c){
                        updateDiem.add(x);
                    }
                }
            }
        }
    }
}
