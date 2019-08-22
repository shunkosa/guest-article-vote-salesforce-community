# Article Vote Component for Guest User in Lightning Community

Let guest user in Salesforce community vote on articles, and see results in a custom object

![](img/screenshot.png)

## Prerequisite

-   Lightning Knowledge is enabled
-   Single language

## How to use

1. Install package (WIP), or clone the repository and push/deploy source to the target org.

2. Put `Article Vote for Guest Users` on Article Detail page of your community.

3. Set Record Id to `{!recordId}` on the component setting.

4. (If necessary) Change message and label on the component setting.

5. If you enabled `Allow voting on articles` in standard Article Content component, make sure that this vote component is visible for only guest users.

![](img/assign-audience.png)
