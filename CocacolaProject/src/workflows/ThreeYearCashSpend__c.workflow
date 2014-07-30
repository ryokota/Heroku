<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Additional_Years</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RFA_WF09_Assign Additional years layout</fullName>
        <actions>
            <name>Change_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ThreeYearCashSpend__c.Year__c</field>
            <operation>equals</operation>
            <value>Additional Years</value>
        </criteriaItems>
        <description>Assign Additional Years record type to those records with Year value as Addition Year</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
