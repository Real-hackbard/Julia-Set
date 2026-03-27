unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, Buttons, Spin, XPMan;

type
  TForm1 = class(TForm)
    pnlData: TPanel;
    Button1: TButton;
    PaintBox1: TPaintBox;
    Panel2: TPanel;
    MainMenu1: TMainMenu;
    cmFile: TMenuItem;
    cmExit: TMenuItem;
    ColorDialog1: TColorDialog;
    Button2: TBitBtn;
    Computation1: TMenuItem;
    cmCompute: TMenuItem;
    cmInterrupt: TMenuItem;
    cmResetValues: TMenuItem;
    N1: TMenuItem;
    cmOpenImage: TMenuItem;
    cmSaveImageAs: TMenuItem;
    N2: TMenuItem;
    SaveDlg: TSaveDialog;
    OpenDlg: TOpenDialog;
    RadioGroup1: TRadioGroup;
    N3: TMenuItem;
    cmOpenSeriesofImages: TMenuItem;
    Timer: TTimer;
    gbData: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    SpinEdit1: TSpinEdit;
    gbSave: TGroupBox;
    chkProgrSave: TCheckBox;
    Edit9: TEdit;
    Button3: TButton;
    Button4: TButton;
    gbPalette: TGroupBox;
    btnReset: TSpeedButton;
    btnRandom: TSpeedButton;
    Panel3: TPanel;
    PaintBox2: TPaintBox;
    Label2: TLabel;
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure cmExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cmInterruptClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmResetValuesClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure cmSaveImageAsClick(Sender: TObject);
    procedure cmOpenImageClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure chkProgrSaveClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cmOpenSeriesofImagesClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnRandomClick(Sender: TObject);
    procedure cmComputeClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
      procedure ComputeColors;
      procedure ResetMandel;
      procedure ResetJulia;
  public
    { Public declarations }
      backBMP  : TBitmap;
      mandBMP,
      julBMP   : TBitmap;
      Mandel   : boolean;
      DoQuit   : boolean;
      mbdown   : boolean;
      mbx,mby  : integer;
      Colors   : array[0..2048] of integer;
      ProgrSave,ProgrLoad : integer;
      GoingUp             : boolean;
  end;

const
    MAX_CONTROL_COLORS = 5;

type
    TColorArray = array[1..MAX_CONTROL_COLORS] of TColor;

const
    DefaultControlColors : TColorArray = ($200000,$FFFFFF,$FF0000,$FFFF40,$2020FF);

var
    ControlColors : TColorArray = ($200000,$FFFFFF,$FF0000,$FFFF40,$2020FF);
    MandelParams  : array[1..4] of double = (-1.5, 1.5, -2.25, 0.75);
    JuliaParams   : array[1..6] of double = (-1.8, 1.8, -1.8, 1.8, -0.56, 0.64);

var
  Form1: TForm1;

implementation

uses UGlobals;

{$R *.DFM}

{ --------------------------------------------------------------------------- }
{ ---- Private Methods ------------------------------------------------------ }
{ --------------------------------------------------------------------------- }

procedure TForm1.ComputeColors;
var
    i,k                                 : integer;
    r1,g1,b1,r2,g2,b2,rstep,gstep,bstep : real;

begin
    Colors[0] := 0;
    for i := 1 to MAX_CONTROL_COLORS-1 do
    begin
        b1 := (ControlColors[i] div 65536) mod 256;
        g1 := (ControlColors[i] div 256) mod 256;
        r1 := ControlColors[i] mod 256;
        b2 := (ControlColors[i+1] div 65536) mod 256;
        g2 := (ControlColors[i+1] div 256) mod 256;
        r2 := ControlColors[i+1] mod 256;
        rstep := (r2-r1)/63;
        gstep := (g2-g1)/63;
        bstep := (b2-b1)/63;
        for k := 1 to 64 do
            Colors [k+(i-1)*64] := RGB(Round(r1+rstep*(k-1)),
                                       Round(g1+gstep*(k-1)),
                                       Round(b1+bstep*(k-1)));
    end;
    for i := 257 to 2048 do
        Colors[i] := Colors[i-256];
end;

procedure TForm1.ResetMandel;
begin
    Edit2.Text := '100';
    Edit3.Text := '-1.5';
    Edit4.Text := '1.5';
    Edit5.Text := '-2.25';
    Edit6.Text := '0.75';
end;

procedure TForm1.ResetJulia;
begin
    Edit3.Text := '-1.8';
    Edit4.Text := '1.8';
    Edit5.Text := '-1.8';
    Edit6.Text := '1.8';
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Private Methods ----------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Constructors, Destructors -------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TForm1.FormCreate(Sender: TObject);
begin
    ControlColors := DefaultControlColors;
    ComputeColors;
    Mandel := true;
    ProgrSave := 0;
    Edit9.Text := StartUpDir;
    backBMP := TBitmap.Create;
    backBMP.Width := 360;
    backBMP.Height := 360;
    mandBMP := TBitmap.Create;
    mandBMP.Width := 360;
    mandBMP.Height := 360;
    julBMP := TBitmap.Create;
    julBMP.Width := 360;
    julBMP.Height := 360;
    mbdown := false;
    PaintBox1.Canvas.Pen.Color := clwhite;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DoQuit := true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    cmComputeClick (nil);
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Constructors, Destructors ------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Form Events ---------------------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- End of Form Events --------------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Menu Commands -------------------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TForm1.cmOpenImageClick(Sender: TObject);
var
    helpBMP : TBitmap;
begin
    if OpenDlg.Execute then
    begin
        helpBMP := TBitmap.Create;
        try
            helpBMP.LoadFromFile (OpenDlg.Filename);
            backBMP.Canvas.Draw (0,0,helpBMP);
            PaintBox1.Canvas.Draw (0,0,backBMP);
        finally
            helpBMP.Free;
        end;
    end;
end;

procedure TForm1.cmSaveImageAsClick(Sender: TObject);
begin
    if SaveDlg.Execute then
    begin
        backBMP.SaveToFile (SaveDlg.Filename);
    end;
end;

procedure TForm1.cmOpenSeriesofImagesClick(Sender: TObject);
begin
    Timer.Enabled := true;
    ProgrLoad := 0;
    GoingUp := true;
end;

procedure TForm1.cmExitClick(Sender: TObject);
begin
    Close;
end;

procedure TForm1.cmResetValuesClick(Sender: TObject);
begin
    SpinEdit1.Value := 256;
    case RadioGroup1.ItemIndex of
    0 : ResetMandel;
    1 : ResetJulia;
    end;
    cmComputeClick(nil);
end;

procedure TForm1.cmComputeClick(Sender: TObject);
var
   Pmin,Pmax,Qmin,Qmax,JRe,JIm,
   x,y,x0,y0,xStep,yStep,r,p,q  : double;
   sx,sy,k,m,Kmax ,Result,limit : integer;

begin
    Button1.Enabled := false;
    Button2.Enabled := true;
    DoQuit := false;
    Kmax := SpinEdit1.Value;
    Val(Edit2.Text,M,Result);
    Val(Edit3.Text,Qmin,Result);
    Val(Edit4.Text,Qmax,Result);
    Val(Edit5.Text,Pmin,Result);
    Val(Edit6.Text,Pmax,Result);
    Val(Edit7.Text,JRe,Result);
    Val(Edit8.Text,JIm,Result);
    xStep := (Pmax-Pmin)/360;
    yStep := (Qmax-Qmin)/360;
    case Mandel of
    true  : begin
                limit := 359;
                if QMin = -QMax then
                    limit := 180;
                for sx := 0 to 359 do
                begin
                   for sy := 0 to limit do
                   begin
                       p := Pmin + xStep*sx;
                       q := Qmax - yStep*sy;
                       k := 0;
                       x0 := 0;
                       y0 := 0;
                       repeat
//                           x := x0*x0*x0*x0+y0*y0*y0*y0-6*x0*x0*y0*y0+p;
//                           y := 4*x0*y0*(x0*x0-y0*y0)+q;
//                           x := x0*x0*x0-3*x0*y0*y0+p;
//                           y := 2*x0*x0*y0+x0*x0*y0-y0*y0*y0+q;
                           x := x0*x0 - y0*y0 + p;
                           y := 2*x0*y0 + q;
                           x0 := x;
                           y0 := y;
                           Inc(k);
                           r := Sqr(x)+Sqr(y);
                       until (r>M) or (k = KMax);
                       if k = KMax then
                           k := 0;
                       backBMP.Canvas.Pixels[sx,sy] := Colors[k];
                       if (limit = 180) and (sy <> limit) and (sy <> 0) then
                           backBMP.Canvas.Pixels[sx,360-sy] := Colors[k];
                   end;
                   Application.ProcessMessages;
                   if DoQuit then
                       Exit;
            //       if (sx+1) mod 10 = 0 then
                       PaintBox1.Canvas.Draw (0,0,backBMP);
               end;
            end;
    false : begin
                limit := 359;
                if QMin = -QMax then
                    limit := 180;
                for sx := 0 to 359 do
                begin
                   for sy := 0 to limit do
                   begin
                       p := Pmin + xStep*sx;
                       q := Qmax - yStep*sy;
                       k := 0;
                       x0 := p;
                       y0 := q;
                       repeat
                           x := x0*x0 - y0*y0 + JRe;
                           y := 2*x0*y0 + JIm;
                           x0 := x;
                           y0 := y;
                           Inc(k);
                           r := Sqr(x)+Sqr(y);
                       until (r>M) or (k = KMax);
                       if k = KMax then
                           k := 0;
                       backBMP.Canvas.Pixels[sx,sy] := Colors[k];
                       if (limit = 180) and (sy <> limit) and (sy <> 0) then
                           backBMP.Canvas.Pixels[359-sx,360-sy] := Colors[k];
                   end;
                   Application.ProcessMessages;
                   if DoQuit then
                       Exit;
            //       if (sx+1) mod 10 = 0 then
                       PaintBox1.Canvas.Draw (0,0,backBMP);
               end;
            end;
    end;
    Button1.Enabled := true;
    Button2.Enabled := false;
    if chkProgrSave.Checked then
    begin
        backBMP.SaveToFile (Edit9.Text+StrStringZero(ProgrSave,8,0)+'.BMP');
        Inc (ProgrSave);
    end;
    if Mandel then
    begin
        mandBMP.Canvas.Draw (0,0,backBMP);
        MandelParams[1] := QMin;
        MandelParams[2] := QMax;
        MandelParams[3] := PMin;
        MandelParams[4] := PMax;
    end
    else
    begin
        julBMP.Canvas.Draw (0,0,backBMP);
        JuliaParams[1] := QMin;
        JuliaParams[2] := QMax;
        JuliaParams[3] := PMin;
        JuliaParams[4] := PMax;
        JuliaParams[5] := JRe;
        JuliaParams[6] := JIm;
    end;
end;

procedure TForm1.cmInterruptClick(Sender: TObject);
begin
    DoQuit := true;
    Button2.Enabled := false;
    Button1.Enabled := true;
end;


{ --------------------------------------------------------------------------- }
{ ---- End of Menu Commands ------------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Component Events ----------------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
    case RadioGroup1.ItemIndex of
    0 : Mandel := true;
    1 : Mandel := false;
    end;
    Edit7.Enabled := not Mandel;
    Edit8.Enabled := not Mandel;
    if Mandel then
    begin
        backBMP.Canvas.Draw (0,0,mandBMP);
        Edit3.Text := StrString (MandelParams[1],0,16);
        Edit4.Text := StrString (MandelParams[2],0,16);
        Edit5.Text := StrString (MandelParams[3],0,16);
        Edit6.Text := StrString (MandelParams[4],0,16);
    end
    else
    begin
        backBMP.Canvas.Draw (0,0,julBMP);
        Edit3.Text := StrString (JuliaParams[1],0,16);
        Edit4.Text := StrString (JuliaParams[2],0,16);
        Edit5.Text := StrString (JuliaParams[3],0,16);
        Edit6.Text := StrString (JuliaParams[4],0,16);
    end;
    PaintBox1.Canvas.Draw (0,0,backBMP);
end;

procedure TForm1.chkProgrSaveClick(Sender: TObject);
begin
    Button3.Enabled := chkProgrSave.Checked;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    ProgrSave := 0;
    backBMP.SaveToFile (Edit9.Text+StrStringZero(ProgrSave,8,0)+'.BMP');
    Inc (ProgrSave);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    if Timer.Enabled then
    begin
        Timer.Enabled := false;
        Button4.Caption := 'Playback';
    end
    else
    begin
        Timer.Enabled := true;
        ProgrLoad := 0;
        GoingUp := true;
        Button4.Caption := 'Stop Playback';
    end;
end;

procedure TForm1.btnResetClick(Sender: TObject);
begin
    ControlColors := DefaultControlColors;
    ComputeColors;
    PaintBox2.Invalidate;
end;

procedure TForm1.btnRandomClick(Sender: TObject);
var
    i : integer;

begin
    for i := 1 to MAX_CONTROL_COLORS do
        ControlColors[i] := RGB(Random(256),Random(256),Random(256));
    ComputeColors;
    PaintBox2.Invalidate;
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Component Events ---------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- PaintBox Events ------------------------------------------------------ }
{ --------------------------------------------------------------------------- }

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then
    begin
        mbdown := true;
        mbx := x;
        mby := y;
    end;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
   ny : integer;

begin
    if mbdown then
    begin
        PaintBox1.Canvas.Draw (0,0,backBMP);
//        BitBlt (pb.Canvas.Handle,0,0,360,360,backBMP.Handle,0,0,SRCCOPY);
        ny  := mby + (byte(y>mby)*2-1) * Round(360*Abs(x - mbx)/360);
        PaintBox1.Canvas.Brush.style := bsclear;
        PaintBox1.Canvas.Rectangle(mbx,mby,x,ny);
    end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ny,nx,help,result   : integer;
   Pmin,Pmax,Qmin,Qmax : double;
   PW,Qw,JRe,JIm       : double;
begin
    Val(Edit3.Text,Qmin,Result);
    Val(Edit4.Text,Qmax,Result);
    Val(Edit5.Text,Pmin,Result);
    Val(Edit6.Text,Pmax,Result);

    if Button = mbRight then
    begin
        if Mandel then
        begin
            JRe := PMin+x*(Pmax-Pmin)/360;
            JIm := QMin+(360-y)*(QMax-Qmin)/360;
            Edit7.Text := StrString (JRe,0,16);
            Edit8.Text := StrString (JIm,0,16);

            RadioGroup1.ItemIndex := 1;
            RadioGroup1Click(nil);
            ResetJulia;
            cmComputeClick(nil);
        end;
        Exit;
    end;

    if mbdown then
    begin
        if (Abs(X-mbx) <= 2) then
        begin
            mbdown := false;
            exit;
        end;
        BitBlt (PaintBox1.Canvas.Handle,0,0,360,360,
                backBMP.Canvas.Handle,0,0,SRCCOPY);
        mbdown := false;
        nx := x;
        ny  := mby + (byte(y>mby)*2-1) * Round(360*Abs(x - mbx)/360);
        if nx < mbx then
        begin
            help := nx;
            nx := mbx;
            mbx := help;
        end;
        if ny < mby then
        begin
             help := ny;
             ny := mby;
             mby := help;
        end;
        PW := Pmax-Pmin;
        Pmin := Pmin + mbx*PW/360;
        Pmax := Pmax -(360-nx)*PW/360;
        QW := Qmax-Qmin;
        Qmin := Qmin + (360 - ny)*QW/360;
        Qmax := Qmax - mby*QW/360;
        Edit5.Text := StrString (PMin,0,16);
        Edit6.Text := StrString (PMax,0,16);
        Edit3.Text := StrString (QMin,0,16);
        Edit4.Text := StrString (QMax,0,16);
        cmComputeClick(nil);
    end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
    PaintBox1.Canvas.Draw (0,0,backBMP);
end;

procedure TForm1.PaintBox2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i : byte;

begin
    i := Round (x/PaintBox2.Width*4)+1;
    ColorDialog1.Color := ControlColors[i];
    if ColorDialog1.Execute then
    begin
        ControlColors[i] := ColorDialog1.Color;
        ComputeColors;
        PaintBox2.Invalidate;
    end;
end;

procedure TForm1.PaintBox2Paint(Sender: TObject);
var
    i,KMax : integer;

begin
    Kmax := SpinEdit1.Value;
    for i := 0 to PaintBox2.Width do
    begin
        PaintBox2.Canvas.Pen.Color := Colors[Round(kMax*i/PaintBox2.Width)];
        PaintBox2.Canvas.MoveTo (i,0);
        PaintBox2.Canvas.LineTo (i,PaintBox2.Height);
    end;
end;

{ --------------------------------------------------------------------------- }
{ ---- End of PaintBox Events ----------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Protected Methods ---------------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- End of Protected Methods --------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Timer Methods -------------------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TForm1.TimerTimer(Sender: TObject);
var
    f : string;
    
begin
    f := Edit9.Text+StrStringZero(ProgrLoad,8,0)+'.bmp';
    if FileExists (f) then
    begin
        backBMP.LoadFromFile (f);
        PaintBox1.Canvas.Draw (0,0,backBMP);
        if GoingUp then
            Inc (ProgrLoad)
        else
        begin
            Dec (ProgrLoad);
            if ProgrLoad = -1 then
            begin
                GoingUp := true;
                ProgrLoad := 0;
            end;
        end;
    end
    else
    begin
        GoingUp := false;
        Dec (ProgrLoad);
    end;
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Timer Methods ------------------------------------------------- }
{ --------------------------------------------------------------------------- }


end.
