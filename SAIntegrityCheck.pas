program SA_Integrity_Check;
uses md5, crt, sysutils;
const VERSION = '1.2';
const AUTOR = 'Markski';

type
	bf = record
		hash : string;
		ruta : string;
		priod: string[2];
	end;

function mensaje (msj: string; leng: integer): String;
begin
	case msj of
		'advertencia': if ( leng = 1 ) then mensaje := 'No GTA:SA Installation found in this folder. Please run this program inside your GTA:SA directory. Execution has been cancelled.' else mensaje := 'No se ha encontrado una instalacion de GTA.SA en esta carpeta. Por favor ejecuta este archivo dentro de la carpeta de tu GTA. Ejecucion cancelada.';
		'advertencia2': if ( leng = 1 ) then mensaje := 'The database.sicdb file has not been found. You need to put that file in the same directory as this program. Execution cannot continue without this file.' else mensaje := 'El archivo database.sicdb no se encuentra en esta carpeta. Por favor pega ese archivo en la carpeta con este programa y vuelve a ejecutarlo. La ejecucion no puede continuar.';
		'visual': if ( leng = 1 ) then mensaje := 'Enter 1 to check essential files that could mean cheats or other unexpected effects. Press 2 to make a more complete procedure that checks files that modify visual aspect.' else mensaje := 'Ingrese 1 para hacer un chequeo de los archivos esenciales, que podrian significar cheats u otros cambios en el juego. Ingrese 2 para hacer un chequeo mas completo que incluye archivos visuales.';
		'chequeando': if ( leng = 1 ) then mensaje := 'Executing integrity check. This can take quite a while depending on your specs.' else mensaje := 'Ejecutando chequeo de integridad. Esto puede tardar varios minutos dependiendo de tus especificaciones.';
		'inconsistencia': if ( leng = 1 ) then mensaje := 'INCONSISTENCY FOUND IN: ' else mensaje := 'INCONSISTENCIA ENCONTRADA EN: ';
		'finalizado': if ( leng = 1 ) then mensaje := 'Check finished.' else mensaje := 'Chequeo finalizado.';
		'mal': if ( leng = 1 ) then mensaje := ' inconcistency found. A report is available in the file IntegirtyReport.txt' else mensaje := ' inconsistencia(s) encontrada(s). Un reporte esta disponible en IntegrityReport.txt';
		'nada': if ( leng = 1 ) then mensaje := 'No modified files were found, your GTA:SA install is in perfect stock state.' else mensaje := 'No se han encontrado archivos modificados. Tu instalacion de GTA:SA esta en perfecto estado.';
		'mensajeArchivo': if ( leng = 1 ) then mensaje := 'The inconsistencies shown above could mean modified gameplay experience and some of the changes could potentially be considered cheats. Please check FileReferences.txt for information.' else mensaje := 'Las inconsistencias listadas arribas pueden significar una experiencia de juego modificado al punto de hasta llegar a ser considerado cheats en muchos servidores. Se recomienda encarecidamente que leas FileReferences.txt';
		'salir': if ( leng = 1 ) then mensaje := 'You may now close the program. Ver. '+VERSION+' by '+AUTOR else mensaje := 'Usted puede ahora cerrar el programa. Ver. '+VERSION+' por '+AUTOR;
		else 
			mensaje := 'Error de lenguajes.'
	end;
end;

procedure chequearArchivo (lenguaje: integer; var err: integer; buffer: bf; var a: text; var db: text);
var
	hasheo: String;
	auxiliar: String;
begin
	hasheo := MD5Print(MD5File(buffer.ruta));
	if hasheo <> buffer.hash then begin
		err := err + 1;
		writeln(mensaje('inconsistencia', lenguaje), buffer.ruta);
		auxiliar := 'Archivo/File: ' + buffer.ruta + ' | MD5 original: ' + buffer.hash + ' ; MD5 encontrado/found: ' + hasheo;
		writeln(a, auxiliar);
	end;
end;


var
	i: Integer;
	lenguaje: Integer;
	err: Integer;
	arch: text;
	db: text;
	buffer: bf;
begin
	err := 0;
	writeln('Choose language / Elija su lenguaje');
	writeln('1 - English - Ingles');
	writeln('2 - Spanish - Castellano');
	readln(lenguaje);
	clrscr;
	if not FileExists('database.sicdb') then writeln (mensaje('advertencia2', lenguaje))
	else if not FileExists('gta_sa.exe') then writeln (mensaje('advertencia', lenguaje))
	else begin
		Assign(db, 'database.sicdb');
		Reset(db);
		Assign(arch, 'IntegrityReport.txt');
		Rewrite(arch);
		writeln (mensaje('visual', lenguaje));
		readln(i);
		clrscr;
		writeln (mensaje('chequeando', lenguaje));
		while not EOF(db) do begin
			readln(db, buffer.hash);
			readln(db, buffer.ruta);
			readln(db, buffer.priod);
			if (buffer.priod = '0') then begin
			chequearArchivo(lenguaje, err, buffer, arch, db);
			end else if (buffer.priod = '1') AND (i = 2) then chequearArchivo(lenguaje, err, buffer, arch, db);
		end;
		writeln (mensaje('finalizado', lenguaje));
		if err > 0 then begin
			writeln(err, mensaje('mal', lenguaje));
			writeln(arch, mensaje('mensajeArchivo', lenguaje))
		end else begin
			writeln(mensaje('nada', lenguaje));
			write(arch, 'No se encontraron inconsistencias. / No inconsistencies found.');
		end;
		Close(arch);
		Close(db);
	end;
	writeln (mensaje('salir', lenguaje));
	delay (65535);
end.
