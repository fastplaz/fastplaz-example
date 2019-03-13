program sendmail;

{$mode objfpc}{$H+}

uses
  fpcgi, sysutils, fastplaz_handler, common, main, routes;

begin
  Application.Title:='Sendmail';
  Application.Email := Config.GetValue(_SYSTEM_WEBMASTER_EMAIL,'webmaster@' + GetEnvironmentVariable('SERVER_NAME'));
  Application.DefaultModuleName := Config.GetValue(_SYSTEM_MODULE_DEFAULT, 'main');
  Application.ModuleVariable := Config.GetValue(_SYSTEM_MODULE_VARIABLE, 'mod');
  Application.AllowDefaultModule := True;
  Application.RedirectOnErrorURL := Config.GetValue(_SYSTEM_ERROR_URL, '/');
  Application.RedirectOnError:= Config.GetValue( _SYSTEM_ERROR_REDIRECT, false);

  Application.OnGetModule := @FastPlasAppandler.OnGetModule;
  Application.PreferModuleName := True;
  {$if (fpc_version=3) and (fpc_release>=0) and (fpc_patch>=4)}
  Application.LegacyRouting := True;
  {$endif}

  Application.Initialize;
  Application.Run;
end.
