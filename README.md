# Article Vote for Guest User in Lightning Community

Let guest user in Salesforce community vote on articles, and see results in a custom object

[English](README.md) | [日本語](README.ja.md)

![](img/screenshot.png)

## Prerequisite

-   Lightning Knowledge is enabled
-   Single language

## How to use

1. Install package ([Production/DE](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tf40000047tgtAAA) | [Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tf40000047tgtAAA)), or clone the repository and push/deploy source to the target org.

2. Put `Article Vote for Guest Users` on Article Detail page of your community.

3. Set Record Id to `{!recordId}` on the component setting.

4. (If necessary) Change message and label on the component setting.

5. If you enabled `Allow voting on articles` in standard Article Content component, make sure that this vote component is visible for only guest users.

![](img/assign-audience.png)

## Vote result

Vote result is stored in `GuestArticleVote__c` custom object. This custom object has the following fields. Create a report of this object for your knowledge improvement lifecycle.

-   **Knowledge** : Lookup to Knowledge Article Version
-   **Guest User Id** : Unique Id for guest users. This value is saved to cookie on guest users' browser to avoid duplicate vote.
-   **Upvoted?** : Checked if upvoted.

## Motivation

Based on the idea ["Let UNAUTHENTICATED community users vote on articles when using Napili Template"](https://success.salesforce.com/ideaView?id=0873A000000CNLzQAO). In classic, [PKB by Salesforce Labs](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N300000059QxXEAU) is available but it won't be updated and Lightning Knowledge is not supported.

## Feedback/Contributing

Feature requests, bug reports and pull requests are welcome!

## License

The source code is licensed under the [MIT license](./LICENSE)
