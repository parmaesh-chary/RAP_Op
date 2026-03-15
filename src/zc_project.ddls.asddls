@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for project'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PROJECT
  provider contract transactional_query
  as projection on ZI_PROJECT
{
  key Id,
      ProjectId,
      Description,
      IsSensitive,
      Status,
      BeginDate,
      EndDate,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _isSensitive
}
