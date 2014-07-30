<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Creator_Upon_Circulation</fullName>
        <description>Notify Creator Upon Circulation</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT03_UponCirculation_Requester</template>
    </alerts>
    <alerts>
        <fullName>Notify_Creator_on_Return_to_Sender</fullName>
        <description>Notify Creator on Return to Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>rfa@ccej.co.jp</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_RFA_Email_Templates/RFAVFT05_Return_to_Requester</template>
    </alerts>
    <fieldUpdates>
        <fullName>RFA_FU03_UpdateCirculationDate</fullName>
        <description>RFA R1 - Update the Circulation Date field with Current Date-Time</description>
        <field>CirculationDate__c</field>
        <formula>NOW()</formula>
        <name>RFA_FU03_UpdateCirculationDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RFA_FU04_SetOwner</fullName>
        <description>RFA R1 - Set Generic USer as RFA Owner</description>
        <field>OwnerId</field>
        <lookupValue>rfasystem@rfa.coca-cola.com.ccej</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RFA_FU04_SetOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RFA_WF03_UpdateCirculationDate</fullName>
        <actions>
            <name>RFA_FU03_UpdateCirculationDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>RFA R1 - Update the Circulation Date Once RFA is moved from Draft stage.</description>
        <formula>AND( ISCHANGED(Stage__c),   ISPICKVAL(PRIORVALUE(Stage__c ), &apos;Draft&apos; ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RFA_WF05_Notify Creator Return to Sender</fullName>
        <actions>
            <name>Notify_Creator_on_Return_to_Sender</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>RFA__c.Stage__c</field>
            <operation>equals</operation>
            <value>Return to Requester</value>
        </criteriaItems>
        <description>Notify the record creator when the RFA is sent back to the Requester</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RFA_WF06_Set Generic RFA Owner</fullName>
        <actions>
            <name>RFA_FU04_SetOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>RFA R1 - Set a generic user as RFA Owner During RFA Creation</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RFA_WF08_Notify Creator Upon Circulation</fullName>
        <actions>
            <name>Notify_Creator_Upon_Circulation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>RFA__c.Stage__c</field>
            <operation>equals</operation>
            <value>Circulation</value>
        </criteriaItems>
        <description>Notify the record creator when the RFA is pushed to Circulation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
