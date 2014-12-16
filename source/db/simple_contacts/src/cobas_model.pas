unit cobas_model;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, database_lib;

type
  TCobasModel = class(TSimpleModel)
  private
  public
    constructor Create(const DefaultTableName: string = '');
  end;

implementation

constructor TCobasModel.Create(const DefaultTableName: string = '');
begin
  inherited Create( DefaultTableName); // table name = cobas
  //inherited Create('yourtablename'); // if use custom tablename
end;

end.

