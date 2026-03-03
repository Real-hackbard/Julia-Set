object Form1: TForm1
  Left = 301
  Top = 258
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Simple Mandelbrot Calculator'
  ClientHeight = 627
  ClientWidth = 894
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 894
    Height = 576
    Align = alClient
  end
  object Panel1: TPanel
    Left = 0
    Top = 576
    Width = 894
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    TabOrder = 0
    object Label1: TLabel
      Left = 520
      Top = 20
      Width = 71
      Height = 14
      Caption = 'Iterations :'
    end
    object Button1: TButton
      Left = 696
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Draw'
      TabOrder = 0
      TabStop = False
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 600
      Top = 16
      Width = 81
      Height = 22
      TabStop = False
      TabOrder = 1
      Text = '240'
    end
    object Button2: TButton
      Left = 800
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 2
      TabStop = False
      OnClick = Button2Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Bitmap (*.bmp)|*.bmp'
    Left = 48
    Top = 32
  end
end
