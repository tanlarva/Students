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
    public VF_TimKiem_Controller() {
        dataSearch = new dataSearch();
    }

    //Controller table
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

    //Tạo selection cho Lớp
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

    //Sự kiện ấn Tìm kiếm
    public void search(){
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

    
    //Chức năng button
    public void deleteStu(){
        Student__c del = new Student__c();
        del = [SELECT Id FROM Student__c WHERE Id =:sId];
        delete del;
        this.result = null;   
    }
    public Pagereference updateStu(){
        Pagereference page = Page.VF_CapNhat;
        page.getParameters().put('id',sId);
        return page;
    }
    public Pagereference detailStu(){
        Pagereference page = Page.VF_ChiTiet;
        page.getParameters().put('id',sId);
        return page;
    }
    public void deleteMNStu(){
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
    public Pagereference newStu(){
        Pagereference page = Page.VF_ThemMoi;
        return page;
    }
    public void sortStu(){

    }

    //Phân trang
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
    public String getPageNumber(){
        return String.valueOf(pageCurrent);
    }

    //Edit query
    public String createQuery(dataSearch dataSearch){
        String query = 'SELECT Class__c, dayOfBirth__c,Diem1__c,Diem3__c,Diem2__c,firstName__c,GPA__c,Id,lastName__c,Sex__c,Status__c, Name FROM Student__c WHERE ';
        String query1, query2, query3, query4;
        if(dataSearch!=null){
            if(dataSearch.nameStudent!=null){
                query1 = ' ((firstName__c LIKE \'%'+dataSearch.nameStudent+'%\') OR (lastName__c LIKE \'%'+dataSearch.nameStudent+'%\'))';
            }
            if((dataSearch.startDate!=null)&&(dataSearch.endDate!=null)){
                query2 = ' (dayOfBirth__c > '+dataSearch.startDate+' AND dayOfBirth__c < '+dataSearch.endDate+')';
            }else if(dataSearch.endDate!=null){
                query2 = ' (dayOfBirth__c < '+dataSearch.endDate+')';
            }else if(dataSearch.startDate!=null){
                query2 = ' (dayOfBirth__c > '+dataSearch.startDate+')';
            }
            if(dataSearch.idCLass!=null){
                query3 = ' Class__c = \''+dataSearch.idCLass+'\'';
            }
            if(dataSearch.sortName){
                query4 = ' ORDER BY lastName__c ';
            }
        }

        query = query + (query1!=null? query1 : '')
                      + (((query1!=null)&&(query2!=null))? ' AND '+query2 : (query2!=null? query2 : ''))
                      + ((((query1!=null)||(query2!=null))&&(query3!=null))? ' AND '+ query3 : (query3!=null? query3 : ''))
                      + (query4!=null? query4: '');
        System.debug('@@@'+ query);
        return query;
    }

    //Sự kiện ấn Cập nhật
    public PageReference updateStu(String id){
        PageReference go = Page.VF_CapNhat;
        go.getParameters().put('id',id);
        return go;
    }

    
    //Các Class phụ
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
        // public String changeDate(String add){
        //     String day = '';
        //     DateTime newDate = date.parse(add);
        //     day = newDate.format('YYYY-MM-dd');
        //     return day;
        // }
    }
    
    class studentDTO{
        public Student__c student {get; set;}
        public boolean isSelected {get; set;}
        public studentDTO(boolean isSelected, Student__c student){
            this.isSelected = isSelected;
            this.student = student;
        }
    }
}


