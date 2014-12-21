program contacts;

{$mode objfpc}{$H+}

uses
  fpcgi, sysutils, fastplaz_handler, common, main, routes, contacts_controller, contact_model;

begin
  Application.Title:='Simple Contacts';
  Application.Email := Config.GetValue(_SYSTEM_WEBMASTER_EMAIL,'webmaster@' + GetEnvironmentVariable('SERVER_NAME'));
  Application.DefaultModuleName := Config.GetValue(_SYSTEM_MODULE_DEFAULT, 'main');
  Application.ModuleVariable := Config.GetValue(_SYSTEM_MODULE_VARIABLE, 'mod');
  Application.AllowDefaultModule := True;
  Application.RedirectOnErrorURL := Config.GetValue(_SYSTEM_ERROR_URL, '/');
  Application.RedirectOnError:= Config.GetValue( _SYSTEM_ERROR_REDIRECT, false);

  Application.OnGetModule := @FastPlasAppandler.OnGetModule;
  Application.PreferModuleName := True;

  //Application.OnException:= @FastPlasAppandler.ExceptionHandler;
  Application.Initialize;
  Application.Run;
end.
