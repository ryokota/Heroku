public with sharing class userPhotoCnt {
    public String userId{get;set;}
    public String getImgUrl(){
        String photoUrl = [Select FullPhotoUrl from User where Id =: userId].FullPhotoUrl;
        return photoUrl;
    }
    
    public static testmethod void main() {
        userPhotoCnt up = new userPhotoCnt();
        up.userId = UserInfo.getUserId();
        up.getImgUrl();
    }
}