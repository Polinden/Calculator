unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils, RegExpr, Math, TrimStr;


type

  { TOperation }

    TOperation = class(TObject)
      v : Double;
      oper : Char;
      next:   TOperation;
      function Action : Double;
   end;


  TNumberSystem = (Dec=1, Hex=2, Bin=3);


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
    ButtonSqRt: TButton;
    ButtonSq: TButton;
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
    procedure SymplifyOperations(Operation: TOperation);
    procedure BorderText();
    function ConwertTo(d: Double): String;
    function ConwertFrom(s: String): Double;
  private

  public

  end;



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


{ TForm1 }

procedure TForm1.AllButtonsClick(Sender: TObject);
var   s, t: String;
begin
      if OverflowError then CanselButtonClick(Sender);
      s:= TButton(Sender).Caption;
      t:=Label4.Caption;
      if Checker(s) then exit;
      if (t='0') and (s<>',') then t:=s else t:=t+s;
      Label4.Caption:=t;
      BorderText;
end;



procedure TForm1.BackSpaceClick(Sender: TObject);
var t : String;
    c : Char;
begin
    if OverflowError then exit;
    t:=Label4.Caption;
    c:=t[Length(t)];
    if c =',' then StopDot:=false;
    Delete(t, Length(t),1);
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
  Expression1, Expression2 : String;
  Regex1, Regex2 : TRegExpr;
  Pieces1, Pieces2 : TStrings;
  CurOper : TOPeration;
  c : Char;
  ic : Word;
begin
  if OverflowError then exit;

  t:=Label4.Caption;

  //prevent format errors
  try
  try
    Pieces1 := TStringList.Create;
    Pieces2 := TStringList.Create;
    Operation:=TOperation.Create;

    //sort out stupidities
    t:=TrimLeft(t, '/');
    if (t='') or (t='/')  then t:='0';
    if t[1] = '*' then t:='1'+t else t:='0'+t;

    //prepare complex operations
    t:=StringReplace(t, 'v','*0v', [rfReplaceAll]);
    t:=StringReplace(t, 'q','q0', [rfReplaceAll]);

    //splite with REGEX!
    Expression1 := '[vq/*+-]+';
    Expression2 := '[\,0-9A-F]+';
    Regex1:=TRegExpr.Create(Expression1);
    Regex2:=TRegExpr.Create(Expression2);
    Regex1.Split(t, Pieces1);
    Regex2.Split(t, Pieces2);


    //prepare graph
    CurOper:=Operation;
    for ic:=0 to Pieces2.Count-1 do
    begin
        Act:=Pieces2.Strings[ic];
        if Act<>'' then
           begin
               CurOper.oper:=Act[1];
               CurOper.next:=TOperation.Create;
               CurOper:=CurOper.next;
           end;
    end;

    CurOper:=Operation;
    for ic:=0 to Pieces1.Count-1 do
    begin
        Number:=Pieces1.Strings[ic];
        if Number<>'' then
           begin
               CurOper.v:=ConwertFrom(Number);
               CurOper:=CurOper.next;
           end;
    end;

   //parce graph
   SymplifyOperations(Operation);
   t:= ConwertTo(Operation.v);
   if AnsiContainsText(t, ',') then StopDot:=true;
   if OverflowError then t:='ERROR, OVERFLOW!';


   Label4.Caption:=t;
   Label2.Caption:=IntToStr(Length(t));


   //show message if error
  except
    on E: EConvertError do ShowMessage('O-p-s! Conversion error has happend!');
    on E: Exception  do ShowMessage('O-o-o-p-s! Serious error has happend!');
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
    Regex1.Free;
    Regex2.Free;
  end;
end;



//check if input is odd
function TForm1.Checker(s: String): Boolean;
var c: Char;
begin
      c:=s[1];
      if not (c in ['0'..'9', ','])  then StopDot:=false;
      Checker:=false;
      if Length(Label4.Caption)>(maxNumberWidth-1) then Checker:=true;
      if (s=',') and StopDot then Checker:=true;
      if s=',' then StopDot:=true;
end;



procedure TForm1.ConwerterSwitch(Sender: TObject);
var ic: byte;

begin

    PrevNumberSystem:=NumberSystem;
    for ic:=1 to Length(RadioButtons) do if RadioButtons[ic].Checked then NumberSystem:=TNumberSystem(ic);
    FinalCalculationButtonClick(Sender);


    case NumberSystem of
       Dec :  begin
                    for ic:=1 to Length(DecimalButtons) do DecimalButtons[ic].Enabled:=True;
                    for ic:=1 to Length(HeximalButtons) do HeximalButtons[ic].Enabled:=False;
              end;
       Hex :  begin
                    for ic:=1 to Length(DecimalButtons) do DecimalButtons[ic].Enabled:=True;
                    for ic:=1 to Length(HeximalButtons) do HeximalButtons[ic].Enabled:=True;
              end;
       Bin :  begin
                    for ic:=1 to Length(DecimalButtons) do DecimalButtons[ic].Enabled:=False;
                    for ic:=1 to Length(HeximalButtons) do HeximalButtons[ic].Enabled:=False;
              end;
    end;

    end;



procedure TForm1.BorderText();
begin
  Label2.Font.color:=clBlack;
  Label2.Caption:=IntToStr(Length(Label4.Caption));
  if Length(Label4.Caption)>29 then   Label2.Font.color:=clRed;
end;


//confert from and input to digital based of PrevNumberSystem
function TForm1.ConwertFrom(s: String): Double;
var  v : Double;
     i, l : Integer;
begin
  v:=0;
  case PrevNumberSystem of
     Dec : v:=StrToFloat(s);
     Bin : begin
                 l:=length(s);
                 for i := 0 to l-1 do v:=v+((ord(s[l-i])-48) shl i);
           end;
     Hex : v:=StrToInt64('$'+s);
  end;
ConwertFrom:=v;
PrevNumberSystem:=NumberSystem;
end;


//confert from  digital to any output  based of  NumberSystem
function TForm1.ConwertTo(d: Double): String;
var  t : String;
     absD : Double;
     roundD : Int64;
begin
  t:='';
  absD:=Abs(d);
  roundD:=Round(absD);
  case NumberSystem of
     Dec : begin
                 //no exponential format for small numbers
                 t:=FloatToStrF(d,ffFixed,5,MAXpresision);
                 t:=TrimRight(t,'0');
                 t:=TrimRight(t, ',');
                 if t='' then t:='0';
                 //exponential is exeptible
                 if absD>0 then t:=FloatToStr(d);
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



//operations
procedure TForm1.SymplifyOperations(Operation : TOperation);
var CurOper : TOPeration;
begin
  //unary operations
  CurOper:=Operation;
  while CurOper.next<>Nil do begin
        if CurOper.oper in ['v','q'] then CurOper.Action else CurOper:=CurOper.next;
  end;
    //binary priority operations
  CurOper:=Operation;
  while CurOper.next<>Nil do begin
        if CurOper.oper in ['*','/'] then CurOper.Action else CurOper:=CurOper.next;
  end;
 //low priority operations
  while Operation.next<>Nil do Operation.Action;
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

   function TOperation.Action : Double;
      var res : Double;
      begin
        res:=0;
        OverflowError:=false;
        case oper of
        '+': res:=v+next.v;
        '-': res:=v-next.v;
        '*': res:=v*next.v;
        'q': res:=power(v,2);
        '/': if next.v=0 then OverflowError:=true else res:=v/next.v;
        'v': if next.v<0 then OverflowError:=true else res:=sqrt(next.v);
        end;
          v:=res;
          oper:=next.oper;
          next:=next.next;
      end;






{$R *.dfm}


end.
