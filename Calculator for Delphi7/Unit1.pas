unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils, RegExpr, Math, TrimStr, jpeg;


type


  { TOperation }

   TOperation = class(TObject)
      v : Double;
      oper : Char;
      next:   TOperation;
      function Action : Double;
   end;



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
    ButtonM: TButton;
    ButtonMr: TButton;
    ButttonMc: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ImgSqrt: TImage;
    ImgPow: TImage;
    shp1: TShape;
    shp2: TShape;
    shp3: TShape;
    shp4: TShape;
    procedure AfterConstruction; override;
    procedure AllButtonsClick(Sender: TObject);
    procedure CanselButtonClick(Sender: TObject);
    procedure FinalCalculationButtonClick(Sender: TObject);
    procedure BackSpaceClick(Sender: TObject);
    procedure ConwerterSwitch(Sender: TObject);
    procedure ButtonMClick(Sender: TObject);
    procedure ButtonMrClick(Sender: TObject);
    procedure ButttonMcClick(Sender: TObject);

   private
    function Checker(s: String): Boolean;
    procedure SymplifyOperations(Operation: TOperation);
    procedure BorderText();
    function ConwertTo(d: Double): String;
    function ConwertFrom(s: String): Double;

   public
  end;



  TNumberSystem = (Dec=1, Hex=2, Bin=3);
  TActions = (Pl=ord('+'), Mn=ord('-'),Ml=ord('*'),Dv=ord('/'), Sq=ord('^'), Sqr=ord('v'));
  TMyErrorOverflow=class(Exception);




var
  Form1: TForm1;



implementation



var
  Operation : TOperation;
  StopDot : boolean = false;
  OverflowError: boolean = false;
  NumberSystem, PrevNumberSystem : TNumberSystem;
  RadioButtons : array [1..3] of TRadioButton;
  DecimalButtons : array [1..9] of TButton;
  HeximalButtons : array [1..6] of TButton;
  MemoryString : Double;

  //constants
  MAXNumberWidth : Integer =30;
  MAXpresision : Integer=12;
  MAXInt2Binary : Integer = 536870912;
  MAXInt2Hex : Int64 = 922337203685477;
  All_Operations : Set of TActions=[Pl, Mn, Ml, Dv, Sqr, Sq];


{ TForm1 }

procedure TForm1.AllButtonsClick(Sender: TObject);
var   t: String;
      s, q : Char;
      a_last, a_passed : TActions;
begin
      if OverflowError then CanselButtonClick(Sender);
      //get Name or Caption for pressed object
      //but first cast Sender to nessecary type
      //if Sender.ClassType = TImage then  ... is also possible
      t:=TComponent(Sender).Name;
      if t='ImgSqrt' then  s:='v'
        else if t='ImgPow' then  s:='^'
            else s:= TButton(Sender).Caption[1];

      t:=Label4.Caption;//work string on the screen
      //check if too long string and if dot is pressed twice
      if Checker(s) then exit;

      //check if too many operation pressed
      q:=t[Length(t)];  //last symbol on the screen
      a_last:=TActions(ord(q)); //operation from last symbol on screen
      a_passed:=TActions(ord(s)); //operation pressed
      if (a_last in (All_Operations-[Sq])) and (a_passed in (All_Operations-[Mn])) then exit;
      if (a_last = Mn) and (a_passed = Mn) then exit;
      if (a_last = Sqr) and (a_passed = Mn) then exit;

      //replace '0-...' to '-...'
      if (t='0') and not (a_passed in  All_Operations-[Mn, Sqr]) then t:=s else t:=t+s;

      Label4.Caption:=t;
      BorderText;
end;



procedure TForm1.BackSpaceClick(Sender: TObject);
var t : String;
    c : Char;
begin
    if OverflowError then exit;
    t:=Label4.Caption;
    c:=t[Length(t)]; //last simbol of the string
    if c =',' then StopDot:=false;  //to do!!!!!
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
  Pieces1, Pieces2 : TStringList;//list of strings with varring length (rubber)
  CurOper : TOperation;
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
    t:=TrimRight(t, 'v');
    t:=TrimRight(t, '/');
    t:=TrimRight(t, '*');
    if (Length(t)>0) and (t[1]='v') then t:='1'+t else t:='0'+t;

    //prepare complex operations
    t:=StringReplace(t, 'v','*0v', [rfReplaceAll]);
    t:=StringReplace(t, '^','^0', [rfReplaceAll]);
    t:=StringReplace(t, '+-','-', [rfReplaceAll]);
    t:=ReplaceRegExpr('(\d)-', t, '$1~', True);

    //splite with REGEX!
    Expression1 := '[v^/*+~]+';
    Expression2 := '[-,0-9A-F]+';
    Regex1:=TRegExpr.Create(Expression1);
    Regex2:=TRegExpr.Create(Expression2);
    Regex1.Split(t, Pieces1);
    Regex2.Split(t, Pieces2);


    //prepare chain of operations
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

   //calculate chain
   SymplifyOperations(Operation);
   PrevNumberSystem:=NumberSystem;
   t:= ConwertTo(Operation.v);
   if AnsiContainsText(t, ',') then StopDot:=true;


   Label4.Caption:=t;
   Label2.Caption:=IntToStr(Length(t));


   //show message if error
  except
    on E: TMyErrorOverflow do begin
          Label4.Caption:='ERROR, OVERFLOW!';
          OverflowError:=True;
    end;
    on E: EInvalidOp  do begin
          Label4.Caption:='ERROR, OVERFLOW!';
          OverflowError:=True;
    end;
    on E: EConvertError do begin
          Label4.Caption:='CONVERSION ERROR!';
          OverflowError:=True;
    end;
    on E: Exception  do ShowMessage('O-o-o-o-p-s! Terrible error has happend!');
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



//check if input has mistakes
//s is a string which we try to add to Label4
function TForm1.Checker(s: String): Boolean;
var c: Char;
begin
      c:=s[1];
      if not (c in ['0'..'9', ','])  then StopDot:=false;
      Checker:=false;
      //checks if Label4+s doesn't exeeds max length
      if (Length(Label4.Caption)+Length(s))>maxNumberWidth then Checker:=true;
      if (s=',') and StopDot then Checker:=true;
      if s=',' then StopDot:=true;
end;



procedure TForm1.ConwerterSwitch(Sender: TObject);
var ic: byte;

begin

    PrevNumberSystem:=NumberSystem;
    for ic:=1 to Length(RadioButtons) do if RadioButtons[ic].Checked then NumberSystem:=TNumberSystem(ic);
    FinalCalculationButtonClick(Sender);
    BorderText;

    case NumberSystem of
       Dec :  begin
                    for ic:=1 to Length(DecimalButtons) do DecimalButtons[ic].Enabled:=True;
                    for ic:=1 to Length(HeximalButtons) do HeximalButtons[ic].Enabled:=False;
              end;
       Hex :  begin
                    for ic:=1 to Length(DecimalButtons) do DecimalButtons[ic].Enabled:=True;
                    for ic:=1 to Length(HeximalButtons) do HeximalButtons[ic].Enabled:=True;
                    ButtonDot.Enabled:=False;
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
  Label2.Caption:=IntToStr(Length(Label4.Caption));//IntToStr - convert integer number to string
  if Length(Label4.Caption)=(MAXNumberWidth) then   Label2.Font.color:=clRed;
end;


//input converter
//s is a string, containing a number in PrevNumberSystem (e.g., in Hex '5A')
//result is double type (e.g., 90.0)
function TForm1.ConwertFrom(s: String): Double;
var  v : Double;
     i, l : Integer;
begin
  v:=0;
  case PrevNumberSystem of
     Dec : v:=StrToFloat(s);//convert string to extended
     Bin : begin
                 l:=length(s);
                 for i := 0 to l-1 do v:=v+((ord(s[l-i])-48) shl i); //'ord' is a number codding this symbol
                 // for i:=l downto 1 do v:=v+ StrToInt64(s[i])*power(2,l-i);
           end;
     Hex : begin
                 v:=StrToInt64('$'+s); //convert Hex string to integer
           end;
  end;
ConwertFrom:=v;
end;


//confert from  digital to any output  based of  NumberSystem
function TForm1.ConwertTo(d: Double): String;
var  t,f : String;
     absD : Double;
     roundD : Int64;
begin
  t:='';
  absD:=Abs(d);
  roundD:=Round(absD);
  case NumberSystem of
     Dec : begin
                 f:='%0.'+IntToStr(MAXpresision)+'f'; // '%0.16f'
                 t:=Format(f, [d]);
                 t:=TrimRight(t,'0');
                 t:=TrimRight(t, ',');
                 if t='' then t:='0';
           end;
     Bin : begin
                 if absD>MAXInt2Binary then raise TMyErrorOverflow.Create('');
                 while (roundD > 0) do
                       begin
                          if (roundD mod 2)=1 then t:='1'+t else t:='0'+t;
                          roundD:=roundD div 2;
                       end;
                 if t='' then t:='0';
           end;
     Hex : begin
                 if absD>MAXInt2Hex then raise TMyErrorOverflow.Create('');
                 t:=Format('%x', [roundD]);
           end;
  end;
  ConwertTo:=t;
end;



//operations
procedure TForm1.SymplifyOperations(Operation : TOperation);
var CurOper : TOperation;
begin
  //unary operations
  CurOper:=Operation;
  while CurOper.next<>Nil do begin
        if CurOper.oper in ['v','^'] then CurOper.Action else CurOper:=CurOper.next;
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
  MemoryString:=0;
end;





  { TOperation }

   function TOperation.Action : Double;
      var res : Double;
      begin
        res:=0;
        case oper of
        '+': res:=v+next.v;
        '~': res:=v-next.v;
        '*': res:=v*next.v;
        '^': res:=power(v,2);
        '/': if next.v=0 then raise TMyErrorOverflow.Create('') else res:=v/next.v;
        'v': if next.v<0 then raise TMyErrorOverflow.Create('') else res:=sqrt(next.v);
        end;
          v:=res;
          oper:=next.oper;
          next:=next.next;
      end;


procedure TForm1.ButtonMClick(Sender: TObject);
begin
   FinalCalculationButtonClick(Sender);
   MemoryString:= ConwertFrom(Label4.Caption);
end;

procedure TForm1.ButtonMrClick(Sender: TObject);
var t:string;
begin
   t:=ConwertTo(MemoryString);
   if Checker(t) then Exit;
   if Label4.Caption = '0' then Label4.Caption:=t
     else Label4.Caption:= Label4.Caption + t;
   BorderText;
end;

procedure TForm1.ButttonMcClick(Sender: TObject);
begin
  MemoryString:=0;
end;

{$R *.dfm}


end.
