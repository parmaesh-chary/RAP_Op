@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface boolean'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_BOOLEAN
  as select from zakp_boolean
{
      @Search.defaultSearchElement: true
  key type  as Type,
      value as Value
}
