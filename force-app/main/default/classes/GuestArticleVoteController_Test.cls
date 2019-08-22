@isTest
private class GuestArticleVoteController_Test {
    public static final String GUEST_USER_ID = '4ef37fa1-c256-4fef-8f56-b01ca11323c8';

    @testSetup static void setup(){
        //Publish knowledge articles
        publishTestArticle('test-article-01');
        publishTestArticle('test-article-02');

        //Insert a vote result
        Knowledge__kav kav1 = selectArticleByUrlName('test-article-01');
        insert new GuestArticleVote__c(
            Knowledge__c = kav1.Id,
            GuestUserId__c = GUEST_USER_ID
        );
    }

    @isTest static void existsVoteResult_test(){
        Knowledge__kav kav1 = selectArticleByUrlName('test-article-01');
        System.assert(GuestArticleVoteController.existsVoteResult(kav1.Id, GUEST_USER_ID));

        Knowledge__kav kav2 = selectArticleByUrlName('test-article-02');
        System.assert(!GuestArticleVoteController.existsVoteResult(kav2.Id, GUEST_USER_ID));
    }
    
    @isTest static void vote_test(){
        Knowledge__kav kav2 = selectArticleByUrlName('test-article-02');
        GuestArticleVoteController.vote(kav2.Id, GUEST_USER_ID, true);
        System.assert(GuestArticleVoteController.existsVoteResult(kav2.Id, GUEST_USER_ID));
    }

    private static void publishTestArticle(String urlName) {
        Knowledge__kav kav = new Knowledge__kav(
            URLName = urlName,
            Title = 'test'
        );
        insert kav;
        kav = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :kav.Id];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
    }

    private static Knowledge__kav selectArticleByUrlName(String urlName) {
        return [SELECT Id FROM Knowledge__kav WHERE URLName = :urlName AND PublishStatus = 'Online'];
    }
}
