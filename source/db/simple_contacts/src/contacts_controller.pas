unit contacts_controller;

{$mode objfpc}{$H+}

interface

uses
  contact_model,
  fpjson,
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

type
  TContactsModule = class(TMyCustomWebModule)
    procedure RequestHandler(Sender: TObject; ARequest: TRequest;
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
begin
  DataBaseInit();
  if ((_GET['op'] = 'delete') and (_GET['id'] <> '')) then
  begin
    Contact.Delete('id=' + _GET['id']);
    Redirect('./contacts');
  end;

  if isPost then
  begin
    Contact['name'] := ucwords(_POST['name']);
    Contact['codename'] := UpperCase(_POST['codename']);
    Contact['balance'] := s2f(_POST['balance']);
    if _POST['gemblung_status'] = 'on' then
      Contact['gemblung_status'] := 1
    else
      Contact['gemblung_status'] := 0;
    if _POST['id'] = '' then
      Contact.Save()
    else
      Contact.Save('id=' + _POST['id']);
  end;

  if _GET['id'] <> '' then
  begin
    if Contact.Find(['id=' + _GET['id']]) then
    begin
      ThemeUtil.Assign('$Contact', Contact); //html view --> {$Contact.fieldname}
    end;
  end;

  // find contact list, and send it to theme/view
  Contact.Find([''], 'id desc', 10); // alternative: Contact.All;
  ThemeUtil.Assign('$Contacts', @Contact);

  Tags['$maincontent'] := @Tag_MainContent_Handler; //<<-- tag $maincontent handler
  ThemeUtil.isCleanTag := True;
  Response.Content := ThemeUtil.Render();
  Handled := True;
end;


{
sql := 'SELECT * FROM contacts';
o:= TJSONObject.Create;
QueryOpen(sql,o);
sql := o.AsJSON;
die(sql);
}

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
