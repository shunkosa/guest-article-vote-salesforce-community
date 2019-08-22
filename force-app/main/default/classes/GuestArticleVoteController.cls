public class GuestArticleVoteController {
    @AuraEnabled
    public static Boolean existsVoteResult(String articleVersionId, String guestUserId){
        Integer voteCount = [
            SELECT COUNT()
            FROM GuestArticleVote__c
            WHERE Knowledge__c = :articleVersionId AND GuestUserId__c = :guestUserId
        ];
        return (voteCount > 0);
    }

    @AuraEnabled
    public static void vote(String articleVersionId, String guestUserId, Boolean isUpvoted){
        insert new GuestArticleVote__c(
            Knowledge__c  = articleVersionId,
            GuestUserId__c = guestUserId,
            IsUpvoted__c = isUpvoted
        );
    }
}
