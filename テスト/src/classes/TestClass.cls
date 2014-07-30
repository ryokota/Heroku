public with sharing class TestClass {

    public Map<String, List<String>> testMap {get;set;}
    public Map<String, Integer> listSizeMap {get;set;}

    public TestClass()
    {
        listSizeMap = new Map<String, Integer>();
        testMap = new Map<String, List<String>>();
        testMap.put('test1', new List<String>{'1', '2'});
        testMap.put('test2', new List<String>{'1', '2','3'});
        testMap.put('test3', new List<String>{'1', '2','3','4'});
        testMap.put('test4', new List<String>());

        for(String key : testMap.keySet())
        {
            listSizeMap.put(key, testMap.get(key).size());
        }
    }
}