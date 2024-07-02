unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type

  TLecture = class
    lectureName: string;
    noteAvg: double;
    studentTaken: integer;
  end;

  TStudent = class
    studentName: string;
    gpa: double;
    lectureTaken: integer;
    notes: TList<string>;
  end;

  TmainForm = class(TForm)
    studentListBox: TListBox;
    addStudentBtn: TButton;
    removeStudentBtn: TButton;
    lectureListBox: TListBox;
    addLectureBtn: TButton;
    removeLectureBtn: TButton;
    assignNoteBtn: TButton;
    procedure addStudentBtnClick(Sender: TObject);
    procedure removeStudentBtnClick(Sender: TObject);
    procedure addLectureBtnClick(Sender: TObject);
    procedure removeLectureBtnClick(Sender: TObject);
    procedure assignNoteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    lectures: array[0..512] of TLecture;
    students: array[0..512] of TStudent;
    lectureArrIndex, studentArrIndex: integer;
  public
    { Public declarations }
  end;



var
  mainForm: TmainForm;

implementation

{$R *.dfm}

function fillListBoxes:boolean;
var
  i: Integer;
begin
  for i := 0 to mainForm.studentArrIndex-1 do
  begin
    mainForm.studentListBox.Items.Add(mainForm.students[i].studentName + ', '+floattostr(mainForm.students[i].gpa));
  end;
  for i := 0 to mainForm.lectureArrIndex-1 do
  begin
    mainForm.lectureListBox.Items.Add(mainForm.lectures[i].lectureName + ', '+floattostr(mainForm.lectures[i].noteAvg));
  end;
end;

function sliceUntilComma(value: string): string;
var
  i: Integer;
  finalProduct: string;
begin
  for i := 1 to value.LastIndexOf(',') do
  begin
    finalProduct := finalProduct + value[i];
  end;
  Result := finalProduct;
end;

function getSelected(listBox: TListBox): string;
var
  i: Integer;
begin
  for i := 0 to listBox.Count-1 do
  begin
    if listBox.Selected[i] = True then
    begin
      Result := listBox.Items[i];
      break;
    end;
  end;
end;

function getCurrentListItemIndex(listBox: TListBox): integer;
var
  i: Integer;
begin
  for i := 0 to listBox.Count - 1 do
  begin
    if listBox.Selected[i] then
    begin
      Result := i;
    end;
  end;
end;

function getStudentIndex(name: string): integer;
var
  i: Integer;
begin
  for i := 0 to mainForm.studentArrIndex - 1 do
  begin
    if mainForm.students[i].studentName = name then
    begin
      Result := i;
      break;
    end;

  end;
end;

function getLectureIndex(name: string): integer;
var
  i: integer;
begin
  for i := 0 to mainForm.lectureArrIndex - 1 do
  begin
    if mainForm.lectures[i].lectureName = name then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TmainForm.addLectureBtnClick(Sender: TObject);
var
  lectureName: string;
  lecture: TLecture;
  begin
  lectureName := inputbox('Add Lecture', '', '');
  if lectureName = '' then
    showmessage('Invalid lecture!')
  else
  begin
    lecture := TLecture.Create;
    lectureListBox.AddItem(lectureName + ', 0.0', nil);
    lecture.lectureName := lectureName;
    lecture.noteAvg := 0.0;
    lecture.studentTaken := 0;
    lectures[lectureArrIndex] := lecture;
    inc(lectureArrIndex);
  end;

end;

procedure TmainForm.addStudentBtnClick(Sender: TObject);
var
  studentName: string;
  student: TStudent;
begin
  studentName := inputbox('Add Student', '', '');
  if studentName = '' then
    showmessage('Invalid student name!')
  else
  begin
    student := TStudent.Create;
    studentListBox.AddItem(studentName + ', 0.0', nil);
    student.studentName := studentName;
    student.gpa := 0.0;
    student.lectureTaken := 0;
    student.notes := TList<string>.Create;
    students[studentArrIndex] := student;
    inc(studentArrIndex);
  end;
end;

procedure TmainForm.assignNoteBtnClick(Sender: TObject);
var
  theNote: double;
  theStudent: TStudent;
  theLecture: TLecture;
  begin

  // Get note from user
  theNote := StrToFloat(inputBox('Assign Note', '', ''));

  // add note to TStudent.notes
  theStudent := students[getStudentIndex(sliceUntilComma(getSelected(studentListBox)))];
  theLecture := lectures[getLectureIndex(sliceUntilComma(getSelected(lectureListBox)))];

  // update studentGpa
  // ((gpa*lecturetaken) + theNote ) / (lecturetaken+1)
  theStudent.gpa := ((theStudent.gpa * theStudent.lectureTaken) + theNote) / (theStudent.lectureTaken+1);

  // update lecture noteAvg
  theLecture.noteAvg := ((theLecture.noteAvg * theLecture.studentTaken) + theNote) / (theLecture.studentTaken+1);

  if theStudent.notes.IndexOf(theLecture.lectureName) = -1 then
  begin
    inc(theStudent.lectureTaken);
    inc(theLecture.studentTaken);
  end;

  theStudent.notes.Add(theLecture.lectureName);

  // update listBoxes
  studentListBox.Items.Strings[getCurrentListItemIndex(studentListBox)] := theStudent.studentName + ', ' + floattostr(theStudent.gpa);
  lectureListBox.Items.Strings[getCurrentListItemIndex(lectureListBox)] := thelecture.lectureName + ', ' + floattostr(thelecture.noteAvg);
end;

procedure TmainForm.FormCreate(Sender: TObject);
var
  myFile: textFile;
  line, newData: string;
  i, flag: Integer;
  onStudent: boolean;
  newLecture: TLecture;
  newStudent: TStudent;
begin
  studentArrIndex := 0;
  lectureArrIndex := 0;

  newData := '';
  onStudent := False;

  assignFile(myFile, 'marti.txt');

  Reset(myFile);

  while not Eof(myFile) do
  begin
    Readln(myFile, line);

    if line = '--' then
    begin
      onStudent := True;
      newData := '';
      continue;
    end;

    if not onStudent then
    begin
      // LECTURE
      newData := '';
      flag := 0;
      newLecture := TLecture.Create;
      for i := 1 to line.Length do
      begin
        if line[i] = '/' then
        begin
          if flag = 0 then
            newLecture.lectureName := newData;
          if flag = 1 then
            newLecture.noteAvg := strtofloat(newData);
          if flag = 2 then
            newLecture.studentTaken := strtoint(newData);
          inc(flag);
          newData := '';
          continue;
        end;
        newData := newData + line[i];
      end;
      lectures[lectureArrIndex] := newLecture;
      inc(lectureArrIndex);
    end;
    if onStudent then
    begin
      // STUDENT
      flag := 0;
      newData := '';
      newStudent := TStudent.Create;
      newStudent.notes := TList<string>.Create;
      for i := 1 to line.Length do
      begin
        if line[i] = '/' then
        begin
          if flag = 0 then
            newStudent.studentName := newData;
          if flag = 1 then
            newStudent.gpa := strtofloat(newData);
          if flag = 2 then
            newStudent.lectureTaken := strtoint(newData);
          if flag = 3 then
            newStudent.notes.Add(newData);
          if flag <> 3 then
            inc(flag);

          newData := '';
          continue;
        end;
        newData := newData + line[i];
      end;

      students[studentArrIndex] := newStudent;
      inc(studentArrIndex);
    end;

  end;

  closeFile(myFile);
  fillListBoxes;
end;

procedure TmainForm.FormDestroy(Sender: TObject);
var
  myFile: textFile;
  line: string;
  i: Integer;
  j: Integer;
begin
  
  assignFile(myFile, 'marti.txt');
  ReWrite(myFile);

  // LECTURE
  for i := 0 to lectureArrIndex-1 do
  begin
    if lectures[i].lectureName = '' then
      continue;

    line := lectures[i].lectureName + '/' + floattostr(lectures[i].noteAvg) + '/' + inttostr(lectures[i].studentTaken);
    writeln(myFile, line);
  end;

  // write --
  writeln(myFile, '--');

  // STUDENT
  for i := 0 to studentArrIndex-1 do
  begin
    if students[i].studentName = '' then
      continue;

    line := students[i].studentName+'/'+floattostr(students[i].gpa)+'/'+inttostr(students[i].lectureTaken)+'/';

    for j := 0 to students[i].notes.Count-1 do
    begin
      line := line + students[i].notes.Items[j] + '/';
    end;

    writeln(myFile, line);

  end;
    

  closeFile(myFile);

end;

procedure TmainForm.removeLectureBtnClick(Sender: TObject);
begin
  lectures[getLectureIndex(sliceUntilComma(getSelected(lectureListBox)))].lectureName := '';
  lectureListBox.DeleteSelected;
end;

procedure TmainForm.removeStudentBtnClick(Sender: TObject);
begin
  students[getStudentIndex(sliceUntilComma(getSelected(studentListBox)))].studentName := '';
  studentListBox.DeleteSelected;
end;

end.

{
  remove student and lecture doesnt remove the thingy from gpa and avg
}
