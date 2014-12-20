unit main;

{$mode objfpc}{$H+}

interface

uses
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
  i : integer;
begin
  Response.Content := 'Session Example';

  if _SESSION['exist'] = 'yes' then
  begin
    i := _SESSION['count'] + 1;
    _SESSION['count'] := i;
    Response.Content := Response.Content
      + '<br>you visit this page ' + IntToStr(i) + ' times';
  end
  else
  begin
    Response.Content := Response.Content +
      '<br><b>THIS IS FIRST TIME</b>';
    _SESSION['exist'] := 'yes';
    _SESSION['count'] := 1;
  end;

  if (_GET['op'] = 'delete') then
  begin
    SessionController.EndSession;
    Redirect('./');
  end;

  echo('<br><br><br>');
  echo( '<a href="./?op=delete">End Session</a>');
  Handled := True;
end;


end.

