unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib, redis_controller;

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
  Redis: TRedisConstroller;
  s: string;
begin
  Redis := TRedisConstroller.Create();
  echo(h3('Redis Example'));

  // if using key/password authentication
  {
  if Redis.Auth( 'yourkeypassword') then
  begin
  end;
  }

  if not Redis.Ping then
  begin
    echo('Not Connected');
  end
  else
  begin
    // set
    Redis['yourkey'] := 'Your data string at ' + DateTimeToStr(now);
    if Redis.LastMessage <> '+OK' then
      echo( 'ERR: ' + Redis.LastMessage + '<br />');

    // get
    s := Redis['yourkey'];
    if (s = '-1') then
      echo('No Data, wrong configuration, or .... ')
    else
      echo('Your Data: ' + s);
  end;

  FreeAndNil(Redis);
  Handled := True;
end;

end.

