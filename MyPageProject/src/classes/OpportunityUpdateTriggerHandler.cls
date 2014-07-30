public with sharing class OpportunityUpdateTriggerHandler {
    
    /**
     * 引　数：events trigger.new
     * 戻り値：なし
     * レコードタイプ（派遣/派遣スポット/TTP）に関連する活動が登録された場合、
     * 受注.フェーズに訪問決定を設定する
     * 受注.会社訪問日に活動.開始日を設定する
     * 受注.訪問決定日に現時点を設定する
    **/
    public void afterInsert(List<Event> events) {
        
        Map<Id, Opportunity> opps = getTempOpps(events);
        
        for (Event e : events) {
           
           if (opps.containsKey(e.WhatId)) {
               Opportunity opp  = opps.get(e.WhatId);
               opp.StageName = '訪問決定';
               opp.VisitDate__c = e.StartDateTime;
               opp.CommitmentDateOfVisit__c = system.now();
           }
        }
        
        if (!opps.isEmpty()) {
            update opps.values();
        }
    }
    
    /**
     * 引　数：newEvents trigger.new, oldEvents trigger.oldMap
     * 戻り値：なし
     * 開始日が変更された活動のみを抽出し、afterInsertを呼び出す
    **/
    public void afterUpdate(List<Event> newEvents, Map<Id, Event> oldEvents) {
        
        //開始日が変更された活動を対象とする
        afterInsert(getTarget(newEvents, oldEvents));
        
    }
    
    public void afterDelete(List<Event> events) {
        
        //商談取得
        Map<Id, Opportunity> opps      = getTempOpps(events);
        Map<Id, DateTime> maxVisitDate = getMaxVisitDate(opps.values());
        
        //項目マッピング
        for (Event e : events) {
           
           if (opps.containsKey(e.WhatId)) {
               Opportunity opp = opps.get(e.WhatId);
               
               if (maxVisitDate.containsKey(e.WhatId)) {
                   opp.VisitDate__c = maxVisitDate.get(e.WhatId);
               } else {
                   opp.VisitDate__c = null;
                   opp.StageName = 'アポ中';
               }
           }
        }
        
        //商談更新
        if (!opps.isEmpty()) {
            update opps.values();
        }
    }
    
    /**
     *  活動開始時間が更新されている活動を抽出する
    **/
    private List<Event> getTarget(List<Event> newEvents, Map<Id, Event> oldEvents) {
        
        List<Event> target = new List<Event>();
        
        for (Event newEvent : newEvents) {
            Event oldEvent = oldEvents.get(newEvent.Id);
            
            //更新後と更新前の活動を比較
            if (newEvent.startDateTime != oldEvent.startDateTime) {
                target.add(newEvent);
            }
        }
        return target;
    }
    
    private Map<Id, Opportunity> getTempOpps(List<Event> events) {
        
        //商談取得条件
        List<Id> oppIds           = new List<Id>();
        List<Id> tempRecordTypeId = getTempRecordTypeIds();
        
        for (Event e : events) {
            
            //会社訪問の条件を追加する☆☆☆
            if (e.WhatId != null) {
                oppIds.add(e.WhatId);
            }
        }
        
        Map<Id, Opportunity> Opps = new Map<Id, Opportunity>();
        Opps.putAll([select
                            Id
                        from
                            Opportunity
                        where
                            Id in :oppIds and
                            recordTypeId in :tempRecordTypeId]);
        return Opps;
    }
    
    private List<Id> getTempRecordTypeIds() {
        
        List<Id> tempRecordTypeId = new List<Id>();
        tempRecordTypeId.add(RecordTypeUtil.getId('Opportunity', 'Temp'));
        tempRecordTypeId.add(RecordTypeUtil.getId('Opportunity', 'SpotTemp'));
        tempRecordTypeId.add(RecordTypeUtil.getId('Opportunity', 'TTP'));
        return tempRecordTypeId;
    }
    
    /**
     *  商談毎の活動開始時間最大値を取得する
    **/
    private Map<Id, DateTime> getMaxVisitDate(LisT<Opportunity> opps) {
        
        Map<Id, DateTime> maxVisitDate = new Map<Id, DateTime>();
        List<Event> events = [select
                                     StartDateTime,
                                     WhatId
                                 from
                                     Event
                                 where
                                     WhatId in :opps
                                 order by
                                     LastModifiedDate asc];
        
        for (Event event : events) {
            maxVisitDate.put((Id)event.get('WhatId'), (DateTime)event.get('StartDateTime'));
        }
        return maxVisitDate;
    }

}