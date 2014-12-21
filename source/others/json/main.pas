unit main;

{$mode objfpc}{$H+}

interface

uses
  fpjson,
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

{
  will result:

  {
    "code" : 0,
    "response" : {
      "msg" : "OK",
      "count" : "1",
      "data" : "this is data"
    }
  }

}
procedure TMainModule.RequestHandler(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
var
  o, poResponse : TJSONObject;
begin
  //Response.ContentType := 'application/json';

  o := TJSONObject.Create;
  poResponse := TJSONObject.Create;
  poResponse.Add( 'msg', 'OK');
  poResponse.Add( 'count', '1');
  poResponse.Add( 'data', 'this is data');
  o.Add( 'code', 0);
  o.Add( 'response', poResponse);


  Response.Content := o.AsJSON;
  Handled := True;

  FreeAndNil( o);
end;



end.

