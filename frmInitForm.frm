VERSION 5.00
Begin VB.Form frmInitForm 
   Caption         =   "Load Form"
   ClientHeight    =   870
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3720
   LinkTopic       =   "Form1"
   ScaleHeight     =   870
   ScaleWidth      =   3720
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command2 
      Caption         =   "Load Form"
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Top             =   240
      Width           =   1455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Load MDI Form"
      Height          =   375
      Left            =   2040
      TabIndex        =   0
      Top             =   240
      Width           =   1455
   End
End
Attribute VB_Name = "frmInitForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Load frmMDIForm
    frmMDIForm.Show
    Me.SetFocus
End Sub

Private Sub Command2_Click()
    Load frmForm
    frmForm.Show
    Me.SetFocus
End Sub
