//
// Необходимо при обнолвении изменить значение процедуры
// УправлениеITОтделом8УФПовтИсп.ПолучитьВерсиюИнтегрированнойКомпоненты
// исправив номер версии.
//

unit uGraphicsNative;

{$M+}

interface

uses
{$IFDEF X32}
v8napi_x32,
{$ELSE}
v8napi_x64,
{$ENDIF}
SysUtils, Windows, Vcl.Graphics, System.Classes, Vcl.Imaging.jpeg,
  Vcl.Clipbrd, Vcl.Forms;

const
  UniNativeVersion = '1.0.1.0';

type
  TGraphicsNative = class(TV8UserObject)
  private
    FScreenCompressionQuality: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    // Поулчить скриншот, который находится в буфере
    // Возвращает ДвоичныеДанные скриншота, который находится в памяти
    // или Неопределно, если скриншота нет в буфере
    function GetScreenShotFromMemoryFunc(RetValue: PV8Variant;
      Params: PV8ParamArray; const ParamCount: Integer;
      var v8: TV8AddInDefBase): Boolean;

    // Получить скриншот экрана
    // Возвращает ДвоичныеДанные скриншота
    function GetScreenShotFunc(RetValue: PV8Variant; Params: PV8ParamArray;
      const ParamCount: Integer; var v8: TV8AddInDefBase): Boolean;

    // Получает/устанавливает степень качества скриншотов
    function PropertyScreenCompressionQualityGetSet(propValue: PV8Variant;
      Get: Boolean; var v8: TV8AddInDefBase): Boolean;

    function PropertyVersionGet(propValue: PV8Variant;
      Get: Boolean; var v8: TV8AddInDefBase): Boolean;

  published
    property ScreenCompressionQuality: Integer read FScreenCompressionQuality
      write FScreenCompressionQuality;
  end;

implementation

{ TGraphicsNative }

constructor TGraphicsNative.Create;
begin
  inherited;

  FScreenCompressionQuality := 100;
end;

destructor TGraphicsNative.Destroy;
begin
  inherited;
end;

function TGraphicsNative.GetScreenShotFromMemoryFunc(RetValue: PV8Variant;
  Params: PV8ParamArray; const ParamCount: Integer;
  var v8: TV8AddInDefBase): Boolean;
var
  jpeg: TJPEGImage;
  Bitmap: TBitmap;
  Stream: TMemoryStream;
begin
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    Bitmap := TBitmap.Create;
    jpeg := TJPEGImage.Create;
    Stream := TMemoryStream.Create;
    try
      Bitmap.LoadFromClipboardFormat(CF_BITMAP,
        Clipboard.GetAsHandle(CF_BITMAP), 0);
      jpeg.Assign(Bitmap);
      jpeg.CompressionQuality := FScreenCompressionQuality;
      jpeg.SaveToStream(Stream);
      Stream.Position := 0;
      V8SetBlob(RetValue, Stream.Memory, Stream.Size);
    finally
      Stream.Free;
      jpeg.Free;
      Bitmap.Free;
    end;
  end
  else
  begin
    V8ClearVar(RetValue);
  end;

  Result := true;
end;

function TGraphicsNative.GetScreenShotFunc(RetValue: PV8Variant;
  Params: PV8ParamArray; const ParamCount: Integer;
  var v8: TV8AddInDefBase): Boolean;
Var
  Bitmap: TBitmap;
  jpeg: TJPEGImage;
  Stream: TMemoryStream;
  DC: HDC;
begin
  Bitmap := TBitmap.Create;
  jpeg := TJPEGImage.Create;
  Stream := TMemoryStream.Create;
  try

    Bitmap.Height := Screen.Height;
    Bitmap.Width := Screen.Width;
    DC := GetDC(0);
    Bitblt(Bitmap.Canvas.Handle, 0, 0, Screen.Width, Screen.Height, DC, 0,
      0, SRCCOPY);
    ReleaseDC(0, DC);

    jpeg.Assign(Bitmap);
    jpeg.CompressionQuality := FScreenCompressionQuality;

    jpeg.SaveToStream(Stream);
    Stream.Position := 0;
    V8SetBlob(RetValue, Stream.Memory, Stream.Size);

  finally

    // Очищаем память.
    Stream.Free;
    jpeg.Free;
    Bitmap.Free;

  end;

  Result := true;

end;

function TGraphicsNative.PropertyScreenCompressionQualityGetSet
  (propValue: PV8Variant; Get: Boolean; var v8: TV8AddInDefBase): Boolean;
begin
  if Get then
    V8SetInt(propValue, FScreenCompressionQuality)
  else
    FScreenCompressionQuality := V8AsInt(propValue);

  Result := true;
end;

function TGraphicsNative.PropertyVersionGet(propValue: PV8Variant; Get: Boolean;
  var v8: TV8AddInDefBase): Boolean;
begin

  if Get then
    V8SetWString(propValue, UniNativeVersion);

  Result := true;

end;

end.
