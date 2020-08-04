import { LightningElement, api } from 'lwc';
import existsVoteResult from '@salesforce/apex/GuestArticleVoteController.existsVoteResult';
import vote from '@salesforce/apex/GuestArticleVoteController.vote';

const COOKIE_KEY = 'guest_user_id';

export default class GuestArticleVote extends LightningElement {
    @api recordId;

    @api message_ask;
    @api message_thankyou;
    @api label_choice_yes;
    @api label_choice_no;

    isLoaded = false; // Prevent DOM rendering until the query finishes
    isVoted = false;
    isCompleted = false;
    hasError = false; // For future use
    currentGuestUserId = '';

    connectedCallback() {
        this.currentGuestUserId = this.getCookie(COOKIE_KEY);
        if (!this.currentGuestUserId) {
            this.currentGuestUserId = this.setCookie(
                COOKIE_KEY,
                this.generateUUID()
            );
        }
        existsVoteResult({
            articleVersionId: this.recordId,
            guestUserId: this.currentGuestUserId
        }).then((result) => {
            this.isVoted = result;
            this.isLoaded = true;
        });
    }

    upvote() {
        vote({
            articleVersionId: this.recordId,
            guestUserId: this.currentGuestUserId,
            isUpvoted: true
        })
            .then(() => {
                this.isVoted = true;
                this.isCompleted = true;
            })
            .catch(() => {
                this.hasError = true;
            });
    }

    downvote() {
        vote({
            articleVersionId: this.recordId,
            guestUserId: this.currentGuestUserId,
            isUpvoted: false
        })
            .then(() => {
                this.isVoted = true;
                this.isCompleted = true;
            })
            .catch(() => {
                this.hasError = true;
            });
    }

    getCookie(key) {
        const cookieString = '; ' + document.cookie;
        const parts = cookieString.split('; ' + key + '=');
        if (parts.length === 2) {
            return parts
                .pop()
                .split(';')
                .shift();
        }
        return null;
    }

    setCookie(key, value) {
        document.cookie = `${key}=${value}; path=/`;
        return value;
    }

    generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
            const r = (Math.random() * 16) | 0,
                v = c === 'x' ? r : (r & 0x3) | 0x8;
            return v.toString(16);
        });
    }
}
