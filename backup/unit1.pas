unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, RegExpr, Strutils, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button0: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ButtonA: TButton;
    ButtonB: TButton;
    ButtonC: TButton;
    ButtonD: TButton;
    ButtonE: TButton;
    ButtonF: TButton;
    ButtonCe: TButton;
    ButtonPl: TButton;
    ButtonMn: TButton;
    ButtonMl: TButton;
    ButtonDv: TButton;
    ButtonEq: TButton;
    ButtonDel: TButton;
    ButtonDot: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure AfterConstruction; override;
    procedure AllButtonsClick(Sender: TObject);
    procedure CanselButtonClick(Sender: TObject);
    procedure FinalCalculationButtonClick(Sender: TObject);
    procedure BackSpaceClick(Sender: TObject);
    function Checker(s: String): Boolean;
    procedure ConwerterSwitch(Sender: TObject);
    function ConwertTo(d: Double): String;
    function ConwertFrom(s: String): Double;
    procedure BorderText();
  private

  public

  end;

  TOperation = class(TObject)
      v : Double;
      oper : String;
      next:   TOperation;
      function Action(d: Double)  : Double;
   end;


  TNumberSystem = (Dec=1, Hex=2, Bin=3);


var
  Form1: TForm1;
  Operation : TOperation;
  StopDot : boolean = false;
  OverflowError: boolean = false;
  NumberSystem, PrevNumberSystem : TNumberSystem;
  RadioButtons : array [1..3] of TRadioButton;
  DecimalButtons : array [1..9] of TButton;
  HeximalButtons : array [1..6] of TButton;


  //constants
  MAXNumberWidth : Integer =30;
  MAXpresision : Integer=16;
  MAXInt2Binary : Integer = 536870912;
  MAXInt2Hex : Int64 = 922337203685477;




implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.AllButtonsClick(Sender: TObject);
var   s, t: String;
begin
      if OverflowError then CanselButtonClick(Sender);
      s:= TButton(Sender).Caption;
      t:=Label4.Caption;
      if Checker(s) then exit;
      if t='0' then t:=s else t:=t+s;
      Label4.Caption:=t;
      BorderText;
end;



procedure TForm1.BackSpaceClick(Sender: TObject);
var t : String;
    c : Char;
begin
    if OverflowError then exit;
    t:=Label4.Caption;
    c:=t[t.Length-1];
    if c ='.' then StopDot:=false;
    //if codepoint then delete 2
    if ord(c)>80 then Delete(t, t.Length-1,2) else Delete(t, t.Length,1);
    if t=''  then t:='0';
    Label4.Caption:=t;
    BorderText;
end;



procedure TForm1.CanselButtonClick(Sender: TObject);
begin
      StopDot:=false;
      Label4.Caption:='0';
      OverflowError:=false;
      BorderText;
end;


procedure TForm1.FinalCalculationButtonClick(Sender: TObject);
var
  Act, Number, t : String;
  Pieces1, Pieces2 : TStrings;
  RegexObj1, RegexObj2: TRegExpr;
  CurOper : TOPeration;
  ResCount : Double;
begin
  if OverflowError then exit;

  //prevent format errors
  try
  try
    RegexObj1 := TRegExpr.Create;
    RegexObj2 := TRegExpr.Create;
    Pieces1 := TStringList.Create;
    Pieces2 := TStringList.Create;
    Operation:=TOperation.Create;

    t:=Label4.Caption;
    t:='0'+t;

    t:=StringReplace(t, '×','*', [rfReplaceAll]);
    t:=StringReplace(t, '÷','/', [rfReplaceAll]);
    RegexObj1.Expression := '[-/*+-]+';
    RegexObj2.Expression := '[\.0-9A-F]+';
    RegexObj1.Split(t, Pieces1);
    RegexObj2.Split(t, Pieces2);


    CurOper:=Operation;
    for Act in Pieces2 do
    begin
        if Act<>'' then
           begin
               CurOper.oper:=Act.Substring(0,1);
               CurOper.next:=TOperation.Create;
               CurOper:=CurOper.next;
           end;
    end;

    CurOper:=Operation;
    for Number in Pieces1 do
    begin
        if Number<>'' then
           begin
               CurOper.v:=ConwertFrom(Number);
               CurOper:=CurOper.next;
           end;
    end;


    CurOper:=Operation;
    ResCount:=CurOper.v;
    while (CurOper.next<>Nil) do
          begin
               ResCount:=CurOper.Action(ResCount);
               CurOper:=CurOper.next;
          end;


   t:= ConwertTo(ResCount);
   if t.Contains('.') then StopDot:=true;
   if OverflowError then t:='ERROR, OVERFLOW!';
   Label4.Caption:=t;

   Label2.Caption:=t.Length.ToString;

   //show message if error
  except
    on E: EConvertError do ShowMessage('O-o-o-p-s! Error has happend!');
  end;

   //for sure - free memory for all created objects
  finally
    CurOper:=Operation;
    while (CurOper.next<>Nil) do begin
        Operation:=CurOper;
        CurOper:=CurOper.next;
       Operation.free;
    end;
    Pieces1.free();
    Pieces2.free();
    RegexObj1.Free;
    RegexObj2.Free;
  end;
end;



//check if input is odd
function TForm1.Checker(s: String): Boolean;
var c: Char;
begin
      c:=s[1];
      if not (c in ['0'..'9', '.'])  then StopDot:=false;
      Checker:=false;
      if String(Label4.Caption).Length>(maxNumberWidth-1) then Checker:=true;
      if (s='.') and StopDot then Checker:=true;
      if s='.' then StopDot:=true;
end;



procedure TForm1.ConwerterSwitch(Sender: TObject);
var i: byte=1;
    r : TRadioButton;
    b: TButton;
    d : Double;
begin
    FinalCalculationButtonClick(Sender);
    PrevNumberSystem:=NumberSystem;
    for r in RadioButtons  do
       begin
          if r.Checked then NumberSystem:=TNumberSystem(i);
          inc(i);
       end;
    case NumberSystem of
       Dec :  begin
                    for b in DecimalButtons do b.Enabled:=True;
                    for b in HeximalButtons do b.Enabled:=False;
              end;
       Hex :  begin
                    for b in DecimalButtons do b.Enabled:=True;
                    for b in HeximalButtons do b.Enabled:=True;
              end;
       Bin :  begin
                    for b in DecimalButtons do b.Enabled:=False;
                    for b in HeximalButtons do b.Enabled:=False;
              end;
    end;
end;



procedure TForm1.BorderText();
begin
  Label2.Font.color:=clBlack;
  Label2.Caption:=String(Label4.Caption).Length.ToString;
  if String(Label4.Caption).Length>29 then   Label2.Font.color:=clRed;
end;


//confert from and input to digital based of PrevNumberSystem
function TForm1.ConwertFrom(s: String): Double;
var  v : Double=0;
     i, l : Integer;
begin
  case PrevNumberSystem of
     Dec : v:=s.toDouble;
     Bin : begin
                 l:=length(s);
                 for i := 0 to l-1 do v:=v+((ord(s[l-i])-48) << i);
           end;
     Hex : v:=StrToInt64('$'+s);
  end;
ConwertFrom:=v;
end;


//confert from  digital to any output  based of  NumberSystem
function TForm1.ConwertTo(d: Double): String;
var  t : String='';
     absD : Double;
     roundD : Int64;
     fromExpToFraction : Double = 0.1;
begin
  absD:=Abs(d);
  roundD:=Round(absD);
  case NumberSystem of
     Dec : begin
                 t:=Double.ToString(d);
                 if absD<fromExpToFraction then t:=FloatToStrF(d,ffFixed,5,MAXpresision);
                 t:=t.TrimRight('0');
                 t:=t.TrimRight('.');
                 if t='' then t:='0';
           end;
     Bin : begin
                 if absD>MAXInt2Binary then OverflowError:=true;
                 while (roundD > 0) do
                       begin
                          if (roundD mod 2)=1 then t:='1'+t else t:='0'+t;
                          roundD:=roundD div 2;
                       end;
                 if t='' then t:='0';
           end;
     Hex : begin
                 if absD>MAXInt2Hex then OverflowError:=true;
                 t:=Format('%x', [roundD]);
           end;
  end;
  ConwertTo:=t;
end;




procedure TForm1.AfterConstruction;
begin
  inherited;
  RadioButtons[1]:=RadioButton1;
  RadioButtons[2]:=RadioButton2;
  RadioButtons[3]:=RadioButton3;
  DecimalButtons[1]:=ButtonDot;
  DecimalButtons[2]:=Button2;
  DecimalButtons[3]:=Button3;
  DecimalButtons[4]:=Button4;
  DecimalButtons[5]:=Button5;
  DecimalButtons[6]:=Button6;
  DecimalButtons[7]:=Button7;
  DecimalButtons[8]:=Button8;
  DecimalButtons[9]:=Button9;
  HeximalButtons[1]:=ButtonA;
  HeximalButtons[2]:=ButtonB;
  HeximalButtons[3]:=ButtonC;
  HeximalButtons[4]:=ButtonD;
  HeximalButtons[5]:=ButtonE;
  HeximalButtons[6]:=ButtonF;
  NumberSystem:=Dec;
  PrevNumberSystem:=Dec;
end;




  { TOperation }

   function TOperation.Action(d : Double)  : Double;
      var res : Double=0;
      begin
        OverflowError:=true;
        case oper of
        '+': res:=d+next.v;
        '-': res:=d-next.v;
        '/': begin
                 if next.v=0 then exit;
                 res:=d/next.v;
             end;
        '*': res:=d*next.v;
        end;
          OverflowError:=false;
          Action:=res;
      end;


end.

