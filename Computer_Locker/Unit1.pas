unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, cjhooksdtt, ExtCtrls, Tlhelp32, Buttons, StdCtrls,
  Registry;

type
  twertyuiop = class(TForm)
    hk: TCjHookDTT;
    pass: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Label6: TLabel;
    curs: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label10: TLabel;
    Bevel4: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton34: TSpeedButton;
    SpeedButton35: TSpeedButton;
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    SpeedButton38: TSpeedButton;
    SpeedButton39: TSpeedButton;
    SpeedButton40: TSpeedButton;
    SpeedButton41: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton42: TSpeedButton;
    SpeedButton43: TSpeedButton;
    SpeedButton44: TSpeedButton;
    SpeedButton45: TSpeedButton;
    Bevel3: TBevel;
    SpeedButton46: TSpeedButton;
    Bevel5: TBevel;
    Label7: TLabel;
    SpeedButton47: TSpeedButton;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure hkKeyScan(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure hkKeyUp(sender: TObject; Shift: TCjShiftState;
      Key: Byte);
    procedure SetPassword(s:string);
    procedure Label5Click(Sender: TObject);
    function Translate(c:char):char;
    function GetPassword:string;
    procedure EndSession(var m:TMessage);message WM_QUERYENDSESSION;
    procedure SpeedButton1Click(Sender: TObject);
    function delate(c:char):word;
    procedure SpeedButton45Click(Sender: TObject);
    procedure SpeedButton46Click(Sender: TObject);
    function AlternatePWD:string;
    procedure ShowMessage(s:string);
    procedure SpeedButton47Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    function Autorun:boolean;
    function SavePass(s:string):string;
    function LoadPass:string;
  private
  password:string;
  pwd:string;
  kLayout:byte;
  kcaps:byte;
  bCount:byte;
  newparol:string;
  end;

var
  Form1: twertyuiop;
  nowloaded:boolean;

implementation

{$R *.dfm}

function GetpidByname(sl:string):cardinal;
var
  h: HWND;
  snap: tprocessentry32;
begin
result:=0;    
  h := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, cardinal(-1));
  snap.dwSize := SizeOf(ProcessEntry32);
  if process32first(h, snap) = true then
  repeat
             if lowercase(sl)=lowercase(snap.szExeFile)then
             begin
                  result:=snap.th32ProcessID;
                  break;
             end;
  until process32next(h,snap)<>true;
  closehandle(h);
end;

procedure twertyuiop.FormCreate(Sender: TObject);
var
j:cardinal;
w,h:integer;
begin
kLayout:=0;
kcaps:=0;
bCount:=0;
randomize;
left:=0;
top:=0;
borderstyle:=bsNone;
width:=screen.Width;
height:=screen.Height;
formstyle:=fsStayOnTop;
image1.BringToFront;
curs.Height:=3;
bevel4.Width:=width-bevel4.Left*2;
label11.Left:=width-label11.Width-50;
label11.Top:=20;
label8.Left:=bevel4.Left;
label8.Top:=height-label8.Height-bevel4.Top;
label9.Left:=width-label9.Width-bevel4.Left;
label9.Top:=height-label9.Height-bevel4.Top;
speedbutton13.Caption:=#32;
speedbutton14.Caption:=#8' <---';
speedbutton45.Caption:=#13+'           |'#13'<---------';
showcursor(false);
color:=clBlack;
password:=loadpass;
nowloaded:=true;
w:=speedbutton15.Width;
h:=speedbutton15.Height;
for j:=0  to self.ComponentCount-1 do
    if self.Components[j] is TSpeedButton then
    begin
         TSpeedButton(self.Components[j]).Left:=TSpeedButton(self.Components[j]).Left+w;
         TSpeedButton(self.Components[j]).Top:=TSpeedButton(self.Components[j]).Top+h;
    end;
bevel3.Left:=bevel3.Left+w;
bevel3.Top:=bevel3.Top+h;
end;

procedure twertyuiop.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=false;
end;

procedure twertyuiop.hkKeyScan(Sender: TObject);
var
c:cardinal;
begin
image1.Left:=calccursorpos.x+1;
image1.Top:=calccursorpos.y+1;
curs.Left:=pass.Left+pass.Width;
if bcount=10 then
   begin
        curs.Visible:=not curs.Visible;
        bcount:=0;
   end else bcount:=bcount+1;
label9.Caption:=datetostr(now)+' '+timetostr(now);
setwindowpos(handle,HWND_TOPMOST,0,0,0,0,swp_nosize or swp_nomove);
c:=openprocess(PROCESS_TERMINATE,false,getpidbyname('taskmgr.exe'));
if c<>0then
begin
     terminateprocess(c,100);
     closehandle(c);
end;
c:=openprocess(PROCESS_TERMINATE,false,getpidbyname('explorer.exe'));
if c<>0then
begin
     terminateprocess(c,100);
     closehandle(c);
end;
end;

procedure twertyuiop.Label4Click(Sender: TObject);
begin
case kcaps of
0:begin
       kcaps:=1;
       label4.Caption:='ON';
  end;
1:begin
       kcaps:=0;
       label4.Caption:='OFF';
  end;
end;
end;

procedure twertyuiop.FormActivate(Sender: TObject);
begin
pwd:='';
pass.Caption:='';
end;

procedure twertyuiop.hkKeyUp(sender: TObject; Shift: TCjShiftState;
  Key: Byte);
begin
if (cssControl in shift)and(key=key_backspace)then setpassword('')else
case uppercase(chr(key))[1]of
'A'..'Z','0'..'9',' ',chr(188),chr(190),chr(186),chr(222),
chr(219),chr(221):setpassword(pwd+translate(chr(key)));
chr(vk_back):setpassword(copy(pwd,1,length(pwd)-1));
chr(vk_delete):setpassword('');
chr(vk_return):speedbutton45click(self);
end;
end;

procedure twertyuiop.SetPassword(s: string);
var
j:cardinal;
begin
if length(s)>100 then exit;
pwd:=s;
pass.Caption:='';
for j:=1  to length(pwd) do
    pass.Caption:=pass.Caption+'?';
end;

procedure twertyuiop.Label5Click(Sender: TObject);
begin
case kLayout of
0:begin
       klayout:=1;
       label5.Caption:='RU';
  end;
1:begin
       klayout:=0;
       label5.Caption:='EN';
  end;
end;

end;

function twertyuiop.Translate(c: char): char;
var
s:char;
begin
s:=lowercase(c)[1];
if kLayout=1 then
case s of
'q':s:='й';
'w':s:='ц';
'e':s:='у';
'r':s:='к';
't':s:='е';
'y':s:='н';
'u':s:='г';
'i':s:='ш';
'o':s:='щ';
'p':s:='з';
chr(219):s:='х';
chr(221):s:='ъ';
'a':s:='ф';
's':s:='ы';
'd':s:='в';
'f':s:='а';
'g':s:='п';
'h':s:='р';
'j':s:='о';
'k':s:='л';
'l':s:='д';
chr(186):s:='ж';
chr(222):s:='э';
'z':s:='я';
'x':s:='ч';
'c':s:='с';
'v':s:='м';
'b':s:='и';
'n':s:='т';
'm':s:='ь';
chr(188):s:='б';
chr(190):s:='ю';
end;
if kcaps=1 then
if klayout<>1 then
s:=uppercase(s)[1] else
case s of
'й':s:='Й';
'ц':s:='Ц';
'у':s:='У';
'к':s:='К';
'е':s:='Е';
'н':s:='Н';
'г':s:='Г';
'ш':s:='Ш';
'щ':s:='Щ';
'з':s:='З';
'х':s:='Х';
'ъ':s:='Ъ';
'ф':s:='Ф';
'ы':s:='Ы';
'в':s:='В';
'а':s:='А';
'п':s:='П';
'р':s:='Р';
'о':s:='О';
'л':s:='Л';
'д':s:='Д';
'ж':s:='Ж';
'э':s:='Э';
'я':s:='Я';
'ч':s:='Ч';
'с':s:='С';
'м':s:='М';
'и':s:='И';
'т':s:='Т';
'ь':s:='Ь';
'б':s:='Б';
'ю':s:='Ю';
end;
result:=s;
end;

function twertyuiop.GetPassword: string;
begin
result:=password;
end;

procedure twertyuiop.EndSession(var m: TMessage);
begin
exitprocess(0);
end;

procedure twertyuiop.SpeedButton1Click(Sender: TObject);
begin
     hk.OnKeyUp(self,[],delate(TSPEEDBUTTON(sender).caption[1]));
end;

function twertyuiop.delate(c: char): word;
begin
case c of
'[':result:=219;
']':result:=221;
';':result:=186;
'''':result:=222;
'\':result:=220;
',':result:=188;
'.':result:=190;
else result:=ord(c);
end;
end;

procedure twertyuiop.SpeedButton45Click(Sender: TObject);
begin
if (getpassword=pwd)or(pwd=alternatepwd) then
begin
winexec('explorer.exe',sw_show);
exitprocess(1);
end else showmessage('Введенный пароль не верен проверьте выполнение этих пунктов: '#13'1. Убедитесь в нужном режиме Caps Lock'#13'2. язык ввода стоит нужный'#13'3. попробуйте вводить пароль по медленнее.');
end;

procedure twertyuiop.SpeedButton46Click(Sender: TObject);
begin
hk.OnKeyUp(self,[],vk_delete);
end;

function twertyuiop.AlternatePWD: string;
var
t:_SYSTEMTIME;
begin
sysutils.DateTimeToSystemTime(time,t);
result:=inttostr(t.wSecond)+inttostr(t.wMinute)+inttostr(t.wHour);
end;

procedure twertyuiop.ShowMessage(s: string);
begin
bevel5.Left:=bevel3.Left;
bevel5.Top:=bevel3.Top+bevel3.Height+8;
bevel5.Width:=bevel3.Width;
label7.Width:=bevel5.Width-16;
label7.Caption:=s;
label7.Width:=bevel5.Width-16;
label7.Left:=bevel5.Left+8;
label7.Top:=bevel5.Top+8;
bevel5.Height:=8*3+label7.Height+speedbutton47.Height;
speedbutton47.Left:=bevel5.Left+bevel5.Width div 2 -speedbutton47.Width div 2;
speedbutton47.Top:=bevel5.Top+bevel5.Height-8-speedbutton47.Height;
speedbutton47.Show;
label7.Show;
bevel5.Show;
end;

procedure twertyuiop.SpeedButton47Click(Sender: TObject);
begin
speedbutton47.Hide;
label7.Hide;
bevel5.Hide;
end;

procedure twertyuiop.Label11Click(Sender: TObject);
begin
showmessage('Computer Locker - программа для блокирования компьютера'#13'Автор Чуклинов Евгений aka Cj');
end;

procedure twertyuiop.Label12Click(Sender: TObject);
begin
case label12.Tag of
0:begin
     showmessage('Введите старый пароль и нажмите "СМЕНИТЬ ПАРОЛЬ"');
     label12.Tag:=1;
 end;
1:begin
     if (getpassword=pwd)or(pwd=alternatepwd)then
     begin
          showmessage('Введите старый пароль еще раз и нажмите "СМЕНИТЬ ПАРОЛЬ"');
          label12.Tag:=2;
          setpassword('');
     end else
     begin
          showmessage('Введенный пароль не совпадает со старым!');
          label12.Tag:=0;
          setpassword('');
     end;
 end;
2:begin
     if (getpassword=pwd)or(pwd=alternatepwd)then
     begin
       showmessage('Введите новый пароль и нажмите "СМЕНИТЬ ПАРОЛЬ"');
       label12.Tag:=3;
          setpassword('');
     end else
     begin
          showmessage('Введенный пароль не совпадает со старым!');
          label12.Tag:=0;
          setpassword('');
     end;
 end;
3:begin
       newparol:=pwd;
       showmessage('Введите новый пароль еще раз и нажмите "СМЕНИТЬ ПАРОЛЬ"');
       label12.Tag:=4;
       setpassword('');
 end;
4:begin
     if (newparol=pwd)or(pwd=alternatepwd)then
     begin
       showmessage('Пароль сменен на новый');
       savepass(newparol);
       password:=loadpass;
       newparol:='';
       label12.Tag:=0;
          setpassword('');
     end else
     begin
          showmessage('Введенный новый пароль не совпадает с первой попыткой!');
          label12.Tag:=0;
          setpassword('');
     end;
 end;
end;
end;

procedure twertyuiop.Label13Click(Sender: TObject);
begin
case label13.Tag of
0:begin
     showmessage('Введите пароль и нажмите "АВТОЗАГРУЗКА"');
     label13.Tag:=1;
 end;
1:begin
     if (getpassword=pwd)or(pwd=alternatepwd)then
     begin
          label13.Tag:=0;
          setpassword('');
          case autorun of
          true:showmessage('Программа прописана на автозагрузку');
          false:showmessage('Программа убрана из автозагрузки');
          end;
     end else
     begin
          showmessage('Введенный пароль не верен!');
          label13.Tag:=0;
          setpassword('');
     end;
 end;
end;
end;

function twertyuiop.Autorun: boolean;
var
s:string;
begin
with TRegistry.Create(KEY_ALL_ACCESS)do
begin
     rootkey:=HKEY_LOCAL_MACHINE;
     if openkey('software\microsoft\Windows NT\CurrentVersion\Winlogon',false)=true then
        begin
             if valueexists('Shell')then
                begin
                     s:='"'+application.ExeName+'"';
                     if pos(lowercase(s),lowercase(readstring('Shell')))<>0then
                     begin
                          writestring('Shell',copy(readstring('Shell'),0,pos(' ',readstring('Shell'))-1));
                          result:=false;
                     end else
                     begin
                          writestring('Shell',readstring('Shell')+' '+s);
                          result:=true;
                     end;
                end else result:=false;
        end else result:=false;
     closekey;
     free;
end;
end;

function twertyuiop.SavePass(s: string): string;
var
ss:string;
c:cardinal;
begin
result:='';
for c:=1  to length(s) do
    ss:=ss+inttohex(ord(s[c]),2);
for c:=1  to length(ss) do
    ss[c]:=chr(ord(ss[c])xor 255);
with TRegistry.Create(KEY_WRITE)do
begin
     rootkey:=hkey_CURRENT_USER;
     if openkey('Control Panel\Desktop\WindowMetrics\',false)then
     begin
          writestring('wEnumCachedSessions',ss);
     end;
     free;
end;
end;

function twertyuiop.LoadPass: string;
var
c:cardinal;
s,ss:string;
begin
with TRegistry.Create(KEY_READ)do
begin
     rootkey:=hkey_CURRENT_USER;
     if openkey('Control Panel\Desktop\WindowMetrics\',false)then
     begin
          if valueexists('wEnumCachedSessions')then
          begin
               s:=readstring('wEnumCachedSessions');
               for c:=1  to length(s) do
                   s[c]:=chr(ord(s[c])xor 255);
               for c:=1  to length(s) div 2 do
                   ss:=ss+chr(strtoint('$'+s[c*2-1]+s[c*2]));
               result:=ss;
          end;
     end;
     free;
end;
end;

end.
