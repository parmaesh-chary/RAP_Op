@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for project'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PROJECT
  as select from zakp_proj
  association [0..1] to zakp_boolean as _isSensitive on $projection.IsSensitive = _isSensitive.type
{
  key id              as Id,
      project_id      as ProjectId,
      description     as Description,
      is_sensitive    as IsSensitive,
      status          as Status,
      begin_date      as BeginDate,
      end_date        as EndDate,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      _isSensitive // Make association public
}
