public with sharing class ClauseSuggestionService {
    
    @AuraEnabled
    public static String suggestClauses(String contractName, String contractValue, String contractStatus) {
        try {
            // Build the prompt
            String prompt = 'You are a legal contract assistant. ' +
                'Suggest 3 important contract clauses for the following contract:\n' +
                'Contract Name: ' + contractName + '\n' +
                'Contract Value: INR ' + contractValue + '\n' +
                'Contract Status: ' + contractStatus + '\n' +
                'Format your response as 3 numbered clauses, each with a title and 1-2 sentence description.';
            
            // Build request body
            Map<String, Object> message = new Map<String, Object>{
                'role' => 'user',
                'content' => prompt
            };
            
            Map<String, Object> requestBody = new Map<String, Object>{
                'model' => 'nvidia/nemotron-3-super-120b-a12b:free',
                'messages' => new List<Object>{ message }
            };
            
            // Make HTTP callout
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:OpenRouter_API/chat/completions');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('HTTP-Referer', 'https://salesforce.com');
            req.setBody(JSON.serialize(requestBody));
            req.setTimeout(30000);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> choices = (List<Object>) responseMap.get('choices');
                Map<String, Object> firstChoice = (Map<String, Object>) choices[0];
                Map<String, Object> messageResponse = (Map<String, Object>) firstChoice.get('message');
                return (String) messageResponse.get('content');
            } else {
                return 'Error: ' + res.getStatusCode() + ' ' + res.getBody();
            }
            
        } catch (Exception e) {
            throw new AuraHandledException('Clause suggestion failed: ' + e.getMessage());
        }
    }
}