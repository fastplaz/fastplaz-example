unit contact_model;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, database_lib;

type
  TContactModel = class(TSimpleModel)
  private
  public
    constructor Create(const DefaultTableName: string = '');
  end;

implementation

constructor TContactModel.Create(const DefaultTableName: string = '');
begin
  inherited Create( DefaultTableName); // table name = contact
  //inherited Create('yourtablename'); // if use custom tablename
  primaryKey:='id';
end;

end.

