//
// ���������� ��� ���������� �������� �������� ���������
// ����������IT�������8���������.���������������������������������������
// �������� ����� ������.
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
    // �������
    AddFunc('GetScreenShotFromMemory', '������������������������',
      @TGraphicsNative.GetScreenShotFromMemoryFunc, 0);
    AddFunc('GetScreenShot', '����������������',
      @TGraphicsNative.GetScreenShotFunc, 0);

    // ��������
    AddProp('ScreenCompressionQuality', '�����������������������', true, true,
      @TGraphicsNative.PropertyScreenCompressionQualityGetSet);

    AddProp('Version', '������', true, false,
      @TGraphicsNative.PropertyVersionGet);
  end;

end.
