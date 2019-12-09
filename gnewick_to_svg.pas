unit gnewick_to_svg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, gtreelist, gsvgwriter;

type

  { TNewickToSvg }

  TNewickToSvg = class(TObject)
    private
      FLog: TStringList;
    protected
      FNewick: String;
      FTreeList: TTimeTreeList;
      FSvgWriter: TTimetreeSvgWriter;
    public
      constructor Create(newick: String);
      destructor Destroy; override;
      function DrawSvg(filename: String): Boolean;

      property Log: TStringList read FLog;
  end;

implementation

{ TNewickToSvg }

constructor TNewickToSvg.Create(newick: String);
begin
  FNewick := newick;
  FTreeList := TTimeTreeList.Create;
  FSvgWriter := TTimetreeSvgWriter.Create;
  FLog := TStringList.Create;
end;

destructor TNewickToSvg.Destroy;
begin
  if Assigned(FTreeList) then
    FTreeList.Free;
  if Assigned(FSvgWriter) then
    FSvgWriter.Free;
  if Assigned(FLog) then
    FLog.Free;
  inherited Destroy;
end;

function TNewickToSvg.DrawSvg(filename: String): Boolean;
begin
  Result := False;
  try
    try
      if not FTreeList.ImportFromNewick(FNewick, nil) then
        raise Exception.Create('failed to parse the input newick string');
      FSvgWriter.SetData(FTreeList);
      FSvgWriter.GenerateSvgStrings(filename);
      Result := FileExists(filename);
      if not Result then
        FLog.Add('SVG file does not exist - cause unknown');
    except
      on E:Exception do
      begin
        FLog.Add(E.Message);
      end;
    end;
  finally
  end;
end;

end.
