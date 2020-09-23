VERSION 5.00
Begin VB.UserControl ucTransparency 
   ClientHeight    =   675
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1275
   InvisibleAtRuntime=   -1  'True
   ScaleHeight     =   675
   ScaleWidth      =   1275
   ToolboxBitmap   =   "ucTransparency.ctx":0000
   Begin VB.Timer tmrFade 
      Left            =   480
      Top             =   120
   End
   Begin VB.Image Image1 
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Left            =   0
      Picture         =   "ucTransparency.ctx":0312
      Stretch         =   -1  'True
      Top             =   0
      Width           =   360
   End
End
Attribute VB_Name = "ucTransparency"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'+  File Description:
'       ucTransparency - UserControl that Fades the ParentForm
'                        on Load / Close Events
'
'   Product Name:
'       ucTransparency.ctl
'
'   Compatability:
'       Windows: 2000, XP
'
'   Software Developed by:
'       Paul R. Territo, Ph.D
'
'       Adapted from the following online article(s):
'       PCS Article(s) by Even Toder, but was deleted from PCS so there is no referece...
'       http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=33266&lngWId=1
'       http://www.mentalis.org/apilist/GetVersionEx.shtml
'
'   Legal Copyright & Trademarks:
'       Copyright © 2004, by Paul R. Territo, Ph.D, All Rights Reserved Worldwide
'       Trademark ™ 2004, by Paul R. Territo, Ph.D, All Rights Reserved Worldwide
'
'   Comments:
'       No claims or warranties are expressed or implied as to accuracy or fitness
'       for use of this software. Paul R. Territo, Ph.D shall not be liable
'       for any incidental or consequential damages suffered by any use of
'       this software.
'
'-  Modification(s) History:
'       04Apr05 - Initial ucTransparency UserControl finished
'       05Apr05 - Added support for MDI Forms in addition to SDI Forms
'
'   Force Declarations
Option Explicit

'   API Declarations
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Private Declare Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function UpdateLayeredWindow Lib "user32" (ByVal hWnd As Long, ByVal hdcDst As Long, pptDst As Any, psize As Any, ByVal hdcSrc As Long, pptSrc As Any, crKey As Long, ByVal pblend As Long, ByVal dwFlags As Long) As Long

'   API Constant Declarations
Private Const GWL_EXSTYLE = (-20)
Private Const LWA_ALPHA = &H2
Private Const LWA_COLORKEY = &H1
Private Const ULW_ALPHA = &H2
Private Const ULW_COLORKEY = &H1
Private Const ULW_OPAQUE = &H4
Private Const WS_EX_LAYERED = &H80000

'   Local Type Declarations
Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion As String * 128
End Type

'   Local Declarations
Private bAlreadyQueried     As Boolean
Private bLoad               As Boolean
Private bIsMDI              As Boolean
Private iTransCount         As Integer
Private m_AutoClose         As Boolean
Private m_SleepInterval     As Long
Private m_StepSize          As Long
Private m_UnloadOnComplete  As Boolean
Private OSVerInfo           As OSVERSIONINFO

'   Local Events Declarations
Private WithEvents ParentForm As Form
Attribute ParentForm.VB_VarHelpID = -1
Private WithEvents MDIParentForm As MDIForm
Attribute MDIParentForm.VB_VarHelpID = -1

Public Property Let AutoClose(Value As Boolean)
    m_AutoClose = Value
    PropertyChanged "AutoClose"
End Property

Public Property Get AutoClose() As Boolean
    AutoClose = m_AutoClose
End Property

Private Sub FadeIn()
    iTransCount = 0
    tmrFade.Interval = 5
    '   Enables the timer to start
    tmrFade.Enabled = True
End Sub

Private Sub FadeOut()
    iTransCount = 255
    tmrFade.Interval = 5
    '   Enables the timer to start
    tmrFade.Enabled = True
End Sub

Public Function isTransparent(ByVal hWnd As Long) As Boolean
    Dim Msg As Long
    
    '   Handle Errors Quietly
    On Error Resume Next
    
    Msg = GetWindowLong(hWnd, GWL_EXSTYLE)
    If (Msg And WS_EX_LAYERED) = WS_EX_LAYERED Then
        isTransparent = True
    Else
        isTransparent = False
    End If
    If Err Then
        isTransparent = False
    End If
End Function

Public Function MakeOpaque(ByVal hWnd As Long) As Long
    Dim Msg As Long
    
    '   Handle Errors Quietly
    On Error Resume Next
    
    Msg = GetWindowLong(hWnd, GWL_EXSTYLE)
    Msg = Msg And Not WS_EX_LAYERED
    SetWindowLong hWnd, GWL_EXSTYLE, Msg
    SetLayeredWindowAttributes hWnd, 0, 0, LWA_ALPHA
    MakeOpaque = 0
    If Err Then
        MakeOpaque = 2
    End If
End Function

Public Function MakeTransparent(ByVal hWnd As Long, iValue As Integer) As Long
    Dim Msg As Long
    
    '   Handle Errors Quietly
    On Error Resume Next
    
    If iValue < 0 Or iValue > 255 Then
        MakeTransparent = 1
    Else
        Msg = GetWindowLong(hWnd, GWL_EXSTYLE)
        Msg = Msg Or WS_EX_LAYERED
        SetWindowLong hWnd, GWL_EXSTYLE, Msg
        SetLayeredWindowAttributes hWnd, 0, iValue, LWA_ALPHA
        MakeTransparent = 0
    End If
    If Err Then
        MakeTransparent = 2
    End If
End Function

Private Sub MDIParentForm_KeyPress(KeyAscii As Integer)
    Unload ParentForm
End Sub

Private Sub MDIParentForm_Load()
    MDIParentForm.Visible = False
    '   Indicate we are loading
    bLoad = True
    '   Call the FadeOut method
    Call FadeIn
End Sub

Private Sub MDIParentForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    '   Make sure it only Fades once
    If Not bAlreadyQueried Then
        bAlreadyQueried = True
        '   Cancels any unload
        Cancel = True
        bLoad = False
        '   Call the FadeOut method
        Call FadeOut
    End If
End Sub

Private Sub ParentForm_KeyPress(KeyAscii As Integer)
    Unload ParentForm
End Sub

Private Sub ParentForm_Load()
    ParentForm.Visible = False
    '   Indicate we are loading
    bLoad = True
    '   Call the FadeOut method
    Call FadeIn
End Sub

Private Sub ParentForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    '   Make sure it only Fades once
    If Not bAlreadyQueried Then
        bAlreadyQueried = True
        '   Cancels any unload
        Cancel = True
        bLoad = False
        '   Call the FadeOut method
        Call FadeOut
    End If
End Sub

Public Property Get SleepInterval() As Long
    SleepInterval = m_SleepInterval
End Property

Public Property Let SleepInterval(Milliseconds As Long)
    m_SleepInterval = Milliseconds
    PropertyChanged "SleepInterval"
End Property

Public Property Get StepSize() As Long
    StepSize = m_StepSize
End Property

Public Property Let StepSize(Value As Long)
    m_StepSize = Value
    PropertyChanged "StepSize"
End Property

Private Sub tmrFade_Timer()
    If bLoad Then
        '   This section is used to make a form appear with
        '   decreasing transparency
        If iTransCount < (255 - m_StepSize) Then
            '   This keeps the ParentForm from suddenly appearing
            '   and then starting to FadeIn
            If iTransCount < m_StepSize Then
                If bIsMDI = False Then
                    ParentForm.Visible = False
                Else
                    MDIParentForm.Visible = False
                End If
            Else
                If bIsMDI = False Then
                    ParentForm.Visible = True
                Else
                    MDIParentForm.Visible = True
                End If
            End If
            '   Decreases the percentage of transparency
            iTransCount = iTransCount + m_StepSize
            If bIsMDI = False Then
                MakeTransparent ParentForm.hWnd, iTransCount
            Else
                MakeTransparent MDIParentForm.hWnd, iTransCount
            End If
        Else
            '   See if this is a splash form and needs to pause for
            '   a fixed about of time...
            If AutoClose = True Then
                '   Call the Sleep API Timer
                Sleep SleepInterval
                '   Now call the FadeOut routine with the correct properties
                '
                '   Make sure the parent form destroys on complete
                UnloadOnComplete = True
                '   We are Unloading.....
                bLoad = False
                '   Call the FadeOut method
                Call FadeOut
            End If
        End If
    Else
        '   This section is used to make a form disappear with
        '   increasing transparency
        If iTransCount > m_StepSize Then
            '   Increases the percentage of transparency
            iTransCount = iTransCount - m_StepSize
            If bIsMDI = False Then
                MakeTransparent ParentForm.hWnd, iTransCount
            Else
                MakeTransparent MDIParentForm.hWnd, iTransCount
            End If
        Else
            '   Stop the timer to save resources...
            '   This is important if one wants to leave the
            '   control active, but silent until application closure
            tmrFade.Interval = 0
            '   Disables the timer to end
            tmrFade.Enabled = False
            '   Are we unloading?
            If UnloadOnComplete Then
                If bIsMDI = False Then
                    ParentForm.Hide
                    Unload ParentForm
                Else
                    MDIParentForm.Hide
                    Unload MDIParentForm
                End If
            End If
        End If
    End If
End Sub

Public Property Get UnloadOnComplete() As Boolean
    UnloadOnComplete = m_UnloadOnComplete
End Property

Public Property Let UnloadOnComplete(bUnload As Boolean)
    m_UnloadOnComplete = bUnload
    PropertyChanged "UnloadOnComplete"
End Property

Private Sub UserControl_InitProperties()
    '   Setup the controls initial values
    With UserControl
        .Width = 360
        .Height = 360
    End With
    m_AutoClose = False
    m_StepSize = 5
    m_SleepInterval = 0
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    '   Read the few properties this control can cache
    
    '   Set the structure size
    OSVerInfo.dwOSVersionInfoSize = Len(OSVerInfo)
    '   Get the OS Version
    If GetVersionEx(OSVerInfo) <> 0 Then
        '   Do version checking...
        If OSVerInfo.dwMajorVersion >= 4 Then
            On Error Resume Next
            With PropBag
                m_AutoClose = .ReadProperty("AutoClose", False)
                m_SleepInterval = .ReadProperty("SleepInterval", 0)
                m_StepSize = .ReadProperty("StepSize", 5)
                m_UnloadOnComplete = .ReadProperty("UnloadOnComplete", True)
                If Ambient.UserMode = False Then Exit Sub
                '   Reference the parent form and start recieving events
                If Not TypeOf UserControl.Parent Is MDIForm Then
                    Set ParentForm = UserControl.Parent
                    bIsMDI = False
                Else
                    Set MDIParentForm = UserControl.Parent
                    bIsMDI = True
                End If
            End With
        Else
            Err.Raise 10000, Err.Source, "Windows OS Version Must be W2K or Greater."
        End If
    End If
End Sub

Private Sub UserControl_Resize()
    '   Force the control to have a specific size
    With UserControl
        .Width = 360
        .Height = 360
    End With
End Sub

Private Sub UserControl_Terminate()
    '   Make sure to clean up...
    Set ParentForm = Nothing
    Set MDIParentForm = Nothing
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    '   Write the few properties this control can cache
    On Error Resume Next
    With PropBag
        .WriteProperty "AutoClose", m_AutoClose, False
        .WriteProperty "SleepInterval", m_SleepInterval, 0
        .WriteProperty "StepSize", m_StepSize, 5
        .WriteProperty "UnloadOnComplete", m_UnloadOnComplete, True
    End With
End Sub


