<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Profit_Center_User_Role_Username_Update</fullName>
        <field>User_Name_Unique__c</field>
        <formula>UserName__c</formula>
        <name>Profit Center User Role Username Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update User Name Unique</fullName>
        <actions>
            <name>Profit_Center_User_Role_Username_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ProfitCenterUserRole__c.UserName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
