unit UInvoices;

interface
uses
  System.SysUtils,

  EasyDB.Migration.Attrib,
  EasyDB.ConnectionManager.SQL,
  EasyDB.Logger,
  EasyDB.Attribute,
  UHelper;

type

  [CustomMigrationAttribute('TbInvoices', 202301010005, 'Created TbInvoices table', 'Alex')]
  TInvoicesMgr_202301010005 = class(TMigrationEx)
  public
    procedure Upgrade; override;
    procedure Downgrade; override;
  end;

  [CustomMigrationAttribute('TbInvoices', 202301010010, 'Altered TbInvoices table, added NewField1 as varchar(100)', 'Alex')]
  TInvoicesMgr_202301010010 = class(TMigrationEx)
  public
    procedure Upgrade; override;
    procedure Downgrade; override;
  end;

implementation

{ TInvoicesMgr_202301010005 }

procedure TInvoicesMgr_202301010005.Downgrade;
var
  LvScript: string;
begin
  try
    SQL.ExecuteAdHocQuery('Drop Table TbInvoices');
  except on E: Exception do
    Logger.Log(atDowngrade, E.Message, AttribEntityName, AttribVersion);
  end;
end;

procedure TInvoicesMgr_202301010005.Upgrade;
var
  LvScript: string;
begin
  LvScript := 'If Not Exists( Select * From sysobjects Where Name = ''TbInvoices'' And xtype = ''U'') ' + #10
       + '    Create Table TbInvoices( ' + #10
       + '    	ID Int Primary key Identity(1, 1) Not null, ' + #10
       + '    	InvoiceID Int, ' + #10
       + '    	CustomerID Int, ' + #10
       + '    	InvoiceDate Datetime ' + #10
       + '    );';

  try
    SQL.ExecuteAdHocQuery(LvScript);
  except on E: Exception do
    Logger.Log(atUpgrade, E.Message, AttribEntityName, AttribVersion);
  end;
end;

{ TInvoicesMgr_202301010010 }

procedure TInvoicesMgr_202301010010.Downgrade;
var
  LvScript: string;
begin
  try
    SQL.ExecuteAdHocQuery('Alter table TbInvoices Drop Column TotlaAmount');
  except on E: Exception do
    Logger.Log(atDownGrade, E.Message, AttribEntityName, AttribVersion);
  end;
end;

procedure TInvoicesMgr_202301010010.Upgrade;
var
  LvScript: string;
begin
  try
    SQL.ExecuteAdHocQuery('Alter table TbInvoices Add TotlaAmount Decimal(10, 2)');
  except on E: Exception do
    Logger.Log(atUpgrade, E.Message, AttribEntityName, AttribVersion);
  end;
end;

end.

