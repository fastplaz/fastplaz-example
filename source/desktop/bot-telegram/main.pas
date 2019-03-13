{
This file is part of the FastPlaz example.
(c) Luri Darmawan <luri@fastplaz.com>

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
}
unit main;
{
  This Project is Telegram Bot Example,
  using Poll method.

  WebHook method is recommended

}

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix}
  cthreads,
  cmem,
  {$endif}

  common, fpjson,
  telegram_integration,
  Messages, Classes, SysUtils, FileUtil, SynEdit, SynHighlighterJScript, LCLType,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Spin, Types;

type

  TShowStatusEvent = procedure(Status: string) of object;
  TFinishEvent = procedure of object;

  { TPollThread }

  TPollThread = class(TThread)
  private
    FOnFinish: TFinishEvent;
    FStatusText: string;
    FOnShowStatus: TShowStatusEvent;
    procedure showStatus;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    property OnShowStatus: TShowStatusEvent read FOnShowStatus write FOnShowStatus;
    property OnFinish: TFinishEvent read FOnFinish write FOnFinish;
  end;

  { TfApp }

  TfApp = class(TForm)
    btn_Toggle: TToggleBox;
    btn_GetUpdates: TButton;
    edt_To: TEdit;
    edt_Message: TEdit;
    edt_Token: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Log: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    btn_Send: TSpeedButton;
    Panel6: TPanel;
    Panel7: TPanel;
    pnl_Timer: TPanel;
    edt_Interval: TSpinEdit;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    editor: TSynEdit;
    SynJScriptSyn1: TSynJScriptSyn;
    tmr_Poll: TTimer;
    procedure btn_SendClick(Sender: TObject);
    procedure btn_ToggleChange(Sender: TObject);
    procedure btn_GetUpdatesClick(Sender: TObject);
    procedure edt_MessageKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure tmr_PollTimer(Sender: TObject);
  private
    json: TJSONData;
    FUpdateID: integer;
    FisProcessing: boolean;
    pollThread: TPollThread;
    Telegram: TTelegramIntegration;
    procedure addChat(AFrom, AText: string);
    procedure addLogText(AText: string);
    procedure doShowStatus(Status: string);
    procedure doFinish;
  public
    function GetTelegramMessage: boolean;
    procedure ProcessMessages;
    procedure SendMessage(ATo, AMessage: string);
  end;

var
  fApp: TfApp;

implementation

{$R *.lfm}

{ TPollThread }

procedure TPollThread.showStatus;
begin
  if Assigned(FOnShowStatus) then
  begin
    FOnShowStatus(FStatusText);
  end;
end;

constructor TPollThread.Create(CreateSuspended: boolean);
begin
  FStatusText := '';
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

{ TfApp }

procedure TfApp.FormCreate(Sender: TObject);
begin
  inherited;
  FUpdateID := 0;
  FisProcessing := False;
  edt_Token.Text := 'YourToken';
  Telegram := TTelegramIntegration.Create;
  editor.Clear;
end;

procedure TfApp.FormDestroy(Sender: TObject);
begin
  Telegram.Free;
  if Assigned(json) then
    json.Free;
  inherited;
end;

procedure TfApp.edt_MessageKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    key := 0;
    btn_Send.Click;
  end;
end;

procedure TfApp.btn_SendClick(Sender: TObject);
begin
  if edt_To.Text = '' then
    Exit;
  if edt_Message.Text = '' then
    Exit;

  Telegram.Token := edt_Token.Text;
  Telegram.SendMessage(edt_To.Text, edt_Message.Text);
  addChat('You', edt_Message.Text);
  edt_Message.Clear;
end;

procedure TfApp.btn_ToggleChange(Sender: TObject);
begin
  if btn_Toggle.Checked then
  begin
    btn_Toggle.Caption := '&Stop';
  end
  else
  begin
    btn_Toggle.Caption := '&Start';
  end;

  if not tmr_Poll.Enabled then
  begin
    tmr_Poll.Interval := edt_Interval.Value * 1000;
    Telegram.Token := edt_Token.Text;
  end;
  pnl_Timer.Enabled := not btn_Toggle.Checked;
  tmr_Poll.Enabled := btn_Toggle.Checked;
end;

procedure TfApp.btn_GetUpdatesClick(Sender: TObject);
begin

  editor.Clear;
  with TPollThread.Create(True) do
  begin
    OnShowStatus := @doShowStatus;
    OnFinish := @doFinish;
    Start;
  end;

end;

procedure TfApp.tmr_PollTimer(Sender: TObject);
begin
  if FisProcessing then
    Exit;
  FisProcessing := True;

  btn_GetUpdates.Click;
end;

procedure TfApp.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = 27 then
  begin
    key := 0;
    Close;
  end;
end;

procedure TfApp.addChat(AFrom, AText: string);
var
  s: string;
begin
  s := FormatDateTime('HH:nn:ss', Now) + ' ' + AFrom + ': ' + AText;
  addLogText(s);
end;

procedure TfApp.addLogText(AText: string);
begin
  Log.Lines.Add(AText);
end;

procedure TfApp.doShowStatus(Status: string);
begin
  //addLogText(Status);
end;

procedure TfApp.doFinish;
begin
  FisProcessing := False;
end;

procedure TPollThread.Execute;
begin
  FStatusText := 'start';
  Synchronize(@Showstatus);

  fApp.GetTelegramMessage;

  FStatusText := 'stop';
  Synchronize(@Showstatus);

  if Assigned(FOnFinish) then
  begin
    FOnFinish();
  end;
end;

function TfApp.GetTelegramMessage: boolean;
begin
  Result := False;
  Telegram.Token := edt_Token.Text;
  editor.Text := JsonFormatter(Telegram.getUpdates(FUpdateID));
  json := GetJSON(editor.Text);
  ProcessMessages;
end;

procedure TfApp.SendMessage(ATo, AMessage: string);
begin
  Telegram.Token := edt_Token.Text;
  Telegram.SendMessage(ATo, AMessage);
  addChat('You', AMessage);
end;

procedure TfApp.ProcessMessages;
var
  i: integer;
  message, chatID, userName: string;
begin
  i := 0;
  message := '';
  repeat
    message := jsonGetData(json, 'result[' + i2s(i) + ']/message/text');
    if message = '' then
      exit;
    chatID := jsonGetData(json, 'result[' + i2s(i) + ']/message/chat/id');
    userName := jsonGetData(json, 'result[' + i2s(i) + ']/message/chat/username');
    FUpdateID := s2i(jsonGetData(json, 'result[' + i2s(i) + ']/update_id')) + 1;
    edt_To.Text := chatID;
    addLogText(chatID + ': ' + userName + ': ' + message);

    // Explore you idea from HERE
    if message = 'hi' then
      SendMessage(chatID, 'hello');

    //---
    i := i + 1;
  until message = '';
end;


end.
