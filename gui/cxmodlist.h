////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModList.h
//   Authors:   Richard Cooper

#ifndef     __CxModList_H__
#define     __CxModList_H__
#include    "crguielement.h"

 #include <wx/event.h>
 #include <wx/imaglist.h>
 #include <wx/listctrl.h>
 #define BASEMODLIST wxListCtrl

#include <string>
#include <vector>
using namespace std;

class CrModList;
class CxGrid;
class CcModelObject;

class CxModList : public BASEMODLIST
{
    public:
        int GetNumberSelected();
        void GetSelectedIndices( int * values );
        void InvertSelection();
        int m_ProgSelecting;
        string GetListItem(int item);
        string GetCell(int row, int col);
        void SelectAll(bool select);
        void AddRow ( int id, vector<string> & rowOfStrings, bool sel, bool dis);
        void Focus();
        static CxModList * CreateCxModList( CrModList * container, CxGrid * guiParent);
            CxModList( CrModList * container );
            ~CxModList();
        void    SetVisibleLines( int lines );
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddModList( void ) { mModListCount++; return mModListCount; };
        static void RemoveModList( void ) { mModListCount--; };
        int GetValue();
        void Update(int newsize) ;
        void CxEnsureVisible(CcModelObject* va);
        void StartUpdate();
        void EndUpdate();

    void ItemSelected ( wxListEvent & event );
    void ItemDeselected ( wxListEvent & event );
    void RightClick ( wxListEvent & event );
    void OnChar(wxKeyEvent & event );
    void HeaderClicked( wxListEvent & wxle );
    DECLARE_EVENT_TABLE()

        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int  mModListCount;
        int mItems;
        int mVisibleLines;

    private:
        void AddCols() ;
        int m_numcols;
        int  m_nHighlight;              // Indicate type of selection highlighting
        vector<int> IDlist;
protected:
    vector<int> m_colWidths;
#define COL_INT 1
#define COL_REAL 2
#define COL_TEXT 3
    vector<int> m_colTypes;

    int WhichType(const string & text);


    int nSortedCol;
    bool bSortAscending;
    bool CxSortItems( int colType, int nCol, bool bAscending);

};
#endif
