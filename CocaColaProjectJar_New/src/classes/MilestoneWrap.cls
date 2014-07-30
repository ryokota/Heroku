public class MilestoneWrap {
    public WrapperClass mainMilestone {get;set;}
    public List<WrapperClass> subMilestone {get;set;}
    public MilestoneWrap(){
      mainMilestone = new WrapperClass();
      subMilestone = new List<WrapperClass>();
    }
  }