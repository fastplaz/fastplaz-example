unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

type
  TMainModule = class(TMyCustomWebModule)
    procedure RequestHandler(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
  private
    function Tag_MainContent_Handler(const TagName: string; Params: TStringList): string;
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
begin
  Response.Content := 'Session Example';
  if _SESSION['exist'] <> 'yes' then
  begin
    Response.Content := Response.Content +
      '<br><b>THIS IS FIRST TIME</b>';
    _SESSION['exist'] := 'yes';
  end;
  Handled := True;
end;

function TMainModule.Tag_MainContent_Handler(const TagName: string; Params: TStringList): string;
begin
end;


end.

