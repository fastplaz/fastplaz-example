unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

type

  { TMainModule }

  TMainModule = class(TMyCustomWebModule)
  private
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
end;

destructor TMainModule.Destroy;
begin
  inherited Destroy;
end;

procedure TMainModule.Get;
var
  i: integer;
begin
  Response.Content := '<H3>Session Example</H3>';

  if _SESSION['exist'] = 'yes' then
  begin
    i := _SESSION['count'] + 1;
    _SESSION['count'] := i;
    Response.Content := Response.Content + '<br>you visit this page ' +
      IntToStr(i) + ' times';
  end
  else
  begin
    Response.Content := Response.Content + '<br><b>THIS IS FIRST TIME</b>';
    _SESSION['exist'] := 'yes';
    _SESSION['count'] := 1;
  end;

  if (_GET['op'] = 'delete') then
  begin
    SessionController.EndSession;
    Redirect('./');
  end;

  echo('<br><br><br>');
  echo('<a href="./?op=delete">End Session</a>');
end;

procedure TMainModule.Post;
begin
  inherited Post;
end;


end.


