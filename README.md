<h1> SerialLinuz.pl </h1>
Descripcion: Programa que ejecuta en el momento del login solicitando el serial para evitar los 30 días de prueba y posteriormente se borra el laboratorio de seguridad.
Autor: Victor J. Mejia Lara
Licencia: GPL (www.gnu.org/licenses/gpl-3.0.txt)

# Requerimientos.
1. Perl v5
2. ANSIColor


# Implementaci�n
Copiar SerialLinux.pl en el directorio /sbin y agregarlo en el script de arranque del sistema, as� como tambi�n de habilitar el atributo de inmutable para que el usuario no lo pueda eliminar del sistema.
