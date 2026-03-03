unit Unit1t;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, XPman;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    PaintBox1: TPaintBox;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
const
    superfarben: array[0..29] of longint =
         ($00000000,$00800000,$000000FF,$00FF00FF,$00008000,$00800080,$0000FFFF,$00404040,
          $0000FF00,$00cccccc,$00808080,$00ff0000,$00000080,$00ffff00,$00008080,$00c0c0c0,
          $00808000,$000000c0,$0000c000,$00c00000,$0000c0c0,$00c000c0,$00c0c000,$00FFFFCC,
          $00CCFFFF,$00CCFFCC,$00CCCCFF,$00ffffff,$00cccc99,$00123456);

procedure TForm1.Button1Click(Sender: TObject);
var
  bitmap:tbitmap;
  x,y,xneu,cx,cy,xa,ya,xbreite,yhoehe:double;
  i,j,iterationen,anzahl:integer;
  bildbreite,bildhoehe:integer;
begin
  Screen.Cursor := crHourGlass;
  // Create bitmap
  bitmap:=tbitmap.Create;
  bitmap.Width:=paintbox1.Width;
  bitmap.Height:=paintbox1.Height;
  // Starting values ??on the left and bottom + interval width x and y
  xa:=-2.5;
  ya:=-1.5;
  xbreite:=4;
  yhoehe:=3;
  // Iteration number
  iterationen := strtoint(Edit1.Text);
  // Image dimensions
  bildbreite:=bitmap.Width;
  bildhoehe:=bitmap.Height;
  // Two loops i = x and j = y
  for i:=0 to bildbreite do begin
    // Attention: y runs from top to bottom
    for j:=0 to bildhoehe do begin
      // Determine the coordinates of the point, i.e., cx and cy.
      cx:=i*xbreite/bildbreite + xa;
      cy:=j*yhoehe/bildhoehe + ya;
      // Calculations
      anzahl:=0;
      // Iteration counter
      x:=0;
      // Starting coordinate (0,0)
      y:=0;
      repeat
        xneu:=x*x-y*y+cx;
        // Real part
        y:=2*x*y+cy;
        // Imaginary part
        x:=xneu;
        inc(anzahl);
        // performed iterations
      until (x*x+y*y>4) or (anzahl>=iterationen);  // Termination at |z|>2
      // Select color
      bitmap.Canvas.Pixels[i,j]:=superfarben[anzahl mod 30];
    end;
    // Interim display of the already calculated image
    if i mod 100 = 0 then begin
      paintbox1.Canvas.draw(0,0,bitmap);
      application.ProcessMessages;
    end;
  end;
  // Copy bitmap
  paintbox1.Canvas.draw(0,0,bitmap);
  // Delete bitmap again
  bitmap.Free;
  Screen.Cursor := crDefault;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  if SaveDialog1.Execute then
  begin
    try
      Bitmap:=TBitmap.Create;
      Bitmap.PixelFormat := pf24bit;
      Bitmap.Width:=PaintBox1.Width;
      Bitmap.Height:=PaintBox1.Height;
      Bitmap.Canvas.CopyRect(Bounds(0,0,bitmap.Width, Bitmap.Height),
        PaintBox1.Canvas, PaintBox1.ClientRect);

      Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
    finally
      Bitmap.Free;
    end;
  end;
end;

end.
