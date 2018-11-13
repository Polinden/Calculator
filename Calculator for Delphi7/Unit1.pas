unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils, RegExpr, Math, TrimStr, jpeg,
  Buttons, Menus;


type




   TOperation = class(TObject)
      v : Extended;
      oper : Char;
      next:   TOperation;
      function Action : Extended;
   end;





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
    ButtonCe: TBitBtn;
    MainMenu: TMainMenu;
    Info1: TMenuItem;
    About1: TMenuItem;
    Exit1: TMenuItem;
    procedure AfterConstruction; override;
    procedure AllButtonsClick(Sender: TObject);
    procedure CanselButtonClick(Sender: TObject);
    procedure FinalCalculationButtonClick(Sender: TObject);
    procedure BackSpaceClick(Sender: TObject);
    procedure ConverterSwitch(Sender: TObject);
    procedure ButtonMClick(Sender: TObject);
    procedure ButtonMrClick(Sender: TObject);
    procedure ButttonMcClick(Sender: TObject);
    procedure Test(Sender: TObject; var Key: Char) ;
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Paint; override;

   private
    function DoCalculate(s: String): String;
    procedure SymplifyOperations(Operation: TOperation);
    procedure BorderText();
    function ConvertTo(d: Extended): String;
    function ConvertFrom(s: String): Extended;
    function Checker(s : String): Boolean;
    function CheckDot(s: String): Boolean;
    function PrepareUnaryOperations(s: String): string;
    procedure TestMe;

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
  OverflowError: boolean = false;
  NumberSystem, PrevNumberSystem : TNumberSystem;
  RadioButtons : array [1..3] of TRadioButton;
  DecimalButtons : array [1..9] of TButton;
  HeximalButtons : array [1..6] of TButton;
  MemoryString : Extended;



  //constants
  MAXNumberWidth : Integer =50;              //desired screen WIDTH
  MAXpresision : Integer=12;                 //pressision for formating fload numbers
  MAXInt2Binary : Int64 = 1073741823;        //maximum for 30 symbols + see AfterConstruction (2**30-1)
  MAXInt2Hex : Int64 = 9223372036854775806;   //maximum Integer Number of Int64 to check overflow
  DotSymbol : Char = ',';                     //universal dot symbol for ans local systems
  RunOnce : Boolean=true;                     //check if it runs once after program starts
  All_Operations : Set of TActions=[Pl, Mn, Ml, Dv, Sqr, Sq];  //helpfull set of operations






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
      if (a_last in (All_Operations-[Sq])) and (a_passed in (All_Operations-[Mn,Sqr])) then exit;
      if (a_last = Mn) and (a_passed = Mn) then exit;
      if (a_last = Sqr) and (a_passed = Mn) then exit;
      if (a_last = Sq) and (a_passed = Sq) then exit;
      if (a_last = Sqr) and (a_passed = Sqr) then exit;

      //replace '0-...' in case of ninus, square root or numbers
      if (t='0') and (s in  ['0'..'9', 'A'..'F', Char(Sqr), Char(Mn)]) then t:=s else t:=t+s;

      Label4.Caption:=t;
      BorderText;
end;



procedure TForm1.BackSpaceClick(Sender: TObject);
var t : String;
begin
    if OverflowError then exit;
    t:=Label4.Caption;
    Delete(t, Length(t),1);
    if t=''  then t:='0';
    Label4.Caption:=t;
    BorderText;
end;



procedure TForm1.CanselButtonClick(Sender: TObject);
begin
      Label4.Caption:='0';
      OverflowError:=false;
      BorderText;
end;



//status line on the bottom shows screen width and free space
procedure TForm1.BorderText();
begin
  Label2.Font.color:=clBlack;
  Label2.Caption:=IntToStr(Length(Label4.Caption));//IntToStr - convert integer number to string
  if Length(Label4.Caption)=(MAXNumberWidth) then   Label2.Font.color:=clRed;
end;


//switch number system ti radiobuttons pressed
procedure TForm1.ConverterSwitch(Sender: TObject);
var ic: byte;

begin
    //find what was pressed
    PrevNumberSystem:=NumberSystem;
    for ic:=1 to Length(RadioButtons) do if RadioButtons[ic].Checked then NumberSystem:=TNumberSystem(ic);
    //recalculate screen
    FinalCalculationButtonClick(Sender);
    BorderText;

    //dissable buttons
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



//Calculate expressin
procedure TForm1.FinalCalculationButtonClick(Sender: TObject);
var t : string;
begin
    if OverflowError then exit;
    t:=Label4.Caption;

    //sort out stupidities
    t:=TrimRight(t, 'v');
    t:=TrimRight(t, '/');
    t:=TrimRight(t, '*');

    //prepare complex operations
    t:=PrepareUnaryOperations(t);

    //main function call
    Label4.Caption:=DoCalculate(t);
    BorderText;
end;



//cope with unari operations such as v,^ and -
function TForm1.PrepareUnaryOperations(s: String): string;
begin
    s:=StringReplace(s, '-v','-1*v', [rfReplaceAll]);
    s:=StringReplace(s, 'v','*1v', [rfReplaceAll]);
    s:=StringReplace(s, '^','^0', [rfReplaceAll]);
    s:=StringReplace(s, '+-','-', [rfReplaceAll]);
    s:=ReplaceRegExpr('([\d'+DotSymbol+'A-F])-', s, '$1~', True);
    PrepareUnaryOperations:=s;
end;




//!!!!!!!!!!!!!!
//MAIN PROCEDURE
//!!!!!!!!!!!!!!
function TForm1.DoCalculate(s: String): String;
var
      Act, Number: String;
      Expression1, Expression2 : String;
      Regex1, Regex2 : TRegExpr;
      Pieces1, Pieces2 : TStringList;//list of strings with flexible length (rubber)
      CurOper : TOperation;
      ic : Word;

begin
    try
    try
        //create objects - flexible lists
        Pieces1 := TStringList.Create;
        Pieces2 := TStringList.Create;

        //splite with REGEX!
        Expression1 := '[v^/*+~]+';
        Expression2 := '[-'+DotSymbol+'0-9A-F]+';
        Regex1:=TRegExpr.Create(Expression1);
        Regex2:=TRegExpr.Create(Expression2);
        Regex1.Split(s, Pieces1);
        Regex2.Split(s, Pieces2);

        //drop 1-st and last '' (broken by numbers)
        Pieces2.Delete(0);
        Pieces2.Delete(Pieces2.Count-1);

        //prepare chain of operations
        Operation:=TOperation.Create;
        CurOper:=Operation;
        for ic:=1 to Pieces2.Count do
        begin
            Act:=Pieces2.Strings[ic-1];
            CurOper.oper:=Act[1];
            CurOper.next:=TOperation.Create;
            CurOper:=CurOper.next;
        end;


        CurOper:=Operation;
        for ic:=1 to Pieces1.Count do
        begin
            Number:=Pieces1.Strings[ic-1];
            CurOper.v:=ConvertFrom(Number);
            CurOper:=CurOper.next;
        end;

       //calculate chain
       SymplifyOperations(Operation);
       PrevNumberSystem:=NumberSystem;
       DoCalculate:= ConvertTo(Operation.v);


    //show message if error (all errors happened during development)
    except
        on E: TMyErrorOverflow do begin
              DoCalculate:='ERROR, OVERFLOW! ';
              OverflowError:=True;
        end;
        on E: EOverflow  do begin
              DoCalculate:='ERROR, OVERFLOW! ';
              OverflowError:=True;
        end;
        on E: EInvalidOp  do begin
              DoCalculate:='ERROR, OVERFLOW! ';
              OverflowError:=True;
        end;
        on E: EConvertError do begin
              DoCalculate:='CONVERSION ERROR! ';
              OverflowError:=True;
        end;
        on E: Exception  do ShowMessage('O-o-o-o-p-s! Terrible error has happend: '+E.Message+' !');
    end;

    //for sure - free memory for all created objects
    finally
        CurOper:=Operation;
        while (CurOper<>Nil) do begin
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



//input converter
//s is a string, containing a number in PrevNumberSystem (e.g., in Hex '5A')
//result is Extended type (e.g., 90.0)
//!!!raises exeptions EConvertError and TMyErrorOverflow
function TForm1.ConvertFrom(s: String): Extended;
var  v : Extended;
     i, l : Integer;
     hex_minus : boolean;
begin
  v:=0;
  case PrevNumberSystem of
     Dec : v:=StrToFloat(s);//convert string to extended
     Bin : begin
                 l:=length(s);
                 for i:=l downto 1 do v:=v+ StrToInt64(s[i])*power(2,l-i);
           end;
     Hex : begin
                 hex_minus:=s[1]='-';            //to enable hex minus
                 s:=TrimLeft(s, '-');
                 v:=StrToInt64('$'+s);            //convert Hex string to integer
                 //check, check and again check...
                 if  Format('%x', [Round(v)]) <> s then raise EConvertError.Create('');
                 if (v<0) or (v > MAXInt2Hex) then raise TMyErrorOverflow.Create('');
                 if hex_minus then v:=-1*v;
           end;
  end;
ConvertFrom:=v;
end;


//confert from  digital to any output  based of  NumberSystem
//!!!raises exeptions TMyErrorOverflow
function TForm1.ConvertTo(d: Extended): String;
var  t,f : String;
     absD : Extended;
     roundD : Int64;
begin
  t:='';
  absD:=Abs(d);
  case NumberSystem of
     Dec : begin
                 f:='%0.'+IntToStr(MAXpresision)+'f'; // '%0.16f'
                 t:=Format(f, [d]);
                 t:=TrimRight(t,'0');
                 t:=TrimRight(t, DotSymbol);
                 if t='' then t:='0';
           end;
     Bin : begin
                 if absD>MAXInt2Binary then raise TMyErrorOverflow.Create('');
                 roundD:=Round(absD);
                 while (roundD > 0) do
                       begin
                          if (roundD mod 2)=1 then t:='1'+t else t:='0'+t;
                          roundD:=roundD div 2;
                       end;
                 if t='' then t:='0';
           end;
     Hex : begin
                 if absD>MAXInt2Hex then raise TMyErrorOverflow.Create('');
                 roundD:=Round(absD);
                 t:=Format('%x', [roundD]);
                 if d<0 then t:='-'+t;       //hex minus
           end;
  end;
  ConvertTo:=t;
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




//check if input has mistakes
//s is a string which we try to add to Label4
function TForm1.Checker(s: String): Boolean;
var c : Char;
begin
      //check for dot pressed twice
      if CheckDot(s)  and (s=DotSymbol) then Checker:=true else Checker:=false;
      //not to put dot without a number
      c:=Label4.Caption[Length(Label4.Caption)];
      if (not(c in ['0'..'9','A'..'F'])) and (s=DotSymbol) then Checker:=true;
      //checks if Label4+s doesn't exeeds max length
      if (Length(Label4.Caption))>maxNumberWidth then Checker:=true;
end;


//helper - to check with regex
function TForm1.CheckDot(s: String): Boolean;
var Regex : TRegExpr;
    Expr : String;
begin
    Expr:='[-0-9A-F]*\'+DotSymbol+'[0-9A-F]*$';
    Regex:=TRegExpr.Create(Expr);
    if Regex.Exec(Label4.Caption) then CheckDot:=True else CheckDot:=False;
    Regex.Free;
end;



//is called when progran is rerady
procedure TForm1.AfterConstruction;
var fs : TFormatSettings;
begin
  inherited;
  //prepare arrays of buttons
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
  //set max screen length
  MAXInt2Binary:=Round(Power(2, MAXNumberWidth))-1;
  Label3.Caption:=Label3.Caption+' '+IntToStr(MAXNumberWidth);
  //set dot symbol accordilly to the local settings
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
  DotSymbol:=fs.DecimalSeparator;
  ButtonDot.Caption:=DotSymbol;
  ///IF TESTING
  TestMe;
end;




//memorise
procedure TForm1.ButtonMClick(Sender: TObject);
begin
   FinalCalculationButtonClick(Sender);
   MemoryString:= ConvertFrom(Label4.Caption);
end;

//read from memory
procedure TForm1.ButtonMrClick(Sender: TObject);
var t:string;
begin
   t:=ConvertTo(MemoryString);
   if Checker(t) then Exit;
   if Label4.Caption = '0' then Label4.Caption:=t
     else Label4.Caption:= Label4.Caption + t;
   BorderText;
end;

//clean memory
procedure TForm1.ButttonMcClick(Sender: TObject);
begin
  MemoryString:=0;
end;

//test feature - key pressed enter
procedure TForm1.Test(Sender: TObject; var Key: Char) ;
var b_temp: TButton;
begin
    if Key in [',', '.'] then Key:=DotSymbol;
    if (not ButtonDot.Enabled) and (Key=DotSymbol) then exit;  //no more dots

    b_temp:=TButton.Create(Self);   //temporary virtual button
    b_temp.Caption:=Key;
    ButtonEq.SetFocus;   //for easy pressing Enter = Calculate
    case Ord(Key) of
        42..57:   //these are oll symbols 0..9  +-/*,.
        begin
                AllButtonsClick(b_temp);
        end;
        27:     CanselButtonClick(b_temp);
        8:      BackSpaceClick(b_temp);
    end;
    b_temp.Free;
end;



procedure TForm1.About1Click(Sender: TObject);
begin
  MessageDlg('Polina'+Char(39)+'s Homework. Liceum KPNL 145. Kiev. 2018. All rights reserved. Read more on GitHub', mtInformation, [mbOK], 0);
end;


procedure TForm1.Exit1Click(Sender: TObject);
begin
   Application.Terminate;
end;


//this is a cratch (KOSTYL)
//images position was unstable :(
//papa helped! for me is a magic
procedure TForm1.Paint;
var i : Byte;
begin
      inherited;
      if RunOnce then begin
         ImgSqrt.Refresh;
         ImgPow.Refresh;
         RunOnce:=False;
         for i:=1 to Length(RadioButtons) do RadioButtons[i].Refresh;
      end;
end;





{ TOperation }
 //any operation knows how to simplify itself
 function TOperation.Action : Extended;
    var res : Extended;
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



//Test. Show message if test failed
//To disable - comment out a string in AfterCreated
procedure TForm1.TestMe;
var test_str : array [1..2] of string;
    test_result : array [1..2] of string;
    d1, d2 : Extended;
    actual_result: string;
    i,l : Integer;
begin
       //test1
       test_str[1]:='-0/4v6';
       test_result[1]:='0';

       //test2
       test_str[2]:='0/4+41.5*106.1+-45.2v9/31.2^*21-3.12/44.5+25^v6.3+1414.45*32.5v32*32/3';
       test_result[2]:='2779765.8897822932';


       for i:=1 to Length( test_str) do begin
           test_str[i]:=ReplaceRegExpr('\.', test_str[i], DotSymbol, True);
           test_result[i]:=ReplaceRegExpr('\.', test_result[i], DotSymbol, True);

           test_str[i]:=PrepareUnaryOperations(test_str[i]);
           actual_result:=DoCalculate(test_str[i]);

           d1:=StrToFloat(actual_result);
           d2:=StrToFloat(test_result[i]);

           if Abs(d1-d2)>0.0001 then
                   ShowMessage(Format('TEST FAILED! expected=%s, result=%s', [test_result[i], actual_result]));
       end;
end;



{$R *.dfm}


//program
end.
