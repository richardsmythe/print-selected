unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, shellapi, Vcl.ComCtrls,
  Vcl.FileCtrl;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button2: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ListFiles(Path: string; FileList: TStrings);

  end;

var
  Form1: TForm1;
  sDir: string;

implementation

{$R *.dfm}
{ TForm1 }

procedure getSelectedItems(ListBox: TListBox; List: TStringlist);
var
  i: Integer;

begin
  List.Clear;
  for i := 0 to ListBox.Items.Count - 1 do
    if ListBox.Selected[i] then
      List.AddObject(ListBox.Items[i], ListBox.Items.Objects[i]);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
  sFiles, s, fileName: string;
  selectedItems: TStringlist; // tstringlist variable to store stringlist object
begin
  // create a new instance of the stringlist object and assign our variable to it
  selectedItems := TStringlist.Create;

  // pass the data to the procedure
  getSelectedItems(ListBox1, selectedItems);

  // store the strings in local variable
  sFiles := selectedItems.Text;
  if sFiles <> '' then
  begin

    // extract contents using
    extractStrings([], [], pChar(sFiles), Memo1.lines);
    Label1.caption := 'The following files will be printed:';
    Label1.Visible := true;
    Memo1.Visible := true;

    // send strings to shellexecute
    for i := 0 to ListBox1.Count - 1 do
      ShellExecute(Handle, 'print', pChar(Memo1.lines[i]), nil, nil, SW_SHOW);

    // free the object from memory when done
    selectedItems.Free;
  end
  else
    showmessage('Nothing selected');
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ListBox1.Clear;
  sDir := 'C:\Users\danpas\Desktop\test\';
  ListFiles(sDir, ListBox1.Items);
end;

procedure TForm1.ListFiles(Path: string; FileList: TStrings);
var
  searchResults: TSearchRec;
  fileAttributes: Integer;
begin
  ListBox1.MultiSelect := true;
  fileAttributes := faDirectory;
  if FindFirst(Path + '*.doc*', faAnyFile, searchResults) = 0 then
  begin
    repeat
      if (searchResults.Attr <> fileAttributes) then // if not a directory
      begin
        // show full file name used for printing
        FileList.add(Path + searchResults.Name);
      end;
    until FindNext(searchResults) <> 0;
    FindClose(searchResults);
  end;

end;

end.
