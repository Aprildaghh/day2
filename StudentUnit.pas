unit StudentUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Math, SkeletonUnit, LectureUnit;

type
  TStudent = class (TSkeleton)
      private
        tLectureNames : TList<string>;
        tNotes        : TList<double>;
      public
        function getTextLine: string;
        procedure addLectureAndNote(tLecture: TLecture; tNote: double);
        procedure addLecture(tLectureName: string);
        procedure addNote(tNote: double);
        procedure AddLectureName(const Value: string);
        function GetLectureNames: TList<string>;
        function GetNotes: TList<double>;
        property TextLine: string read getTextLine;
        constructor Create(tName: string);
    end;

implementation

{ TStudent }

procedure TStudent.addLecture(tLectureName: string);
begin
  self.tLectureNames.Add(tLectureName);
end;

procedure TStudent.addLectureAndNote(tLecture: TLecture; tNote: double);
begin
    SetHowMuchTaken(self.GetHowMuchTaken+1);
    tLecture.SetHowMuchTaken(tLecture.GetHowMuchTaken+1);
    tLectureNames.Add(tLecture.GetName);
    tNotes.Add(tNote);
end;

procedure TStudent.AddLectureName(const Value: string);
begin
  self.tLectureNames.Add(Value);
end;

procedure TStudent.addNote(tNote: double);
begin
  self.tNotes.Add(tNote);
end;

constructor TStudent.Create(tName: string);
begin
  inherited Create(tName);
  tLectureNames := TList<string>.Create;
  tNotes := TList<double>.Create;
end;

function TStudent.GetLectureNames: TList<string>;
begin
  Result := self.tLectureNames;
end;

function TStudent.GetNotes: TList<double>;
begin
  Result := self.tNotes;
end;

function TStudent.getTextLine: string;
begin
  Result := GetName+'/'+floattostr(GetAvg)+'/'+inttostr(GetHowMuchTaken)+'/';
end;

end.
