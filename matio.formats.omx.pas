unit matio.formats.omx;

////////////////////////////////////////////////////////////////////////////////
//
// Author: Jaap Baak
// https://github.com/transportmodelling/matio
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
interface
////////////////////////////////////////////////////////////////////////////////

Uses
  SysUtils, Types, Propset, matio, matio.formats, matio.formats.hdf5, matio.hdf5, matio.hdf5.omx;

Type
  TOMXMatrixReaderFormat = Class(THdf5MatrixReaderFormat)
  public
    Function Format: String; override;
    Function HasFormat(const FileExtension: String): Boolean; override;
    Function CreateReader(const [ref] Properties: TPropertySet): TMatrixReader; override;
    Function CreateReader(const [ref] Properties: TPropertySet; const Selection: array of String): TMatrixReader; override;
  end;

  TOMXMatrixWriterFormat = Class(THdf5MatrixWriterFormat)
  public
    Function Format: String; override;
    Function CreateWriter(const [ref] Properties: TPropertySet;
                          const FileLabel: string;
                          const MatrixLabels: array of String;
                          const Size: Integer): TMatrixWriter; override;
  end;

////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////

Function TOMXMatrixReaderFormat.Format: String;
begin
  Result := 'omx';
end;

Function TOMXMatrixReaderFormat.HasFormat(const FileExtension: String): Boolean;
begin
  Result := SameText(FileExtension,'.omx');
end;

Function TOMXMatrixReaderFormat.CreateReader(const [ref] Properties: TPropertySet): TMatrixReader;
begin
  if SameText(Properties[FormatProperty],Format) then
    Result := TOMXMatrixReader.Create(Properties.ToPath(FileProperty))
  else
    raise Exception.Create('Invalid format-property');
end;

Function TOMXMatrixReaderFormat.CreateReader(const [ref] Properties: TPropertySet; const Selection: array of String): TMatrixReader;
begin
  if SameText(Properties[FormatProperty],Format) then
    Result := TOMXMatrixReader.Create(Properties.ToPath(FileProperty),Selection)
  else
    raise Exception.Create('Invalid format-property');
end;

////////////////////////////////////////////////////////////////////////////////

Function TOMXMatrixWriterFormat.Format: String;
begin
  Result := 'omx';
end;

Function TOMXMatrixWriterFormat.CreateWriter(const [ref] Properties: TPropertySet;
                                             const FileLabel: string;
                                             const MatrixLabels: array of String;
                                             const Size: Integer): TMatrixWriter;
begin
  if SameText(Properties[FormatProperty],Format) then
  begin
    var ExtendedProperties := ExtendProperties(Properties);
    var PrecisionPropertyValue := ExtendedProperties[PrecisionProperty];
    for var Prec := low(THdf5Precision) to high(THdf5Precision) do
    if SameText(PrecisionLabels[Prec],PrecisionPropertyValue) then
    begin
      Result := TOMXMatrixWriter.Create(ExtendedProperties.ToPath(FileProperty),FileLabel,MatrixLabels,Size,Prec);
      Exit;
    end;
    raise Exception.Create('Invalid precision-property');
  end else
    raise Exception.Create('Invalid format-property');
end;

end.
