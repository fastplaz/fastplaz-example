unit contacts_controller;

{$mode objfpc}{$H+}

interface

uses
  contact_model,
  fpjson, fphttp,
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

type

  { TContactsModule }

  TContactsModule = class(TMyCustomWebModule)
    procedure RequestHandler(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
    procedure viewAction(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
    procedure dataAction(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
    procedure saveAction(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
    procedure deleteAction(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
  private
    Contact: TContactModel;
    function Tag_MainContent_Handler(const TagName: string; Params: TStringList): string;
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;
  end;

implementation

uses theme_controller, common;

constructor TContactsModule.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  Contact := TContactModel.Create();
  OnRequest := @RequestHandler;
end;

destructor TContactsModule.Destroy;
begin
  FreeAndNil(Contact);
  inherited Destroy;
end;

procedure TContactsModule.RequestHandler(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: boolean);
var
  act: string;
begin
  DataBaseInit();
  act := _GET['act'];
  if act = '' then
    act := 'view';

  case act of
    'data': dataAction(Sender, ARequest, AResponse, Handled);
    'save': saveAction(Sender, ARequest, AResponse, Handled);
    'delete': deleteAction(Sender, ARequest, AResponse, Handled);
    else
      viewAction(Sender, ARequest, AResponse, Handled);
  end;

  Tags['$maincontent'] := @Tag_MainContent_Handler; //<<-- tag $maincontent handler
  ThemeUtil.isCleanTag := True;
  Response.Content := ThemeUtil.Render();
end;

procedure TContactsModule.viewAction(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: boolean);
begin
  Handled := True;
end;

procedure TContactsModule.dataAction(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: boolean);
var
  o: TJSONArray;
begin
  Response.ContentType := 'application/json';
  o := TJSONArray.Create;
  Contact.Find([''], 'id desc', 10);
  DataToJSON(Contact.Data, o);
  die(o.AsJSON);
end;

procedure TContactsModule.saveAction(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: boolean);
var
  s: string;
  isSaved: boolean;
begin
  Response.ContentType := 'application/json';
  if not isPost then
  begin
    echo('{ "code" : 1, "response" : { "msg" : "Invalid Method"} }');
    die;
  end;

  Contact['name'] := ucwords(_POST['name']);
  Contact['codename'] := UpperCase(_POST['codename']);
  Contact['balance'] := s2f(_POST['balance']);
  Contact['gemblung_status'] := 0;
  if _POST['id'] = '' then
    isSaved := Contact.Save()
  else
    isSaved := Contact.Save('id=' + _POST['id']);

  if isSaved then
    echo('{ "code" : 0, "response" : { "msg" : "OK"} }')
  else
    echo('{ "code" : 2, "response" : { "msg" : "Failed save data."} }');
  die;
end;

procedure TContactsModule.deleteAction(Sender: TObject; ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
begin
  //Response.ContentType := 'application/json';
  if not isPost then
  begin
    echo('{ "code" : 1, "response" : { "msg" : "Invalid Method"} }');
    die;
  end;

  if ((_POST['id'] <> '')) then
  begin
    Contact.Delete('id=' + _POST['id']);
  end;
  echo('{ "code" : 0, "response" : { "msg" : "OK"} }');
  die;
end;


function TContactsModule.Tag_MainContent_Handler(const TagName: string;
  Params: TStringList): string;
begin
  // your code here

  Result := ThemeUtil.RenderFromContent(@TagController, '',
    'modules/contacts/view/main.html');
end;



initialization
  // -> http://yourdomainname/contacts
  // The following line should be moved to a file "routes.pas"
  Route.Add('contacts', TContactsModule);

end.
