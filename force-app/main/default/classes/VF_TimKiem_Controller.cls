public with sharing class VF_TimKiem_Controller {
    private static final Integer INT_LIMIT_QUERY = 50000;

    private Integer pageCurrent = 1;
    private Integer totalPage = 0;
    private final Integer pageSize = 3;
    String chooseCLass;

    public dataSearch dataSearch {get; set; }
    
    public Integer totalSearch {get; set; }
    private List<studentDTO> result {get; set; }
    public VF_TimKiem_Controller() {
        dataSearch = new dataSearch();
    }
    //Controller table
    public List<studentDTO> getResults(){
        if(this.result==null){
            List<studentDTO> results = new List<studentDTO>();
            for(Student__c oneStudent : [SELECT Id, firstName__c, lastName__c, Sex__c, dayOfBirth__c, Diem1__c,Diem2__c, Diem3__c, GPA__c, Status__c FROM Student__c]){
                results.add(new StudentDTO(
                                false, oneStudent
                ));
            }
            this.result = results;
            this.totalSearch = results.size();
            this.totalPage = (this.totalSearch<3)?1:((math.mod(this.totalSearch,pageSize)==0) ? math.mod(this.totalSearch,pageSize) : math.mod(this.totalSearch,pageSize) +1);
        }
        List<studentDTO> results = new List<studentDTO>();
        for(Integer i  = ((pageCurrent-1)*pageSize);  i < (pageCurrent==totalPage? totalSearch : pageSize*pageCurrent ); i++){
            results.add(this.result[i]);
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

    //Test
    public String getNameStudent(){
        return dataSearch.nameStudent;
    }
    public void setNameStudent(String nameStudent){
        this.dataSearch.nameStudent = nameStudent;
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

        System.debug('@@@ '+query);
        System.debug('@@@ '+ dataSearch.startDate);
    

        List<Student__c> temp = Database.query(query);
        List<studentDTO> results = new List<studentDTO>();
        for(Student__c oneStudent : temp){
            results.add(new StudentDTO(
                        false, oneStudent
            ));
        }
        this.result = results;
        this.totalSearch = results.size();
        this.totalPage = (this.totalSearch<3)?1:((math.mod(this.totalSearch,pageSize)==0) ? math.mod(this.totalSearch,pageSize) : math.mod(this.totalSearch,pageSize) +1);
    }

    
    //Sự kiện ấn xóa
    public boolean deleteStu(){
        return false;
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
        String query1, query2, query3;
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
        }

        query = query + (query1!=null? query1 : '')
                      + (((query1!=null)&&(query2!=null))? ' AND '+query2 : (query2!=null? query2 : ''))
                      + ((((query1!=null)||(query2!=null))&&(query3!=null))? ' AND '+ query3 : (query3!=null? query3 : ''));

        return query;
    }

    
    //Các Class phụ
    class dataSearch{
        public String nameStudent {get; set;}
        public String idCLass {get; set;}
        public String startDate {get; set;}
        public String endDate {get; set;}
        public dataSearch(){

        }
        public void setStartDate(String day){
            // if(day!=null){
            //     this.startDate = date.parse(day) ;
            // }
            try{
                this.startDate = changeDate(day);
            }catch(System.DmlException ex){
                ApexPages.addMessages(ex);
            }
        }
        public void setEndDate(String day){
            // if(day!=null){
            //     this.endDate = date.parse(day) ;
            // }
            try{
                this.endDate = changeDate(day);
            }catch(System.DmlException ex){
                ApexPages.addMessages(ex);
            }
        }
        public String changeDate(String add){
            String day = '';
            try{
                DateTime newDate = date.parse(add);
                day = newDate.format('YYYY-MM-dd');
            }catch(System.DmlException ex){
                ApexPages.addMessages(ex);
                return null;
            }
            return day;
        }
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


