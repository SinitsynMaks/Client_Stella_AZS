program Client_Stella;

uses
  Forms,
  U_Main in 'U_Main.pas' {F_Main},
  U_OProgr in 'U_OProgr.pas' {F_OProgramme},
  U_Pass1 in 'U_Pass1.pas' {F_pass1},
  U_ServNastr in 'U_ServNastr.pas' {F_ServNastr},
  Formirovatel_Paketov in 'Formirovatel_Paketov.pas',
  U_ParolPyltaDU in 'U_ParolPyltaDU.pas' {F_ParolDU},
  U_UstrSCenoy in 'U_UstrSCenoy.pas' {F_Nastr_Ceny},
  U_NastrChasov in 'U_NastrChasov.pas' {F_NastrChasov},
  U_Nastr_Porta in 'U_Nastr_Porta.pas' {F_Nastr_Porta},
  U_StopModal in 'U_StopModal.pas' {FWait};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_Main, F_Main);
  Application.Run;
end.
