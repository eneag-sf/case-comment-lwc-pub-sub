public without sharing class CaseCommentControllerLWC{
    @AuraEnabled(cacheable=true)
    public static List<CaseCommentWrapper> getCaseComments(Id caseId, Integer lim, String sortorder, String portal){
        system.debug(caseId);
        system.debug(lim);
        System.debug('portal' + portal);
        List<FeedItem> cclst = new List<FeedItem>();
        List<CaseCommentWrapper> wrplst = new List<CaseCommentWrapper>();
        List<CaseCommentWrapper> finallst = new List<CaseCommentWrapper>();
        List<User> usrinf = [Select Id, ContactId from USer where id=:UserInfo.getUserId()];
        if(caseId != null){
            if(!usrinf.isEmpty() && usrinf[0].ContactId != null){
                for(CaseComment cc: [Select Id, CommentBody, ParentId, Ispublished, CreatedDate, CreatedById, CreatedBy.Name, CreatedBy.Firstname, CreatedBy.Lastname from CaseComment where ParentId = :caseId and IsPublished = true]){
                    CaseCommentWrapper ccwrp = new CaseCommentWrapper();
                    if(cc.CommentBody != null){
                        ccwrp.caseId = cc.ParentId;
                        ccwrp.commentId = cc.Id;
                        ccwrp.sortOrder = sortOrder;
                        ccwrp.comment = cc.CommentBody;
                        ccwrp.createddate = cc.CreatedDate;
                        ccwrp.creatorId = cc.CreatedById;
                        ccwrp.ispublic = '⎷';
                        ccwrp.creatorname = (cc.CreatedBy.Firstname != null ? cc.CreatedBy.Firstname + ' ' : '')  + cc.CreatedBy.Lastname;
                        /*added*/ccwrp.photoUrl = [Select Id, MediumPhotoUrl From User Where Id =: ccwrp.creatorId].MediumPhotoUrl;
                        wrplst.add(ccwrp);
                    }
                }
            }
        }
        wrplst.sort();
        Integer loopsize = wrplst.size() > lim ? lim : wrplst.size();
        for(Integer a = 0; a < loopsize; a++){
            finallst.add(wrplst[a]);
        }
        system.debug('++++'+ wrplst);
        return finallst;
    }
    public class CaseCommentWrapper  implements Comparable{
        @AuraEnabled
        public String commentId;
        @AuraEnabled
        public String caseId;
        @AuraEnabled
        public String comment;
        @AuraEnabled
        public String ispublic;
        @AuraEnabled
        public String creatorId;
        @AuraEnabled
        public String creatorname;
        @AuraEnabled
        public String sortOrder;
        @AuraEnabled
        public DateTime createddate;
        @AuraEnabled
        /*added*/public String photoUrl;


        public Integer compareTo(Object compareTo) {
            CaseCommentWrapper gsarec2 = (CaseCommentWrapper)compareTo;
            if(this.sortOrder == 'ASC'){
                if(this.createddate < gsarec2.createddate){
                    return -1;
                }else if(this.createddate > gsarec2.createddate){
                    return 1;
                }else{
                    return 0;
                }
            }else{
                if(this.createddate < gsarec2.createddate){
                    return 1;
                }else if(this.createddate > gsarec2.createddate){
                    return -1;
                }else{
                    return 0;
                }
            }
        }
    }
}