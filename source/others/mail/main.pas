unit main;

{$mode objfpc}{$H+}

interface

uses
  mailer_lib,
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

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
  Mailer: TMailer;
begin
  Mailer := TMailer.Create;
  Mailer.MailServer := 'smtp.gmail.com';
  Mailer.UserName := 'your_username';
  Mailer.Password := 'the_password';
  Mailer.Port := '465';
  Mailer.SSL := True;
  Mailer.TLS := True;

  Mailer.Clear;
  Mailer.Sender := 'youremail@yourdomain.id';
  Mailer.Subject := 'This is Subject';
  Mailer.Message.Add('This is <b>bold</b> message.');
  Mailer.AddTo('yourtargetemail@domain.tld');
  if not Mailer.Send then
  begin
    Response.Content := 'ERR: ';
  end;
  Response.Content := Response.Content + Mailer.Logs;
  FreeAndNil(Mailer);

  Response.Content := '<pre>' + Response.Content + '</pre>';
  Handled := True;
end;

end.

