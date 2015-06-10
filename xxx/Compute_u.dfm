object DlgCompute: TDlgCompute
  Left = 192
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Compute optilmal compression'
  ClientHeight = 265
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LZMAChart: TChart
    Left = 8
    Top = 8
    Width = 400
    Height = 250
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    LeftWall.Brush.Color = clWhite
    Title.Text.Strings = (
      'LZMA optimal compression (the higher the greater compression)')
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.ExactDateTime = False
    LeftAxis.Increment = 1.000000000000000000
    LeftAxis.Maximum = 100.000000000000000000
    LeftAxis.Title.Caption = 'Compress ratio'
    Legend.ShadowSize = 1
    Legend.Visible = False
    BevelInner = bvLowered
    TabOrder = 0
    object Level: TBarSeries
      Marks.ArrowLength = 20
      Marks.Style = smsValue
      Marks.Visible = True
      SeriesColor = clRed
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object BtnOk: TBitBtn
    Left = 416
    Top = 232
    Width = 73
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 496
    Top = 232
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BtnCancelClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object gbOptions: TGroupBox
    Left = 416
    Top = 8
    Width = 153
    Height = 105
    Caption = 'Options'
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 34
      Height = 13
      Caption = 'Priority:'
    end
    object cbPriority: TComboBox
      Left = 8
      Top = 40
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 0
      Text = 'Normal'
      Items.Strings = (
        'Idle'
        'Lowest'
        'Normal'
        'High'
        'Real time')
    end
    object btnCompute: TBitBtn
      Left = 8
      Top = 72
      Width = 137
      Height = 25
      Caption = 'Compute now!'
      TabOrder = 1
      OnClick = btnComputeClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF84848400000000000000000000000000000000
        0000000000000000000000000000000000000000848484FFFFFFFFFFFF000000
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0000000FFFFFFFFFFFF000000F0F0F0F0F0F0000000000000F0F0F000
        0000000000F0F0F0000000000000F0F0F0F0F0F0000000FFFFFFFFFFFF000000
        F0F0F0F0F0F0000000000000F0F0F0000000000000F0F0F0000000000000F0F0
        F0F0F0F0000000FFFFFFFFFFFF000000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000000FFFFFFFFFFFF000000
        F0F0F0F0F0F0000000000000F0F0F0000000000000F0F0F0000000000000F0F0
        F0F0F0F0000000FFFFFFFFFFFF000000F0F0F0F0F0F0000000000000F0F0F000
        0000000000F0F0F0000000000000F0F0F0F0F0F0000000FFFFFFFFFFFF000000
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0000000FFFFFFFFFFFF000000F0F0F0840000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000F0F0F0000000FFFFFFFFFFFF000000
        F0F0F0840000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00F0F0F0000000FFFFFFFFFFFF000000F0F0F0840000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000F0F0F0000000FFFFFFFFFFFF000000
        F0F0F08400008400008400008400008400008400008400008400008400008400
        00F0F0F0000000FFFFFFFFFFFF000000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000000FFFFFFFFFFFF848484
        0000000000000000000000000000000000000000000000000000000000000000
        00000000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    end
  end
  object gbCurrentMode: TGroupBox
    Left = 416
    Top = 120
    Width = 153
    Height = 105
    Caption = 'Current mode'
    TabOrder = 4
  end
end
