VERSION 5.00
Begin VB.MDIForm frmMDIForm 
   BackColor       =   &H8000000C&
   Caption         =   "Standard MDI Form"
   ClientHeight    =   1470
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4725
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Frame1 
      Align           =   1  'Align Top
      BackColor       =   &H00FFC0C0&
      Height          =   1605
      Left            =   0
      ScaleHeight     =   1545
      ScaleWidth      =   4665
      TabIndex        =   0
      Top             =   0
      Width           =   4725
      Begin Project1.ucTransparency ucTransparency2 
         Left            =   4320
         Top             =   1080
         _ExtentX        =   635
         _ExtentY        =   635
         AutoClose       =   -1  'True
         SleepInterval   =   1000
         UnloadOnComplete=   0   'False
      End
      Begin VB.Label LoadLabel 
         BackStyle       =   0  'Transparent
         Caption         =   "Initilizing: Standard MDI Form, Please Wait"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   1440
         TabIndex        =   3
         Top             =   840
         Width           =   3255
      End
      Begin VB.Label lblTitle 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Transparency Control"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   14.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   330
         Index           =   0
         Left            =   1215
         TabIndex        =   2
         Top             =   380
         Width           =   3075
      End
      Begin VB.Label lblTitleShadow 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Transparency Control"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   14.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   330
         Index           =   1
         Left            =   1200
         TabIndex        =   1
         Top             =   360
         Width           =   3075
      End
      Begin VB.Image imgLogo 
         Height          =   720
         Left            =   360
         Picture         =   "frmMDIForm.frx":0000
         Top             =   360
         Width           =   720
      End
   End
   Begin Project1.ucTransparency ucTransparency1 
      Left            =   4200
      Top             =   2760
      _ExtentX        =   635
      _ExtentY        =   635
   End
End
Attribute VB_Name = "frmMDIForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

