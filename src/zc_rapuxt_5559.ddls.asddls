@EndUserText.label: 'Consumption View for iv ZI_RAPUXT_5559'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_RAPUXT_5559
  as projection on ZI_RAPUXT_5559 as UXTeam
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'First Name'
      @Search.defaultSearchElement: true
      Firstname,
      @EndUserText.label: 'Last Name'
      @Search.defaultSearchElement: true
      Lastname,
      @EndUserText.label: 'Age'
      Age,
      @EndUserText.label: 'Role'
      @Search.defaultSearchElement: true
      Role,
      @EndUserText.label: 'Salary'
      Salary,
      @EndUserText.label: 'Active'
      Active,
      LastChangedAt,
      LocalLastChangedAt
}
