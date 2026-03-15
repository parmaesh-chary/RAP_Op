CLASS zakp_boolean_fill DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zakp_boolean_fill IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA : lt_boolean TYPE TABLE OF zakp_boolean.
    lt_boolean = VALUE #(
                      ( type = 'Y' value = 'Yes' )
                      ( type = 'N' value = 'No' )
                      ).
    MODIFY zakp_boolean FROM TABLE @lt_boolean.

    IF sy-subrc EQ 0.
      COMMIT WORK.
      out->write(
        EXPORTING
          data   = lt_boolean
*        name   =
*      RECEIVING
*        output =
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
