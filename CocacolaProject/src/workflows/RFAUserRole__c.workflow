<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Co_Creator_and_POC_upon_Circulation</fullName>
        <description>Notify Co Creator and POC upon Circulation</description>
        <protected>false</protected>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RFA_Email_Templates/RFAVFT02_Upon_Circulation_PPOC</template>
    </alerts>
    <alerts>
        <fullName>Notify_Primary_point_of_contact</fullName>
        <description>Notify Primary point of contact</description>
        <protected>false</protected>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT01_Upon_Addition_Primary_POC</template>
    </alerts>
    <alerts>
        <fullName>Notify_Primary_point_of_contact_user_change</fullName>
        <description>Notify Primary point of contact user change</description>
        <protected>false</protected>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT01_Upon_Addition_Primary_POC</template>
    </alerts>
    <alerts>
        <fullName>Notify_Reviewer_Agent_1</fullName>
        <description>Notify Reviewer Agent 1</description>
        <protected>false</protected>
        <recipients>
            <field>Agent1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT02_Upon_Circulation_Info_Only</template>
    </alerts>
    <alerts>
        <fullName>Notify_Reviewer_Agent_2</fullName>
        <description>Notify Reviewer Agent 2</description>
        <protected>false</protected>
        <recipients>
            <field>Agent2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT02_Upon_Circulation_Info_Only</template>
    </alerts>
    <alerts>
        <fullName>Notify_Reviewer_Agent_3</fullName>
        <description>Notify Reviewer Agent 3</description>
        <protected>false</protected>
        <recipients>
            <field>Agent3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT02_Upon_Circulation_Info_Only</template>
    </alerts>
    <alerts>
        <fullName>Notify_Reviewers</fullName>
        <description>Notify Reviewers</description>
        <protected>false</protected>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT02_Upon_Circulation_Info_Only</template>
    </alerts>
    <alerts>
        <fullName>Notify_User_Role_Return_to_Sender</fullName>
        <description>Notify User Role Return to Sender</description>
        <protected>false</protected>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT05_UponReturntoRQterforuser_Role</template>
    </alerts>
    <alerts>
        <fullName>Pending_Board_Review_Information_Only</fullName>
        <description>Pending Board Review Information Only</description>
        <protected>false</protected>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RFA_Email_Templates/VFT10_BoardReviewCo_CreatorandPOC</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Agent1</fullName>
        <description>Send Email to Agent1</description>
        <protected>false</protected>
        <recipients>
            <field>Agent1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT04_ApproverandAgentCirculation</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Agent2</fullName>
        <description>Send Email to Agent2</description>
        <protected>false</protected>
        <recipients>
            <field>Agent2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT04_ApproverandAgentCirculation</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Agent3</fullName>
        <description>Send Email to Agent3</description>
        <protected>false</protected>
        <recipients>
            <field>Agent3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT04_ApproverandAgentCirculation</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Approvers</fullName>
        <description>Send Email to Approvers</description>
        <protected>false</protected>
        <recipients>
            <field>Agent1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Agent2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Agent3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>UserName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT04_ApproverandAgentCirculation</template>
    </alerts>
    <fieldUpdates>
        <fullName>RFA_Assign_Agent</fullName>
        <field>Agent1__c</field>
        <lookupValue>koichi.maruyama@ccej.co.jp</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RFA_Assign Agent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFA_Assign_Agent2</fullName>
        <field>Agent2__c</field>
        <lookupValue>masaya.kitamura@ccej.co.jp</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RFA Assign Agent2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFA_FU05_UpdateNotifyAgent1FirstTime</fullName>
        <field>Notifyagent1firsttime__c</field>
        <literalValue>1</literalValue>
        <name>RFA_FU05_UpdateNotifyAgent1FirstTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFA_FU06_UpdateNotifyAgent2FirstTime</fullName>
        <field>Notifyagent2firsttime__c</field>
        <literalValue>1</literalValue>
        <name>RFA_FU06_UpdateNotifyAgent2FirstTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFA_FU07_UpdateNotifyAgent3FirstTime</fullName>
        <field>Notifyagent3firsttime__c</field>
        <literalValue>1</literalValue>
        <name>RFA_FU07_UpdateNotifyAgent3FirstTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFA_User_Role_Username_Update</fullName>
        <field>User_Name_Unique__c</field>
        <formula>UserName__c</formula>
        <name>RFA User Role Username Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Notification_Identifier</fullName>
        <description>Reset the NotifyUser checkbox</description>
        <field>NotifyUsers__c</field>
        <literalValue>0</literalValue>
        <name>Reset Notification Identifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Notification_IdentifierNotifyFirst</fullName>
        <field>Notifyuserfirsttime__c</field>
        <literalValue>1</literalValue>
        <name>Reset Notification IdentifierNotifyFirst</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Count</fullName>
        <field>Approval_Count__c</field>
        <formula>Approval_Count__c + 1</formula>
        <name>Update Approval Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval Count</fullName>
        <actions>
            <name>Update_Approval_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>/*
IF(PRIORVALUE(ApprovalRecommendation__c) == &apos;Awaiting Approval&apos;, true, false)
*/
/*
OR(
  ISPICKVAL(ApprovalRecommendation__c, &apos;Unconditionally Approved&apos;),
  ISPICKVAL(ApprovalRecommendation__c, &apos;Conditionally Approved&apos;),
  ISPICKVAL(ApprovalRecommendation__c, &apos;Rejected&apos;),
  ISPICKVAL(ApprovalRecommendation__c, &apos;Return to Requester&apos;),
  ISPICKVAL(ApprovalRecommendation__c, &apos;Awaiting for Approval&apos;)
)*/
ISCHANGED(ApprovalRecommendation__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RFA_Assign Agent</fullName>
        <actions>
            <name>RFA_Assign_Agent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RFA_Assign_Agent2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RFAUserRole__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Approver</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFAUserRole__c.UserName__c</field>
            <operation>equals</operation>
            <value>Maniwa Daisuke</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFA__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>General Request</value>
        </criteriaItems>
        <description>Assign Maruyama-san and Kitamura-san as agent for Capital/Medium/Small request.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF01_Approver Circulation Notification</fullName>
        <actions>
            <name>Send_Email_to_Approvers</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>RFAUserRole__c.ApprovalRecommendation__c</field>
            <operation>equals</operation>
            <value>Awaiting Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFAUserRole__c.DoNotSendEmail__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>RFAUserRole__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Approver</value>
        </criteriaItems>
        <description>Send email notification to approvers and agents when the RFA is pushed to circulation Stage</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF02_Reviewer Circulation Notify</fullName>
        <actions>
            <name>Notify_Reviewers</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Notification_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_Notification_IdentifierNotifyFirst</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Notify info Only copy users of RFA when the Info Only User record is marked for notification or the User Name field is changed.</description>
        <formula>RecordType.Name = &apos;Info Copy Only&apos; &amp;&amp; DoNotSendEmail__c = False  &amp;&amp; ( ( Notifyuserfirsttime__c = False &amp;&amp; NotifyUsers__c = True ) ||  ( ISCHANGED( UserName__c ) &amp;&amp; Notifyuserfirsttime__c = True ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF03_Notify Primary POC</fullName>
        <actions>
            <name>Notify_Primary_point_of_contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Primary point of contact when they are added to the user role table of a given rfa</description>
        <formula>/* OR(CONTAINS($RecordType.DeveloperName, &quot;RUR_PrimaryPointofContact&quot;), CONTAINS( $RecordType.DeveloperName, &quot;RUR_CoCreator&quot;)) OR(CONTAINS($RecordType.DeveloperName, &quot;RUR_PrimaryPointofContact&quot;)) */ 

(CreatedById &lt;&gt; UserName__r.Id ) 
&amp;&amp;(CONTAINS($RecordType.DeveloperName, &quot;RUR_PrimaryPointofContact&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF03_Notify Primary POC User Change</fullName>
        <actions>
            <name>Notify_Primary_point_of_contact_user_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(CreatedById &lt;&gt; UserName__r.Id ) 
&amp;&amp;
(CONTAINS($RecordType.DeveloperName, &quot;RUR_PrimaryPointofContact&quot;))
&amp;&amp;
ISCHANGED( UserName__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF04_Notify Return to Sender - POC</fullName>
        <actions>
            <name>Notify_User_Role_Return_to_Sender</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Notification_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Notify Primary point of contact when the RFA is pushed to the stage &quot;Return to Requester&quot;</description>
        <formula>AND($RecordType.DeveloperName==&quot;RUR_PrimaryPointofContact&quot;,ISPICKVAL(RFA__r.Stage__c, &quot;Return To Requester&quot;),    RFA__r.CreatedBy.Email  != UserName__r.Email,DuplicateRecord__c!=true,NotifyUsers__c == true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF05_Agent1 Circulation Notification</fullName>
        <actions>
            <name>Send_Email_to_Agent1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email notification to agent (1) reference has been chanhed while the RFA is in circulation stage.</description>
        <formula>AND(ISCHANGED(Agent1__c),  ISPICKVAL(RFA__r.Stage__c, &quot;Circulation&quot;),  ISPICKVAL(ApprovalRecommendation__c, &quot;Awaiting Approval&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF06_Agent2 Circulation Notification</fullName>
        <actions>
            <name>Send_Email_to_Agent2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email notification to agent (2) reference has been chanhed while the RFA is in circulation stage.</description>
        <formula>AND(ISCHANGED(Agent2__c), ISPICKVAL(RFA__r.Stage__c, &quot;Circulation&quot;), ISPICKVAL(ApprovalRecommendation__c, &quot;Awaiting Approval&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF07_Agent3 Circulation Notification</fullName>
        <actions>
            <name>Send_Email_to_Agent3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email notification to agent (3) reference has been chanhed while the RFA is in circulation stage.</description>
        <formula>AND(ISCHANGED(Agent3__c), ISPICKVAL(RFA__r.Stage__c, &quot;Circulation&quot;), ISPICKVAL(ApprovalRecommendation__c, &quot;Awaiting Approval&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF08_Circulation Notify - POC</fullName>
        <actions>
            <name>Notify_Co_Creator_and_POC_upon_Circulation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Notification_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Information only email communication to Primary POC when the RFA is pushed to &quot;Circulation&quot; Stage</description>
        <formula>AND(  $RecordType.DeveloperName==&quot;RUR_PrimaryPointofContact&quot;, ISPICKVAL(RFA__r.Stage__c, &quot;Circulation&quot;), NotifyUsers__c == true, NOT( DoNotSendEmail__c ), RFA__r.CreatedBy.Email!=UserName__r.Email,DuplicateRecord__c!=true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF10_Reviewer Agent 1 Circulation Notify</fullName>
        <actions>
            <name>Notify_Reviewer_Agent_1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RFA_FU05_UpdateNotifyAgent1FirstTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Info Only copy Agent 1 users of RFA when the Info Only User record is marked for notification or the Agent 1 field is changed.</description>
        <formula>RecordType.Name = &apos;Info Copy Only&apos; &amp;&amp;  DoNotSendEmail__c = False  &amp;&amp;  NOT( ISBLANK( Agent1__c ) ) &amp;&amp;  ( ( (Notifyuserfirsttime__c = True || NotifyUsers__c = True)  &amp;&amp; Notifyagent1firsttime__c = False ) ||  ( ISCHANGED( Agent1__c ) &amp;&amp; Notifyagent1firsttime__c = True ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF11_Reviewer Agent 2 Circulation Notify</fullName>
        <actions>
            <name>Notify_Reviewer_Agent_2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RFA_FU06_UpdateNotifyAgent2FirstTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Info Only copy Agent 2 users of RFA when the Info Only User record is marked for notification or the Agent 2 field is changed.</description>
        <formula>RecordType.Name = &apos;Info Copy Only&apos; &amp;&amp;  DoNotSendEmail__c = False  &amp;&amp;  NOT( ISBLANK( Agent2__c ) ) &amp;&amp;  ( ( (Notifyuserfirsttime__c = True || NotifyUsers__c = True)  &amp;&amp; Notifyagent2firsttime__c = False ) ||  ( ISCHANGED( Agent2__c ) &amp;&amp; Notifyagent2firsttime__c = True ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RUR_WF12_Reviewer Agent 3 Circulation Notify</fullName>
        <actions>
            <name>Notify_Reviewer_Agent_3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RFA_FU07_UpdateNotifyAgent3FirstTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Info Only copy Agent 3 users of RFA when the Info Only User record is marked for notification or the Agent 3 field is changed.</description>
        <formula>RecordType.Name = &apos;Info Copy Only&apos; &amp;&amp;  DoNotSendEmail__c = False  &amp;&amp;  NOT( ISBLANK( Agent3__c ) ) &amp;&amp;  ( ( (Notifyuserfirsttime__c = True || NotifyUsers__c = True)  &amp;&amp; Notifyagent3firsttime__c = False ) ||  ( ISCHANGED( Agent3__c ) &amp;&amp; Notifyagent3firsttime__c = True ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update User Name Unique %28RFA User Role%29</fullName>
        <actions>
            <name>RFA_User_Role_Username_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>RFAUserRole__c.UserName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
