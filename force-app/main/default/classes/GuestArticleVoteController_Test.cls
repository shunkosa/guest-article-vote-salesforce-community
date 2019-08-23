@isTest
private class GuestArticleVoteController_Test {
    public static final String GUEST_USER_ID = '4ef37fa1-c256-4fef-8f56-b01ca11323c8';

    @testSetup
    static void setup() {
        User u = createTestUser();
        System.runAs(u) {
            //Publish knowledge articles
            publishTestArticle('test-article-01');
            publishTestArticle('test-article-02');
        }
        //Insert a vote result
        Knowledge__kav kav1 = selectArticleByUrlName('test-article-01');
        insert new GuestArticleVote__c(
            Knowledge__c = kav1.Id,
            GuestUserId__c = GUEST_USER_ID
        );
    }

    @isTest
    static void existsVoteResult_test() {
        Knowledge__kav kav1 = selectArticleByUrlName('test-article-01');
        System.assert(
            GuestArticleVoteController.existsVoteResult(kav1.Id, GUEST_USER_ID)
        );

        Knowledge__kav kav2 = selectArticleByUrlName('test-article-02');
        System.assert(
            !GuestArticleVoteController.existsVoteResult(kav2.Id, GUEST_USER_ID)
        );
    }

    @isTest
    static void vote_test() {
        Knowledge__kav kav2 = selectArticleByUrlName('test-article-02');
        GuestArticleVoteController.vote(kav2.Id, GUEST_USER_ID, true);
        System.assert(
            GuestArticleVoteController.existsVoteResult(kav2.Id, GUEST_USER_ID)
        );
    }

    private static User createTestUser() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now())
            .replace(' ', '')
            .replace(':', '')
            .replace('-', '');
        String randomIntString = String.valueOf(Crypto.getRandomInteger());
        Profile p = [
            SELECT Id, Name
            FROM Profile
            WHERE
                UserType = 'Standard'
                AND PermissionsCustomizeApplication = true
        ][0];
        User u = new User(
            UserName = 'test@' + orgId + dateString + randomIntString + '.org',
            Email = 'test@' + orgId + dateString + randomIntString + '.org',
            LastName = 'test',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            UserPermissionsKnowledgeUser = true
        );
        insert u;
        return u;
    }

    private static void publishTestArticle(String urlName) {
        Knowledge__kav kav = new Knowledge__kav(
            URLName = urlName,
            Title = 'test'
        );
        insert kav;
        kav = [
            SELECT KnowledgeArticleId
            FROM Knowledge__kav
            WHERE Id = :kav.Id
        ];
        KbManagement.PublishingService.publishArticle(
            kav.KnowledgeArticleId,
            true
        );
    }

    private static Knowledge__kav selectArticleByUrlName(String urlName) {
        return [
            SELECT Id
            FROM Knowledge__kav
            WHERE URLName = :urlName AND PublishStatus = 'Online'
        ];
    }
}
