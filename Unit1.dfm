object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'mainForm'
  ClientHeight = 273
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object studentListBox: TListBox
    Left = 32
    Top = 24
    Width = 289
    Height = 161
    ItemHeight = 15
    TabOrder = 0
  end
  object addStudentBtn: TButton
    Left = 32
    Top = 216
    Width = 105
    Height = 25
    Caption = 'Add Student'
    TabOrder = 1
    OnClick = addStudentBtnClick
  end
  object removeStudentBtn: TButton
    Left = 216
    Top = 216
    Width = 105
    Height = 25
    Caption = 'Remove Student'
    TabOrder = 2
    OnClick = removeStudentBtnClick
  end
  object lectureListBox: TListBox
    Left = 464
    Top = 24
    Width = 289
    Height = 161
    ItemHeight = 15
    TabOrder = 3
  end
  object addLectureBtn: TButton
    Left = 464
    Top = 216
    Width = 105
    Height = 25
    Caption = 'Add Lecture'
    TabOrder = 4
    OnClick = addLectureBtnClick
  end
  object removeLectureBtn: TButton
    Left = 648
    Top = 216
    Width = 105
    Height = 25
    Caption = 'Remove Lecture'
    TabOrder = 5
    OnClick = removeLectureBtnClick
  end
  object assignNoteBtn: TButton
    Left = 337
    Top = 96
    Width = 105
    Height = 25
    Caption = 'Assign Note'
    TabOrder = 6
    OnClick = assignNoteBtnClick
  end
end
