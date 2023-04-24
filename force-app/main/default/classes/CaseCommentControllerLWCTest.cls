@isTest
public class CaseCommentControllerLWCTest {
    
    @testSetup
    public static void testData() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs (thisUser) {
            Account acct = new Account(
                Name = 'Test Account');
            insert acct;
            
            Case testCase = new Case(
                Status = 'In Preparation',
                Description = 'test'); 
            insert testCase;
            
            CaseComment c1 = (new CaseComment(
                commentbody = 'comment 1', 
                parentId = testCase.Id,
                IsPublished = true));
            insert c1;
            CaseComment c2 = (new CaseComment(
                commentbody = 'comment 2', 
                parentId = testCase.Id,
                IsPublished = true));
            insert c2;
            CaseComment c3 = (new CaseComment(
                commentbody = 'comment 3', 
                parentId = testCase.Id,
                IsPublished = true));
            insert c3;
            
            Contact con = new Contact(
                FirstName = 'test',
                LastName = 'name',
                AccountId=acct.Id);
            insert con;
            
            String pId = [SELECT ID from Profile WHERE Name= '*B2B User (Login-based)'].Id;
            UserRole userRole = [SELECT Id FROM UserRole WHERE PortalType = 'CustomerPortal' LIMIT 1];
            User usr = new User(contactId=con.Id, username=con.Id+'@test.com', firstname=con.FirstName,
                                lastname=con.LastName, email=con.Id+'@test.com',
                                alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)), profileid = pId, emailencodingkey='UTF-8',
                                languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles', UserRole = userRole) ;
            insert usr;   
        }
    }
    
    
    @isTest
    public static void caseCommentDateSort1() {
        String caseId = [SELECT Id, CreatedDate FROM Case WHERE CreatedDate = TODAY].Id;
        User usr = [SELECT Id, FirstName, LastName FROM User WHERE FirstName = 'test' AND LastName ='name' LIMIT 1];
        CaseComment c3 = [SELECT ID, CommentBody FROM CaseComment WHERE CommentBody= 'comment 3'];
        Test.setCreatedDate(c3.Id, Date.today().addDays(-2));
        
        update c3;
        System.runAs(usr){
            CaseCommentControllerLWC.getCaseComments(caseId, 5, 'DESC', 'shop');   
            Test.startTest();
            CaseCommentControllerLWC.getCaseComments(caseId, 5, 'ASC', 'shop');
            Test.stopTest();
        }
    }
    
    
    @isTest
    public static void caseCommentDateSort2() {
        String caseId = [SELECT Id, CreatedDate FROM Case WHERE CreatedDate = TODAY].Id;
        User usr = [SELECT Id, FirstName, LastName FROM User WHERE FirstName = 'test' AND LastName ='name' LIMIT 1];
        
        System.runAs(usr){
            CaseCommentControllerLWC.getCaseComments(caseId, 5, 'DESC', 'shop');   
            Test.startTest();
            CaseCommentControllerLWC.getCaseComments(caseId, 5, 'ASC', 'shop');
            Test.stopTest();
        }
    }
    
    
    @isTest
    public static void caseCommentDateSort3() {
        String caseId = [SELECT Id, CreatedDate FROM Case WHERE CreatedDate = TODAY].Id;
        User usr = [SELECT Id, FirstName, LastName FROM User WHERE FirstName = 'test' AND LastName ='name' LIMIT 1];
        CaseComment c2 = [SELECT ID, CommentBody FROM CaseComment WHERE CommentBody= 'comment 2'];
        CaseComment c1 = [SELECT ID, CommentBody FROM CaseComment WHERE CommentBody= 'comment 1'];
        CaseComment c3 = [SELECT ID, CommentBody FROM CaseComment WHERE CommentBody= 'comment 3'];
        
        System.runAs(usr){
            
            Test.setCreatedDate(c2.Id, Date.today().addDays(-2));
            update c2;   
            Test.startTest();
            Test.setCreatedDate(c1.Id, Date.today());
            update c1;
            Test.setCreatedDate(c3.Id, Date.today().addDays(-3));
            update c3;
            CaseCommentControllerLWC.getCaseComments(caseId, 5, 'DESC', 'shop');
            CaseCommentControllerLWC.getCaseComments(caseId, 5, 'ASC', 'shop');
            Test.stopTest();
        }    
    }  
}