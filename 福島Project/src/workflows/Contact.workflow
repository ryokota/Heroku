<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>JFK_Contact_SetJigyoshoMei</fullName>
        <description>グローバル検索用</description>
        <field>JigyoshoMei__c</field>
        <formula>Account.Name</formula>
        <name>JFK_Contact_SetJigyoshoMei</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>JFK_Contact_SetJigyoshoMei</fullName>
        <actions>
            <name>JFK_Contact_SetJigyoshoMei</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Contact（労働者M）に事業所名を設定（グローバル検索対策）</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
