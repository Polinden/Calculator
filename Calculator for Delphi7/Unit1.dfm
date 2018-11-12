object Form1: TForm1
  Left = 396
  Top = 188
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 3
  Caption = 'Calculator'
  ClientHeight = 515
  ClientWidth = 721
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clActiveBorder
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = True
  OnKeyPress = Test
  PixelsPerInch = 96
  TextHeight = 25
  object shp4: TShape
    Left = 554
    Top = 332
    Width = 145
    Height = 33
    Brush.Color = clBtnFace
    Pen.Color = clBtnShadow
    Pen.Width = 2
  end
  object shp3: TShape
    Left = 554
    Top = 282
    Width = 145
    Height = 33
    Brush.Color = clBtnFace
    Pen.Color = clBtnShadow
    Pen.Width = 2
  end
  object shp1: TShape
    Left = 552
    Top = 280
    Width = 145
    Height = 33
    Brush.Color = clBtnFace
    Pen.Color = clBtnHighlight
    Pen.Style = psInsideFrame
  end
  object Label1: TLabel
    Left = 18
    Top = 488
    Width = 167
    Height = 19
    Caption = 'Simbols on the screen: '
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 185
    Top = 488
    Width = 9
    Height = 19
    Caption = '1'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 217
    Top = 488
    Width = 74
    Height = 19
    Caption = 'Maximum '
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object shp2: TShape
    Left = 552
    Top = 330
    Width = 145
    Height = 33
    Brush.Color = clBtnFace
    Pen.Color = clBtnHighlight
    Pen.Style = psInsideFrame
  end
  object ImgPow: TImage
    Left = 552
    Top = 330
    Width = 153
    Height = 23
    Center = True
    Picture.Data = {
      055449636F6E0000010001000C0C000001002000980200001600000028000000
      0C00000018000000010020000000000040020000000000000000000000000000
      00000000000000000000001D000000B9000000CD000000CE000000D0000000D0
      000000D0000000CF000000480000000000000000000000000000000E000000A8
      000000FF000000C20000008D00000090000000900000008F0000003200000000
      00000000000000000000000000000015000000A6000000D80000004000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000012000000A4000000DE0000004200000000000000000000000000000000
      000000000000000000000000000000000000000000000011000000A9000000DB
      0000003500000000000000000000000000000000000000000000000000000000
      000000000000000000000018000000C1000000C5000000180000000000000000
      000000000000000000000000000000000000000000000000000000000000003A
      000000EB0000007C000000000000000000000000000000000000000000000000
      00000000000000000000000000000003000000AC000000CF0000001100000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008A000000E8000000220000000000000000000000000000000000000015
      0000000E000000000000000000000009000000B7000000D80000001600000000
      0000000000000000000000000000007F000000BB000000690000005A0000009F
      000000F70000007F000000000000000000000000000000000000000000000030
      000000A8000000EC000000FC000000ED0000008C000000100000000000000000
      000000008030000080300000C3F00000E1F00000F0F00000F8700000FC700000
      FC300000FE300000CC300000C0700000C0700000}
    Proportional = True
    Transparent = True
    OnClick = AllButtonsClick
  end
  object ImgSqrt: TImage
    Left = 558
    Top = 280
    Width = 139
    Height = 33
    Center = True
    Picture.Data = {
      055449636F6E0000010001001312000001002000C80500001600000028000000
      1300000024000000010020000000000058050000216002002160020000000000
      00000000000000000000000000000000000000000000001A000000D000000077
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000001
      00000084000000FA000000A10000000300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000045000000EA00000089000000A60000001A00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000017000000C7000000B50000000F
      0000009400000041000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000088
      000000E400000035000000000000006B00000071000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000500000005F000000EB0000007300000000000000000000003B00000099
      0000000400000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000045000000A8000000AC0000000E00000000
      0000000000000016000000A60000001A00000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000000C
      0000001400000000000000000000000000000002000000940000004200000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006900000072000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000003A00000099000000040000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000015000000A5
      0000001B00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000001000000920000004200000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000680000007200000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000003800000099000000040000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000014000000A50000001B0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000100000091
      0000004300000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000065000000790000000B0000000E0000000E0000000E
      0000000E0000000E0000000E0000000E00000000000000000000000000000000
      000000000000000000000000000000000000000000000037000000D4000000BF
      000000BF000000BF000000BF000000BF000000BF000000BF000000BFF1FFE000
      E0FFE000E0FFE000C0FFE000C4FFE0000C7FE0000C7FE0009C7FE000FE7FE000
      FE3FE000FE3FE000FE3FE000FF3FE000FF1FE000FF1FE000FF1FE000FF800000
      FF800000}
    Transparent = True
    OnClick = AllButtonsClick
  end
  object Button1: TButton
    Left = 370
    Top = 88
    Width = 145
    Height = 33
    Caption = '1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = AllButtonsClick
  end
  object ButtonPl: TButton
    Left = 554
    Top = 88
    Width = 145
    Height = 33
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = AllButtonsClick
  end
  object ButtonMn: TButton
    Left = 554
    Top = 136
    Width = 145
    Height = 33
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = AllButtonsClick
  end
  object ButtonEq: TButton
    Left = 554
    Top = 424
    Width = 145
    Height = 81
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = FinalCalculationButtonClick
  end
  object ButtonMl: TButton
    Left = 554
    Top = 184
    Width = 145
    Height = 33
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = AllButtonsClick
  end
  object Button2: TButton
    Left = 202
    Top = 136
    Width = 145
    Height = 33
    Caption = '2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = AllButtonsClick
  end
  object Button3: TButton
    Left = 370
    Top = 136
    Width = 145
    Height = 33
    Caption = '3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = AllButtonsClick
  end
  object Button4: TButton
    Left = 202
    Top = 184
    Width = 145
    Height = 33
    Caption = '4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = AllButtonsClick
  end
  object Button0: TButton
    Left = 202
    Top = 88
    Width = 145
    Height = 33
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = AllButtonsClick
  end
  object ButtonDv: TButton
    Left = 554
    Top = 232
    Width = 145
    Height = 33
    Caption = '/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = AllButtonsClick
  end
  object Button6: TButton
    Left = 202
    Top = 232
    Width = 145
    Height = 33
    Caption = '6'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = AllButtonsClick
  end
  object Button7: TButton
    Left = 370
    Top = 232
    Width = 145
    Height = 33
    Caption = '7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = AllButtonsClick
  end
  object Button8: TButton
    Left = 202
    Top = 280
    Width = 145
    Height = 33
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = AllButtonsClick
  end
  object Button5: TButton
    Left = 370
    Top = 184
    Width = 145
    Height = 33
    Caption = '5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = AllButtonsClick
  end
  object Button9: TButton
    Left = 370
    Top = 280
    Width = 145
    Height = 33
    Caption = '9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = AllButtonsClick
  end
  object ButtonDot: TButton
    Left = 18
    Top = 440
    Width = 145
    Height = 33
    Caption = ','
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    OnClick = AllButtonsClick
  end
  object ButtonDel: TButton
    Left = 26
    Top = 136
    Width = 145
    Height = 33
    Caption = '<-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 16
    OnClick = BackSpaceClick
  end
  object Panel1: TPanel
    Left = 18
    Top = 16
    Width = 679
    Height = 44
    BevelOuter = bvLowered
    BevelWidth = 4
    BorderWidth = 7
    BorderStyle = bsSingle
    Color = clNavy
    TabOrder = 17
    object Label4: TLabel
      Left = 14
      Top = 8
      Width = 11
      Height = 25
      Caption = '0'
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 18
    Top = 256
    Width = 145
    Height = 169
    Caption = 'Converter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 18
    object RadioButton1: TRadioButton
      Left = 16
      Top = 40
      Width = 80
      Height = 24
      Caption = 'Decimal'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = ConverterSwitch
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 80
      Width = 52
      Height = 24
      Caption = 'Hex'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ConverterSwitch
    end
    object RadioButton3: TRadioButton
      Left = 16
      Top = 124
      Width = 68
      Height = 24
      Caption = 'Binary'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ConverterSwitch
    end
  end
  object ButtonA: TButton
    Left = 202
    Top = 344
    Width = 145
    Height = 33
    Caption = 'A'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 19
    OnClick = AllButtonsClick
  end
  object ButtonB: TButton
    Left = 370
    Top = 344
    Width = 145
    Height = 33
    Caption = 'B'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 20
    OnClick = AllButtonsClick
  end
  object ButtonC: TButton
    Left = 202
    Top = 392
    Width = 145
    Height = 33
    Caption = 'C'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 21
    OnClick = AllButtonsClick
  end
  object ButtonD: TButton
    Left = 370
    Top = 392
    Width = 145
    Height = 33
    Caption = 'D'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 22
    OnClick = AllButtonsClick
  end
  object ButtonE: TButton
    Left = 202
    Top = 440
    Width = 145
    Height = 33
    Caption = 'E'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 23
    OnClick = AllButtonsClick
  end
  object ButtonF: TButton
    Left = 370
    Top = 440
    Width = 145
    Height = 33
    Caption = 'F'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 24
    OnClick = AllButtonsClick
  end
  object ButtonM: TButton
    Left = 16
    Top = 192
    Width = 49
    Height = 41
    Caption = 'MS'
    TabOrder = 25
    OnClick = ButtonMClick
  end
  object ButtonMr: TButton
    Left = 72
    Top = 192
    Width = 49
    Height = 41
    Caption = 'MR'
    TabOrder = 26
    OnClick = ButtonMrClick
  end
  object ButttonMc: TButton
    Left = 128
    Top = 192
    Width = 49
    Height = 41
    Caption = 'MC'
    TabOrder = 27
    OnClick = ButttonMcClick
  end
  object ButtonCe: TBitBtn
    Left = 26
    Top = 88
    Width = 145
    Height = 33
    Caption = 'CE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 28
    OnClick = CanselButtonClick
  end
  object MainMenu: TMainMenu
    Left = 120
    Top = 336
    object Info1: TMenuItem
      Caption = 'Info'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
end
