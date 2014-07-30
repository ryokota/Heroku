public with sharing class TestCtrl {

  public CalcDTO calcDTO { get; set; }

  public TestCtrl() {
    this.calcDTO = new CalcDTO();
  }

  public PageReference reloadParam() {
    return null;
  }

  public PageReference refreshParent() {
    return null;
  }

}