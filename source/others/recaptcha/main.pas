unit main;

{$mode objfpc}{$H+}

interface

uses
  recaptcha_lib,
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

const
  RECAPTCHA_PRIVATE_KEY = 'your_captcha_private_key';

type
  TMainModule = class(TMyCustomWebModule)
    procedure RequestHandler(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
  private
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;
  end;

implementation

uses theme_controller, common;

constructor TMainModule.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  OnRequest := @RequestHandler;
end;

destructor TMainModule.Destroy;
begin
  inherited Destroy;
end;

procedure TMainModule.RequestHandler(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
var
  infoString : string;
begin
  if isPost then
  begin
    with TReCaptcha.Create( RECAPTCHA_PRIVATE_KEY) do
    begin
      if isValid() then
        infoString := '<b>Verified</b>'
      else
        infoString := ErrorCodes;
      Free;
    end;
  end;

  ThemeUtil.Assign( 'info', infoString);
  Response.Content := ThemeUtil.Render();
  Handled := True;
end;

end.

