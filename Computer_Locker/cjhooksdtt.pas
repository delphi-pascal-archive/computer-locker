unit cjhooksdtt;

interface

uses
  Windows, Classes;

type
  TCjShiftState=set of(cssShift,cssRShift,cssLShift,
      cssControl,cssRControl,cssLControl,cssAlt,cssRAlt,
      cssLAlt,cssWin,cssRWin,cssLWin,cssEsc,cssContext,
      cssMouse,cssLMouse,cssRMouse,cssMMouse);

  TKeys=array[1..255]of boolean;

  THookKeyEvent=procedure(sender:Tobject;Shift:TCjShiftState;Key:byte)of object;


  TCjHookDTT = class;

  TBreakMode = (thSuspend, thTerminate);

  TExtThread = class(TThread)
  private
    FOwner: TCjHookDTT;
    FStop:  THandle;
  protected
    procedure Execute; override;
  end;

  TCjHookDTT = class(TComponent)
  private
    FOnKeyDown,FOnKeyPress,FOnKeyUp:THookKeyEvent;
    FOnKeyScan:TNotifyEvent;
    FExtThread: TExtThread;
    pr:array[1..255]of boolean;
    FEnabled:  boolean;
    FThreadPriority: TThreadPriority;
    FInterval: cardinal;
    FHW:HWND;
    procedure DoTimer;

    procedure SetEnabled(const Value: boolean);
    procedure SetInterval(const Value: cardinal);
    procedure SetThreadPriority(const Value: TThreadPriority);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property HookedWindow:HWND read FHW;
  published
    property OnKeyScan:TNotifyEvent read FONKEYSCAN write FONKEYSCAN;
    property OnKeyDown: THookKeyEvent Read FOnKeyDown Write FOnKeyDown;
    property OnKeyPress: THookKeyEvent Read FOnKeyPress Write FOnKeyPress;
    property OnKeyUp: THookKeyEvent Read FOnKeyUp Write FOnKeyUp;
    property Enabled: boolean Read FEnabled Write SetEnabled;
    property Interval: cardinal Read FInterval Write SetInterval;
    property ThreadPriority: TThreadPriority
      Read FThreadPriority Write SetThreadPriority;
  end;

procedure Register;

const

{Cj Key Const's}
     key_escape=27;
     
     key_f1=112;
     key_f2=113;
     key_f3=114;
     key_f4=115;
     key_f5=116;
     key_f6=117;
     key_f7=118;
     key_f8=119;
     key_f9=120;
     key_f10=121;
     key_f11=122;
     key_f12=123;

     key_print_screen=44;
     key_Scroll_lock=145;
     key_pause=19;

     key_0=48;
     key_1=49;
     key_2=50;
     key_3=51;
     key_4=52;
     key_5=53;
     key_6=54;
     key_7=55;
     key_8=56;
     key_9=57;

     key_delete=46;
     key_home=36;
     key_page_up=33;
     key_page_down=34;
     key_end=35;
     key_tab=9;
     key_caps_lock=20;
     key_insert=45;
     key_context_menu=93;
     key_return=13;
     key_space=32;
     key_backspace=8;

     //controls,shifts,windows,alts
     key_shift=16;
     key_left_shift=160;
     key_right_shift=161;
     key_control=17;
     key_left_control=162;
     key_right_control=163;
     key_left_alt=164;
     key_right_alt=165;
     key_alt=18;
     key_left_windows=91;
     key_right_windows=92;

     //arrows
     key_left_arrow=37;
     key_up_arrow=38;
     key_right_arrow=39;
     key_down_arrow=40;

     //num pad
     key_num_lock=145;
     key_num_divide=111;
     key_num_multiply=106;
     key_num_decrease=109;
     key_num_increase=107;
     key_num_delete=96;
     key_num0=96;
     key_num1=97;
     key_num2=98;
     key_num3=99;
     key_num4=100;
     key_num5=101;
     key_num6=102;
     key_num7=103;
     key_num8=104;
     key_num9=105;

     //mouse
     mouse_button_left=1;
     mouse_button_right=2;
     mouse_button_middle=4;

     key_mouse_left=mouse_button_left;
     key_mouse_right=mouse_button_right;
     key_mouse_middle=mouse_button_middle;

     //extendedkeys
     key_volume_mute=173;
     key_volume_inc=175;
     key_volume_dec=174;

     key_mail=172;
     key_sleep_mode=95;
     key_play=179;
     key_stop=178;
     key_backward=177;
     key_forward=176;
     key_run=171;
     key_programs=255;

implementation

procedure Register;
begin
  RegisterComponents('CH Pack', [TCjHookDTT]);
end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure TExtThread.Execute;
begin
  repeat
    if WaitForSingleObject(FStop, FOwner.Interval) = WAIT_TIMEOUT then
      Synchronize(FOwner.DoTimer);
  until Terminated;
end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
constructor TCjHookDTT.Create(AOwner: TComponent);
var
j:cardinal;
begin
  inherited Create(AOwner);
  FEnabled   := False;
  FInterval  := 1000;
  FThreadPriority := tpNormal;
  FExtThread := TExtThread.Create(True);
  FExtThread.FOwner := Self;
  FExtThread.Priority := tpNormal;
  FExtThread.FStop := CreateEvent(nil, False, False, nil);
  FHW:=0;
  for j:=1  to 255 do
  begin
  pr[j]:=false;
  end;
  end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
destructor TCjHookDTT.Destroy;
begin
  Enabled := False;

  FExtThread.Terminate;
  SetEvent(FExtThread.FStop);
  if FExtThread.Suspended then
    FExtThread.Resume;

  FExtThread.WaitFor;
  CloseHandle(FExtThread.FStop);
  FExtThread.Free;

  inherited Destroy;
end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure TCjHookDTT.DoTimer;
function keystate(key1:byte):boolean;
begin
if (getkeystate(key1)=-128)or
   (getkeystate(key1)=-127)then result:=true else result:=false;
end;
function SS:TCjShiftState;
var
s:TCjShiftState;
begin
s:=[];
if keystate(key_shift)then s:=s+[cssShift];
if keystate(key_left_shift)then s:=s+[cssLShift];
if keystate(key_right_shift)then s:=s+[cssRShift];
if keystate(key_control)then s:=s+[cssControl];
if keystate(key_left_control)then s:=s+[cssLControl];
if keystate(key_right_control)then s:=s+[cssRControl];
if keystate(key_alt)then s:=s+[cssalt];
if keystate(key_left_alt)then s:=s+[cssLAlt];
if keystate(key_right_alt)then s:=s+[cssRalt];
if keystate(key_left_windows)or
   keystate(key_right_windows)then s:=s+[cssWin];
if keystate(key_left_windows)then s:=s+[cssLWin];
if keystate(key_right_windows)then s:=s+[cssRWin];
if keystate(key_escape)then s:=s+[cssEsc];
if keystate(key_context_menu)then s:=s+[cssContext];
if keystate(mouse_button_left)then s:=s+[cssLMouse];
if keystate(mouse_button_right)then s:=s+[cssRMouse];
if keystate(mouse_button_middle)then s:=s+[cssMMouse];
if keystate(mouse_button_left)or
   keystate(mouse_button_right)or
   keystate(mouse_button_middle)then s:=s+[cssMouse];
SS:=s;
end;
procedure dow(k:byte);
begin
{down}
FHW:=getforegroundwindow;
if assigned(onkeydown)then onkeydown(self,ss,k);
end;
procedure pre(k:byte);
begin
{press}
FHW:=getforegroundwindow;
if assigned(onkeypress)then onkeypress(self,ss,k);
end;
procedure up(k:byte);
begin
{up}
FHW:=getforegroundwindow;
if assigned(onkeyup)then onkeyup(self,ss,k);
end;

var
j:integer;
begin
  if FEnabled and not (csDestroying in ComponentState) then
    try
    for j:=1 to 255 do
    begin
       if (keystate(j)=true)and(pr[j]=false)then
       begin
            pr[j]:=true;
            {down}
            dow(j);
            pre(j);
       end else if (keystate(j)=true)and(pr[j]=true)then {pressed}pre(j)else
       if (keystate(j)=false)and(pr[j]=true)then
            begin
                 pr[j]:=false;
                 up(j);
                 {up}
            end;
    end;
    except
    end;
if assigned(onkeyscan)then onkeyscan(self);
end;


procedure TCjHookDTT.SetEnabled(const Value: boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    // Enable = True
    if FEnabled then
    begin
      if (FInterval > 0) then
      begin
        SetEvent(FExtThread.FStop);
        FExtThread.Resume;
      end;
    end
    // Enable = False
    else
      FExtThread.Suspend;
  end;
end;

procedure TCjHookDTT.SetInterval(const Value: cardinal);
var
  tmpEnabled:  boolean;
{  tmpInterval: cardinal;
}begin
  if Value <> FInterval then
  begin
    tmpEnabled  := FEnabled;
{    tmpInterval := FInterval;
}    Enabled     := False;

    if (FInterval = 0) then
      FInterval := {tmpInterval}1
    else
      FInterval := Value;

    Enabled := tmpEnabled;
  end;
end;

procedure TCjHookDTT.SetThreadPriority(const Value: TThreadPriority);
begin
  if FThreadPriority <> Value then
  begin
    FExtThread.Priority := Value;
    FThreadPriority     := FExtThread.Priority;
  end;
end;


end.
