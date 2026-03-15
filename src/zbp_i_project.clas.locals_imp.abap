CLASS lhc_ZI_PROJECT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_project RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_project RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_project RESULT result.

    METHODS setStatus FOR MODIFY
      IMPORTING keys FOR ACTION zi_project~setStatus RESULT result.

    METHODS DetProjId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_project~DetProjId.

    METHODS ValDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_project~ValDates.

ENDCLASS.

CLASS lhc_ZI_PROJECT IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setStatus.

    ""Updating the select records

    MODIFY ENTITIES OF zi_project IN LOCAL MODE
    ENTITY zi_project
    UPDATE FROM VALUE #( FOR key IN keys (
                      Id = key-id
                      Status = 'A'
                      %control-Status = if_abap_behv=>mk-on
                      ) )
                      FAILED failed
                      REPORTED reported.

    "" Read the updated entities
    READ ENTITIES OF zi_project IN LOCAL MODE
    ENTITY zi_project
    FROM VALUE #( FOR key IN keys ( Id = key-id ) )
    RESULT DATA(lt_result).

    ""Pass the result to output

    result = VALUE #( FOR ls_result IN lt_result
                       (
                       id = ls_result-id
                       %param = ls_result
                       ) ).


  ENDMETHOD.

  METHOD DetProjId.

    ""Read the Entities

    READ ENTITIES OF zi_project IN LOCAL MODE
    ENTITY zi_project FIELDS (  ProjectId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    ""Delete the record where project id is already determined
    DELETE lt_result WHERE ProjectId IS NOT INITIAL.

    IF lines( lt_result ) GT 0.
      ""Update the projected id based on sensitivity field
      MODIFY ENTITIES OF zi_project IN LOCAL MODE
      ENTITY zi_project
      UPDATE FIELDS ( ProjectId )
      WITH VALUE #( FOR ls_result IN lt_result INDEX INTO i (
                      %key = ls_result-%key
                      ProjectId = COND #( WHEN ls_result-IsSensitive EQ 'Y'
                      THEN |S-{ sy-timlo  }|
                      ELSE |N-{ sy-timlo }| ) ) )
                      REPORTED DATA(LT_reported).
    ENDIF.

  ENDMETHOD.

  METHOD ValDates.

    READ ENTITIES OF zi_project IN LOCAL MODE
    ENTITY zi_project
    FROM VALUE #( FOR <root_key> IN keys ( %key-Id = <root_key>-Id
    %control = VALUE #( BeginDate = if_abap_behv=>mk-on
                        EndDate =  if_abap_behv=>mk-on  ) ) )
                        RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_result).
      IF ls_result-BeginDate LT cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %key = ls_result-%key
                        id = ls_result-Id  ) TO failed-zi_project.
        APPEND VALUE #( %key = ls_result-%key
                        %msg = new_message(
                                 id       = 'ZAKP_MSG'
                                 number   = 010
                                 severity = if_abap_behv_message=>severity-error
*                                 v1       =
*                                 v2       =
*                                 v3       =
*                                 v4       =
                               ) ) TO reported-zi_project.
      ELSEIF ls_result-BeginDate GT ls_result-EndDate.
        APPEND VALUE #( %key = ls_result-%key
                        id = ls_result-Id  ) TO failed-zi_project.
        APPEND VALUE #( %key = ls_result-%key
                        %msg = new_message(
                                 id       = 'ZAKP_MSG'
                                 number   = 011
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = ls_result-EndDate
                                 v2       = ls_result-BeginDate
                                 v3       = ls_result-ProjectId
*                                 v4       =
                                            )
                        ) TO reported-zi_project.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
