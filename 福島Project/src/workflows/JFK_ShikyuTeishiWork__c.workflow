<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>JFK_ShikyuYoteiGokei</fullName>
        <field>ShikyuYoteiKingaku__c</field>
        <formula>ShikyuYoteiKingaku_1stYear__c  +  ShikyuYoteiKingaku_2ndYear__c  +  ShikyuYoteiKingaku_3rdYear__c</formula>
        <name>JFK_ShikyuYoteiGokei</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>JFK_ShikyuYoteiKingakuSyukei</fullName>
        <actions>
            <name>JFK_ShikyuYoteiGokei</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>JFK_ShikyuTeishiWork__c.ShikyuYoteiKingaku_1stYear__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>JFK_ShikyuTeishiWork__c.ShikyuYoteiKingaku_2ndYear__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>JFK_ShikyuTeishiWork__c.ShikyuYoteiKingaku_3rdYear__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
