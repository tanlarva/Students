({


    getClassPicklist : function(component, event){
        var action = component.get('c.getListClass');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var classMap = [];
                classMap.push({key: 'All', value: 'Tất cả', selected: true});
                for(var key in result){
                    classMap.push({key: key, value: result[key]});
                }
                component.set('v.options', classMap);
            }
        });
        $A.enqueueAction(action);
    },

    changeClass: function(component, event){
        var temp = component.find('classPicklist').get('v.value');
        component.set('v.dataSearch.idClass', temp);
        alert(component.get('v.dataSearch.idClass'))
    }
})
