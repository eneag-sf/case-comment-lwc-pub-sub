// CaseCommentService.cls
public with sharing class CaseCommentService {
    @AuraEnabled(cacheable=true)
    public static List<CaseComment> getCaseComments(Id caseId) {
        return [
            SELECT Id, CommentBody, CreatedBy.Name, CreatedDate
            FROM CaseComment
            WHERE ParentId = :caseId
            ORDER BY CreatedDate ASC
        ];
    }
}
