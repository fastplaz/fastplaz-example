unit main;

{$mode objfpc}{$H+}

interface

uses
  recaptcha_lib,
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

const
  RECAPTCHA_PRIVATE_KEY = 'your_captcha_private_key';

type

  { TMainModule }

  TMainModule = class(TMyCustomWebModule)
  private
    FInfoString: string;
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
  end;

implementation

uses theme_controller, common;

constructor TMainModule.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  FInfoString := '';
end;

destructor TMainModule.Destroy;
begin
  inherited Destroy;
end;

procedure TMainModule.Get;
begin
  ThemeUtil.Assign('info', FInfoString);
  Response.Content := ThemeUtil.Render();
end;

procedure TMainModule.Post;
begin
  with TReCaptcha.Create(RECAPTCHA_PRIVATE_KEY) do
  begin
    if isValid() then
      FInfoString := '<b>Verified</b>'
    else
      FInfoString := ErrorCodes;
    Free;
  end;
  ThemeUtil.Assign('info', FInfoString);
  Response.Content := ThemeUtil.Render();
end;

end.
