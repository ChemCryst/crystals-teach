////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.13  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.12  2001/06/17 14:26:38  richard
//   Re-jig window creation.
//   New CxDestroyWindow function to ensure correct destruction sequence.
//   wx Support for toolbars.
//
//   Revision 1.11  2001/03/27 15:15:01  richard
//   Added a timer to the main window that is activated as the main window is
//   created.
//   The timer fires every half a second and causes any messages in the
//   CRYSTALS message queue to be processed. This is not the main way that messages
//   are found and processed, but sometimes the program just seemed to freeze and
//   would stay that way until you moved the mouse. This should (and in fact, does
//   seem to) remedy that problem.
//   Good good good.
//
//   Revision 1.10  2001/03/08 15:59:29  richard
//   Give non-modal windows a "toolbar-style" (thin) titlebar. Distinguishes them
//   from modal windows in users mind (eventually).
//

#ifndef     __CxWindow_H__
#define     __CxWindow_H__
//Insert your own code here.
#include    "crguielement.h"
#include    "crwindow.h"
#include    "cxbutton.h"

#ifdef __BOTHWX__
#include <wx/frame.h>
#include <wx/window.h>
#include <wx/settings.h>
#include <wx/menu.h>
#include <wx/menuitem.h>
#define BASEWINDOW wxFrame
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEWINDOW CFrameWnd
#endif

class CxMenuBar;

class CxWindow : public BASEWINDOW
{
  public:
     static CxWindow *   CreateCxWindow( CrWindow * container, void * parentWindow, int attributes );
     CxWindow( CrWindow * container, int sizeable );
     ~CxWindow();
        void CxDestroyWindow();

     void SetGeometry( int top, int left, int bottom, int right );
     int GetTop();
     int GetLeft();
     int GetScreenTop();
     int GetScreenLeft();
     int GetWidth();
     int GetHeight();

     void AdjustSize( CcRect * clientSize );
     void SetMainMenu(CxMenuBar* menu);
     void SetText( char * text );
     void SetDefaultButton( CxButton * inButton );

     void Focus();
     void Hide();
     void CxShowWindow();
     void CxEnable(bool state=true);
     void Redraw();
     void CxPreDestroy();
     void CxSetTimer();

// attributes
     CrGUIElement *  ptr_to_crObject;
     CxButton * mDefaultButton;
     Boolean mWindowWantsKeys;
  private:
     Boolean mSizeable;
     static int mWindowCount;
     bool m_PreDestroyed;
     UINT m_TimerActive;
  protected:
     Boolean mProgramResizing;

  public:
//PRIVATE MS WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES
#ifdef __CR_WIN__
    BOOL PreCreateWindow(CREATESTRUCT& cs);
    afx_msg void OnClose();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnGetMinMaxInfo(MINMAXINFO FAR* lpMMI);
    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnUpdateMenuItem(CCmdUI* pCmdUI);
    afx_msg void OnUpdateTools(CCmdUI* pCmdUI);
    afx_msg LRESULT OnMyNcPaint(WPARAM wparam, LPARAM lparam);
    afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnMenuSelected(int nID);
    afx_msg void OnToolSelected(int nID);
    afx_msg void OnTimer(UINT nID);
    afx_msg BOOL OnEraseBkgnd(CDC* pDC);

    DECLARE_MESSAGE_MAP()

  protected:
    CWnd* mParentWnd;
    BOOL CxWindow::PreTranslateMessage(MSG* pMsg);

#endif


#ifdef __BOTHWX__

      void OnClose( wxCloseEvent & event );
      void OnSize ( wxSizeEvent & event );
      void OnChar ( wxKeyEvent & event );
      void OnMenuSelected(wxCommandEvent &event );
      void OnToolSelected(wxCommandEvent &event );
      void OnUpdateMenuItem(wxUpdateUIEvent &event );
      void OnKeyDown( wxKeyEvent & event );
      void OnKeyUp( wxKeyEvent & event );

      DECLARE_EVENT_TABLE()


  protected:
    wxWindow* mParentWnd;
#endif

};
#endif
