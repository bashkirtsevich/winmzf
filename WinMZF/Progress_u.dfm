object dlgProgress: TdlgProgress
  Left = 195
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Progress'
  ClientHeight = 161
  ClientWidth = 473
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
  object lbCurrent: TLabel
    Left = 16
    Top = 32
    Width = 3
    Height = 13
    Caption = ' '
  end
  object lbFileIndex: TLabel
    Left = 16
    Top = 17
    Width = 3
    Height = 13
    Caption = ' '
  end
  object lbTotal: TLabel
    Left = 16
    Top = 94
    Width = 3
    Height = 13
    Caption = ' '
  end
  object btnAbort: TBitBtn
    Left = 367
    Top = 112
    Width = 90
    Height = 33
    Caption = 'Abort'
    TabOrder = 0
    OnClick = btnAbortClick
    Glyph.Data = {
      36060000424D3606000000000000360000002800000020000000100000000100
      18000000000000060000C30E0000C30E00000000000000000000D8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000FF
      000099000099000099D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000FF0000990000
      99000099D8E9ECD8E9ECD8E9ECDCDCDC787878787878787878D8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECDCDCDC787878787878787878D8E9ECD8E9ECD8E9EC0000FF
      0000CC0000CC0000CC000099D8E9ECD8E9ECD8E9EC0000FF0000CC0000CC0000
      CC000099D8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8E9ECD8
      E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9EC
      0000FF0000CC0000CC0000CC000099D8E9EC0000FF0000CC0000CC0000CC0000
      99D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8
      E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9EC0000FF0000CC0000CC0000CC0000990000CC0000CC0000CC000099D8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B478
      7878B4B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9EC0000FF0000CC0000CC0000CC0000CC0000CC000099D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4
      B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9EC0000FF0000CC0000CC0000CC000099D8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4
      B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9EC0000FF0000CC0000CC0000CC0000CC0000CC000099D8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4
      B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9EC0000FF0000CC0000CC0000CC0000990000CC0000CC0000CC000099D8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B478
      7878B4B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      0000FF0000CC0000CC0000CC000099D8E9EC0000FF0000CC0000CC0000CC0000
      99D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8
      E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9ECD8E9EC0000FF
      0000CC0000CC0000CC000099D8E9ECD8E9ECD8E9EC0000FF0000CC0000CC0000
      CC000099D8E9ECD8E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8E9ECD8
      E9ECD8E9ECDCDCDCB4B4B4B4B4B4B4B4B4787878D8E9ECD8E9ECD8E9EC0000FF
      0000FF0000FF0000FFD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000FF0000FF0000
      FF0000FFD8E9ECD8E9ECD8E9ECDCDCDCDCDCDCDCDCDCDCDCDCD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECDCDCDCDCDCDCDCDCDCDCDCDCD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
      D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
      ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
      E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC}
    NumGlyphs = 2
  end
  object pbArchive: TProgressBar
    Left = 16
    Top = 112
    Width = 345
    Height = 33
    Smooth = True
    TabOrder = 1
  end
  object pbFile: TProgressBar
    Left = 16
    Top = 53
    Width = 441
    Height = 33
    Smooth = True
    TabOrder = 2
  end
end
