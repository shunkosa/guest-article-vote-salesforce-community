import { createElement } from 'lwc';
import GuestArticleVote from 'c/guestArticleVote';

import existsVoteResult from '@salesforce/apex/GuestArticleVoteController.existsVoteResult';
import vote from '@salesforce/apex/GuestArticleVoteController.vote';

jest.mock(
    '@salesforce/apex/GuestArticleVoteController.existsVoteResult',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apex/GuestArticleVoteController.vote',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-guest-article-vote', () => {
    afterEach(() => {
        //The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    function flushPromises() {
        // eslint-disable-next-line no-undef
        return new Promise((resolve) => setImmediate(resolve));
    }

    it('Renders form before vote', async () => {
        existsVoteResult.mockResolvedValue(false);

        const element = createElement('c-guest-article-vote', {
            is: GuestArticleVote
        });
        document.body.appendChild(element);
        await flushPromises();

        const buttons = element.shadowRoot.querySelectorAll('lightning-button');
        expect(buttons).toHaveLength(2);
    });

    it('Renders form after vote', async () => {
        existsVoteResult.mockResolvedValue(true);

        const element = createElement('c-guest-article-vote', {
            is: GuestArticleVote
        });
        document.body.appendChild(element);
        await flushPromises();

        const buttons = element.shadowRoot.querySelectorAll('lightning-button');
        expect(buttons).toHaveLength(0);
    });

    it('Upvote', async () => {
        existsVoteResult.mockResolvedValue(false);

        const element = createElement('c-guest-article-vote', {
            is: GuestArticleVote
        });
        document.body.appendChild(element);
        await flushPromises();

        vote.mockResolvedValue({});

        const buttons = element.shadowRoot.querySelectorAll('lightning-button');
        buttons[0].click();

        await flushPromises();
        const message = element.shadowRoot.querySelector(
            'div.slds-text-align_center'
        );
        expect(message).toBeDefined();
    });

    it('Downvote', async () => {
        existsVoteResult.mockResolvedValue(false);

        const element = createElement('c-guest-article-vote', {
            is: GuestArticleVote
        });
        document.body.appendChild(element);
        await flushPromises();

        vote.mockResolvedValue({});

        const buttons = element.shadowRoot.querySelectorAll('lightning-button');
        buttons[1].click();
        await flushPromises();

        const message = element.shadowRoot.querySelector(
            'div.slds-text-align_center'
        );
        expect(message).toBeDefined();
    });
});
