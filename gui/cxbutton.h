////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#ifndef		__CxButton_H__
#define		__CxButton_H__
//Insert your own code here.
#include	"crguielement.h"

#ifdef __POWERPC__
class LStdButton;
#endif

#ifdef __MOTO__
#include	<LStdControl.h>
#endif

#ifdef __LINUX__
#include <wx/button.h>
#include <wx/event.h>
#define BASEBUTTON wxButton
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASEBUTTON CButton
#endif

class CrButton;
class CxGrid;
//End of user code.         
 
class CxButton : public BASEBUTTON
{
// The interface exposed to the CrClass
	public:
		void Disable(Boolean disabled);
		void Focus();
		// methods
		static CxButton *	CreateCxButton( CrButton * container, CxGrid * guiParent );
		CxButton(CrButton* container);
		~CxButton();
		void	SetText( char * text );
		void	SetGeometry( int top, int left, int bottom, int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int AddButton( void ) { mButtonCount++; return mButtonCount; };
		static void RemoveButton( void ) { mButtonCount--; };
		void	BroadcastValueMessage( void );
		void SetDefault();
		
		// attributes
		CrGUIElement *	mWidget;
		static int mButtonCount;
//		LDefaultOutline * mOutlineWidget;


// Private machine specific parts:
#ifdef __WINDOWS__
		afx_msg void ButtonClicked();
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		DECLARE_MESSAGE_MAP()
#endif
#ifdef __LINUX__
            void ButtonClicked();
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
