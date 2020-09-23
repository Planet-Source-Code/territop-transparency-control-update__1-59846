VERSION 5.00
Begin VB.Form frmForm 
   Caption         =   "Standard SDI Form"
   ClientHeight    =   1425
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4725
   LinkTopic       =   "Form2"
   ScaleHeight     =   1425
   ScaleWidth      =   4725
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Height          =   1395
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4665
      Begin Project1.ucTransparency ucTransparency2 
         Left            =   4320
         Top             =   1080
         _ExtentX        =   635
         _ExtentY        =   635
         UnloadOnComplete=   0   'False
      End
      Begin VB.Image imgLogo 
         Height          =   720
         Left            =   360
         Picture         =   "frmForm.frx":0000
         Top             =   360
         Width           =   720
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
         TabIndex        =   3
         Top             =   360
         Width           =   3075
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
      Begin VB.Label LoadLabel 
         BackStyle       =   0  'Transparent
         Caption         =   "Initilizing: Standard SDI Form, Please Wait"
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
         TabIndex        =   1
         Top             =   840
         Width           =   3255
      End
   End
   Begin Project1.ucTransparency ucTransparency1 
      Left            =   4200
      Top             =   2760
      _ExtentX        =   635
      _ExtentY        =   635
   End
End
Attribute VB_Name = "frmForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
