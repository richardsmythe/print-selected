unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, shellapi, Vcl.ComCtrls,
  Vcl.FileCtrl, FlCtrlEx;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button2: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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

uses inputQuery_U;
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
    Label1.Visible := True;
    Memo1.Visible := True;

    // send strings to shellexecute
    for i := 0 to ListBox1.Count - 1 do
      ShellExecute(Handle, 'print', pChar(Memo1.lines[i]), nil, nil, SW_SHOW);

    // free the object from memory when done
    selectedItems.Free;
  end
  else
    showmessage('Nothing selected');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  form2.show;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  startDir: string;
  chosenDir: string;
begin
  // sDir := 'C:\Users\danpas\Desktop\test\';
  SelectDirectory('Your caption', startDir, chosenDir);
  sDir := startDir + chosenDir;

  ListBox1.MultiSelect := True;
  // ListBox1.Clear;
  ListFiles(sDir, ListBox1.Items);

end;

procedure TForm1.ListFiles(Path: string; FileList: TStrings);
var
  searchResults: TSearchRec;
  fileAttributes: Integer;
begin
  fileAttributes := faDirectory;

  if FindFirst(includetrailingpathdelimiter(Path) + '*.doc*', faAnyFile,
    searchResults) = 0 then
  begin
    repeat
      if (searchResults.Attr <> fileAttributes) then // if not a directory
      begin
        // show full file name used for printing
        FileList.add(includetrailingpathdelimiter(Path) + searchResults.Name);
      end;
    until FindNext(searchResults) <> 0;
    FindClose(searchResults);
  end;

end;

end.
