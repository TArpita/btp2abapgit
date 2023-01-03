CLASS lsc_zi_rapuxt_5559 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_rapuxt_5559 IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_UXTeam DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR UXTeam RESULT result.

    METHODS setActive FOR MODIFY
      IMPORTING keys FOR ACTION UXTeam~setActive RESULT result.

    METHODS changeSalary FOR DETERMINE ON SAVE
      IMPORTING keys FOR UXTeam~changeSalary.

    METHODS validateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR UXTeam~validateAge.

ENDCLASS.

CLASS lhc_UXTeam IMPLEMENTATION.

  METHOD get_instance_features.

    " Read the active flag of the existing members
    READ ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
        ENTITY UXTeam
          FIELDS ( Active ) WITH CORRESPONDING #( keys )
        RESULT DATA(members)
        FAILED failed.

    result =
      VALUE #(
        FOR member IN members

            LET status =   COND #( WHEN member-Active = abap_true
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )

                                      IN

            ( %tky                 = member-%tky
              %action-setActive = status
             ) ).

  ENDMETHOD.

  METHOD setActive.
    " Do background check
    " Check references
    " Onboard member

    MODIFY ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
        ENTITY UXTeam
          UPDATE
            FIELDS (  Active )
            WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Active = abap_true

                             ) )

       FAILED failed
       REPORTED reported.


    " Fill the response table
    READ ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
      ENTITY UXTeam
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    result = VALUE #( FOR member IN members
                        ( %tky   = member-%tky
                          %param = member ) ).



  ENDMETHOD.

  METHOD changeSalary.

    READ ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
    ENTITY UXTeam
     FIELDS ( Role ) WITH CORRESPONDING #( keys )
     RESULT DATA(members).

    LOOP AT members INTO DATA(member).

     AUTHORITY-CHECK OBJECT 'ZRAPUXT_AO'
                  ID 'ACTVT' FIELD '01'
                  ID 'ZRAPUXT_AF' FIELD member-Role .
       IF sy-subrc <> 0.
          DATA(rv_message) = 'Not authorized'.
        ENDIF.

      IF member-Role = 'UX Developer'.
        MODIFY ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
        ENTITY UXTeam
        UPDATE FIELDS ( Salary ) WITH VALUE #( (  %tky = member-%tky Salary = '7000' ) ).
      ENDIF.

      IF member-Role = 'UX Lead'.
        MODIFY ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
        ENTITY UXTeam
        UPDATE FIELDS ( Salary ) WITH VALUE #( (  %tky = member-%tky Salary = '9000' ) ).
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD validateAge.

    READ ENTITIES OF zi_rapuxt_5559 IN LOCAL MODE
     ENTITY UXTeam
     FIELDS ( Age ) WITH CORRESPONDING #( keys )
     RESULT DATA(members).

    LOOP AT members INTO DATA(member).
      IF member-Age < 21.
        APPEND VALUE #( %tky = member-%tky ) TO failed-uxteam.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
