global class MilestoneWrap implements Comparable {
    public WrapperClass mainMilestone {get;set;}
    public List<WrapperClass> subMilestone {get;set;}
    public MilestoneWrap(){
      mainMilestone = new WrapperClass();
      subMilestone = new List<WrapperClass>();
    }

    // Sorts the WrapperClass ites in the SubMilestone    
    public void sortSubMilestones() {
        subMilestone.sort();
    }
    
    global Integer compareTo(Object compareTo) {
        // Cast argument to MilestoneWrap
        MilestoneWrap compareToMW = (MilestoneWrap)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (mainMilestone.subM.Name > compareToMW.mainMilestone.subM.Name) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (mainMilestone.subM.Name < compareToMW.mainMilestone.subM.Name) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}