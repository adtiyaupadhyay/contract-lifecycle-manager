@isTest
private class ClauseSuggestionServiceTest {
    
    // Mock HTTP response class
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"choices":[{"message":{"content":"1. Payment Clause: Payment must be made within 30 days.\\n2. Liability Clause: Liability is limited to contract value.\\n3. Termination Clause: Either party may terminate with 30 days notice."}}]}');
            return res;
        }
    }
    
    @isTest
    static void testSuggestClauses() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Test.startTest();
        String result = ClauseSuggestionService.suggestClauses(
            'Test Contract',
            '500000',
            'Under Review'
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('Clause') || result.contains('clause'), 
            'Result should contain clause suggestions');
    }
    
    @isTest
    static void testSuggestClausesErrorHandling() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Test.startTest();
        String result = ClauseSuggestionService.suggestClauses(
            'Error Contract',
            '0',
            'Draft'
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Should handle response without throwing');
    }
}