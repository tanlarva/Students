/**
* ClassName: VF_TimKiem_Controller
* ClassDetail: Tìm kiếm đối tượng
* @created: 2022/06/21 Phan Duy Tân
* @modified:
*/
public with sharing class VF_TimKiem_Controller {
    public String sId {get; set;}
    public Boolean sSort {get; set;}
    private static final Integer INT_LIMIT_QUERY = 50000;
    private Integer pageCurrent = 1;
    private Integer totalPage = 0;
    private final Integer pageSize = 3;
    public Integer totalSearch {get; set; }
    String chooseCLass;
    public dataSearch dataSearch {get; set; }     
    private List<studentDTO> result {get; set; }

    /**
	* Contructor
	* init
	* @param: 
	* @return: 
	* @created: 2022/06/21 Phan Duy Tân
	* @modified:
	**/
    public VF_TimKiem_Controller() {
        dataSearch = new dataSearch();
    }

    /**
	* getResults
	* Get list học sinh
	* @param: 
	* @return: List<studentDTO>
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
    public List<studentDTO> getResults(){
        List<studentDTO> results = new List<studentDTO>();
        if(this.result==null){
            List<studentDTO> data = new List<studentDTO>();
            for(Student__c oneStudent : [SELECT Id, firstName__c, lastName__c, Sex__c, dayOfBirth__c, Diem1__c,Diem2__c, Diem3__c, GPA__c, Status__c FROM Student__c]){
                data.add(new StudentDTO(
                                false, oneStudent
                ));
            }
            this.result = data;
            this.totalSearch = data.size();
            this.totalPage = (this.totalSearch<3)? 1 : 
                                                    ((math.mod(this.totalSearch,pageSize)==0) ? this.totalSearch/pageSize : 
                                                                                                (this.totalSearch/pageSize+1));
            for(Integer i  = ((pageCurrent-1)*pageSize);  i < (pageCurrent==totalPage? totalSearch : pageSize*pageCurrent ); i++){
                results.add(this.result[i]);
            }
        }else{
            for(Integer i  = ((pageCurrent-1)*pageSize);  i < (pageCurrent==totalPage? totalSearch : pageSize*pageCurrent ); i++){
                results.add(this.result[i]);
            }
        }
        return results;
    }

     /**
	* getSelectClass
	* Tạo selectoption cho Lớp
	* @param: 
	* @return: 
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
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
        this.dataSearch.idCLass = value;
    }

     /**
	* search
	* Tìm kiếm
	* @param: 
	* @return: 
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
    public void searchStudent(){
        dataSearch.nameStudent = ApexPages.currentPage().getParameters().get('nameStu');
        dataSearch.startDate = null;
        dataSearch.endDate = null;
        if((ApexPages.currentPage().getParameters().get('strDate'))!=''){
            dataSearch.setStartDate(ApexPages.currentPage().getParameters().get('strDate'));
        }
        if((ApexPages.currentPage().getParameters().get('endDate'))!=''){
            dataSearch.setEndDate(ApexPages.currentPage().getParameters().get('endDate'));
        }
        String query = this.createQuery(this.dataSearch);
    
        List<Student__c> temp = Database.query(query);
        List<studentDTO> results = new List<studentDTO>();
        for(Student__c oneStudent : temp){
            results.add(new StudentDTO(
                        false, oneStudent
            ));
        }
    
        this.result = results;
        this.totalSearch = results.size();
        this.totalPage = (this.totalSearch<3)?1:((math.mod(this.totalSearch,pageSize)==0) ? this.totalSearch/pageSize : (this.totalSearch/pageSize) +1);
    }

     /**
	* deleteStu
	* Xóa đối tượng đã đánh dấu
	* @param: 
	* @return: 
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
    public void deleteStudent(){
        Student__c del = new Student__c();
        del = [SELECT Id FROM Student__c WHERE Id =:sId];
        delete del;
        this.result = null;   
    }
     /**
	* updateStu
	* Cập nhật đối tượng
	* @param: 
	* @return: Pagereference 
	* @created: 2022/06/23 Phan Duy Tân
	* @modified:
	**/
    public Pagereference updateStudent(){
        Pagereference page = Page.VF_CapNhat;
        page.getParameters().put('id',sId);
        return page;
    }
     /**
	* detailStu
	* Chi tiết đối tượng
	* @param: 
	* @return: Pagereference 
	* @created: 2022/06/23 Phan Duy Tân
	* @modified:
	**/
    public Pagereference detailStudent(){
        Pagereference page = Page.VF_ChiTiet;
        page.getParameters().put('id',sId);
        return page;
    }
    /**
	* deleteMNStu
	* Xóa nhiều đối tượng
	* @param: 
	* @return: Pagereference 
	* @created: 2022/06/23 Phan Duy Tân
	* @modified:
	**/
    public void deleteMNStudent(){
        System.Savepoint sp = Database.setSavepoint();
        try{
            List<Student__c> del = new List<Student__c>();
            for(studentDTO x: this.result ){
                if(x.isSelected){
                    del.add(x.student);
                }
            }
            delete del;
        }catch(Exception e){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Unable to delete products: '+e.getMessage(), e.getMessage()));			
        }
        this.result = null;
    }

     /**
	* newStu
	* Thêm mới đối tượng
	* @param: 
	* @return: Pagereference 
	* @created: 2022/06/23 Phan Duy Tân
	* @modified:
	**/
    public Pagereference newStudent(){
        Pagereference page = Page.VF_ThemMoi;
        return page;
    }

    /**
	* firstPage, lastPage, prePage, nextPage
	* Phân trang
	* @param: 
	* @return: 
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
    public void firstPage(){
        pageCurrent =1;
    }
    public void lastPage(){
        pageCurrent = totalPage;
    }
    public void prePage(){
        if(pageCurrent>1){
            pageCurrent--;
        }
    }
    public void nextPage(){
        if(pageCurrent<totalPage){
            pageCurrent++;
        }
    }

    /**
	* getPageNumber
	* vị trí trang hiện tại
	* @param: 
	* @return: String
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
    public String getPageNumber(){
        return String.valueOf(pageCurrent);
    }

    /**
	* createQuery
	* Tạo truy vấn
	* @param: 
	* @return: String 
	* @created: 2022/06/22 Phan Duy Tân
	* @modified:
	**/
    public String createQuery(dataSearch dataSearch){
        String query = 'SELECT Class__c, dayOfBirth__c,Diem1__c,Diem3__c,Diem2__c,firstName__c,GPA__c,Id,lastName__c,Sex__c,Status__c, Name FROM Student__c WHERE ';
        String query1, query2, query3, query4;
        if(dataSearch != null){
            if(dataSearch.nameStudent != null){
                query1 = ' ((firstName__c LIKE \'%' + String.escapeSingleQuotes(dataSearch.nameStudent) + '%\') OR (lastName__c LIKE \'%' + String.escapeSingleQuotes(dataSearch.nameStudent) + '%\'))';
            }
            if((dataSearch.startDate!=null)&&(dataSearch.endDate!=null)){
                query2 = ' (dayOfBirth__c > '+ String.escapeSingleQuotes(dataSearch.startDate) +' AND dayOfBirth__c < '+ String.escapeSingleQuotes(dataSearch.endDate) +')';
            }else if(dataSearch.endDate!=null){
                query2 = ' (dayOfBirth__c < '+ String.escapeSingleQuotes(dataSearch.endDate)+')';
            }else if(dataSearch.startDate!=null){
                query2 = ' (dayOfBirth__c > '+ String.escapeSingleQuotes(dataSearch.startDate)+')';
            }
            if(dataSearch.idCLass!=null){
                query3 = ' Class__c = \''+ String.escapeSingleQuotes(dataSearch.idCLass) +'\'';
            }
            if(dataSearch.sortName){
                query4 = ' ORDER BY lastName__c ';
            }
        }

        query = query + (query1 != null ?  query1 : '')
                      + (((query1 != null) && (query2 != null)) ? ' AND ' + query2 : (query2 != null ? query2 : ''))
                      + ((((query1 != null) || (query2 != null)) && (query3 != null)) ? ' AND ' + query3 : (query3 != null ? query3 : ''))
                      + (query4 != null ? query4 : '');
        System.debug('@@@'+ query);
        return query;
    }

    /**
	* updateStu
	* Cập nhật đối tượng
	* @param:  PageReference
	* @return: String 
	* @created: 2022/06/23 Phan Duy Tân
	* @modified:
	**/
    //Sự kiện ấn Cập nhật
    public PageReference updateStu(String id){
        PageReference go = Page.VF_CapNhat;
        go.getParameters().put('id',id);
        return go;
    }


    /**
    * ClassName: dataSearch
    * ClassDetail: chứa dữ liệu search
    * @created: 2022/06/21 Phan Duy Tân
    * @modified:
    */
    class dataSearch{
        public String nameStudent {get; set;}
        public String idCLass {get; set;}
        public String startDate {get; set;}
        public String endDate {get; set;}
        public Boolean sortName {get; set;}
        public dataSearch(){

        }
        public void setStartDate(String day){
            this.startDate = day;
        }
        public void setEndDate(String day){
            this.endDate = day;
        }
        
    }
    
    /**
    * ClassName: studentDTO
    * ClassDetail: Chứa đói tượng student và selected
    * @created: 2022/06/21 Phan Duy Tân
    * @modified:
    */
    class studentDTO{
        public Student__c student {get; set;}
        public boolean isSelected {get; set;}
        public studentDTO(boolean isSelected, Student__c student){
            this.isSelected = isSelected;
            this.student = student;
        }
    }

}


