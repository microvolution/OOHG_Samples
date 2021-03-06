/*
 * Determinar las DATAs, METHODs e INLINEs de una clase dada.
 * Autor: Fernando Yurisich <fernando.yurisich@gmail.com>
 * Licenciado bajo The Code Project Open License (CPOL) 1.02
 * Ver <http://www.codeproject.com/info/cpol10.aspx>
 *
 * Basado en una contribución de Teo (user tfonfouge)
 * publicada en harbour-users@googlegroups.com
 *
 * Este ejemplo muestra como determinar las DATAs, METHODs
 * e INLINEs de una clase data. Vea las funciones DoMethod,
 * _OOHG_HasMethod and _OOHG_HasData en source/h_controlmisc.prg
 *
 * Visítenos en https://github.com/fyurisich/OOHG_Samples o en
 * http://oohg.wikia.com/wiki/Object_Oriented_Harbour_GUI_Wiki
 */

#include "hbclass.ch"
#include "hboo.ch"

FUNCTION Main()
   LOCAL obj
   LOCAL aObjs
   LOCAL itm

   aObjs := { MyClass1():New(), MyClass2():New() }

   FOR EACH obj IN aObjs
      ? obj:ClassName
      ? "nNumber( 3 ) = ", obj:nNumber( 3 )
      FOR EACH itm IN __objGetMsgType( obj, ;
                                       HB_OO_MSG_DATA, ;
                                       HB_OO_CLSTP_EXPORTED, ;
                                       .F. )
         ? "Data:", itm
      NEXT
      FOR EACH itm IN __objGetMsgType( obj, ;
                                       HB_OO_MSG_METHOD, ;
                                       HB_OO_CLSTP_EXPORTED, ;
                                       .F. )
         ? "Method:", itm
      NEXT
      FOR EACH itm IN __objGetMsgType( obj, ;
                                       HB_OO_MSG_INLINE, ;
                                       HB_OO_CLSTP_EXPORTED, ;
                                       .F. )
         ? "Inline:", itm
      NEXT
      ?
   NEXT
RETURN NIL

CLASS MyClass1
   DATA _otherData
   DATA cText INIT "Default Text"
   DATA nNumber INIT 0
   METHOD _Now() INLINE Date()
   METHOD _Tomorrow() INLINE ::_Now() + 1
PROTECTED:
   DATA Prot1
ENDCLASS

CLASS MyClass2 FROM MyClass1
   DATA aValues INIT {0,1,2,3,4}
   DATA cTime INIT time()
   METHOD cText SETGET
   METHOD nNumber
ENDCLASS

METHOD FUNCTION cText( cNewText ) CLASS MyClass2
RETURN IIF( empty( cNewText ), ::cTime, ::cTime := time() )

METHOD FUNCTION nNumber( nItem ) CLASS MyClass2
RETURN ::aValues[ nItem ] := nItem * 2

STATIC FUNCTION __objGetMsgType( obj, msgType, msgScope, filtSuper )
   LOCAL itm
   LOCAL aClsSel
   LOCAL a := {}

   IF msgScope = NIL
      msgScope := 0
   ENDIF

   aClsSel := obj:ClassSel( HB_MSGLISTPURE, msgScope, .T. )

   FOR EACH itm IN aClsSel
      IF !filtSuper == .T. .OR. ;
         HB_BitAnd( itm[ HB_OO_DATA_SCOPE ], HB_OO_CLSTP_SUPER ) = 0
            IF msgType = NIL .OR. itm[ HB_OO_DATA_TYPE ] = msgType
               AAdd( a, itm[ HB_OO_DATA_SYMBOL ] )
            ENDIF
      ENDIF
   NEXT
RETURN a

/*
 * EOF
 */
