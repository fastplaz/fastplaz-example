unit main;

{$mode objfpc}{$H+}

interface

uses
  json_lib,
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

{
  will result:

  {
    "code" : 0,
    "result" : {
      "msg" : "OK",
      "count" : 1,
      "data" : "This is data"
    }
  }

}
procedure TMainModule.Get;
var
  json: TJSONUtil;
begin
  json := TJSONUtil.Create;

  json['code'] := int(0);
  json['result/msg'] := 'OK';
  json['result/count'] := int(1);
  json['result/data'] := 'This is data';

  Response.ContentType := 'application/json';
  Response.Content := json.AsJSONFormated;
  FreeAndNil(json);
end;

procedure TMainModule.Post;
begin
end;


end.

