//
// Необходимо при обнолвении изменить значение процедуры
// УправлениеITОтделом8УФПовтИсп.ПолучитьВерсиюИнтегрированнойКомпоненты
// исправив номер версии.
//

library UniNative;

uses
  System.SysUtils,
  System.Classes,
  uGraphicsNative in 'uGraphicsNative.pas',
{$IFDEF X32}
  v8napi_x32 in 'v8napi_x32.pas'
{$ELSE}
  v8napi_x64 in 'v8napi_x64.pas'
{$ENDIF};

{$R *.res}

begin
  with ClassRegList.RegisterClass(TGraphicsNative, 'GraphicsNative',
    'TGraphicsNative') do
  begin
    // Функции
    AddFunc('GetScreenShotFromMemory', 'ПолучитьСкриншотИзПамяти',
      @TGraphicsNative.GetScreenShotFromMemoryFunc, 0);
    AddFunc('GetScreenShot', 'ПолучитьСкриншот',
      @TGraphicsNative.GetScreenShotFunc, 0);

    // Свойства
    AddProp('ScreenCompressionQuality', 'КачествоСжатияСкриншота', true, true,
      @TGraphicsNative.PropertyScreenCompressionQualityGetSet);

    AddProp('Version', 'Версия', true, false,
      @TGraphicsNative.PropertyVersionGet);
  end;

end.
