global class WrapperClass implements Comparable {
    public Milestone1_Milestone__c subM {get;set;}
    public List<TaskWrap> subT {get;set;}
    public WrapperClass(){
      subM = new Milestone1_Milestone__c();
      subT = new List<TaskWrap>();
    }
    
    public void sortTasks()
    {
        subT.sort();
    }
    
    global Integer compareTo(Object compareTo) {
        // Cast argument to WrapperClass
        WrapperClass compareToWrapper = (WrapperClass)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (subM.Name > compareToWrapper.subM.Name) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (subM.Name < compareToWrapper.subM.Name) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
  }