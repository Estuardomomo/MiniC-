import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
class Yytoken {
    Yytoken (int numToken,String token, String tipo, int linea, int columna){
        //Contador para el número de tokens reconocidos
        this.numToken = numToken;
        //String del token reconocido
        this.token = new String(token);
        //Tipo de componente léxico encontrado
        this.tipo = tipo;
        //Número de linea
        this.linea = linea;
        //Columna donde empieza el primer carácter del token
        this.columna = columna;
    }
    //Métodos de los atributos de la clase
    public int numToken;
    public String token;
    public String tipo;
    public int linea;
    public int columna;
    //Metodo que devuelve los datos necesarios que escribiremos en un archive de salida
    public String toString() {
        return "Token #"+numToken+": "+token+" C.Lexico: "+tipo+" ["+linea
        + "," +columna + "]";
    }
}
%%
%{
public Boolean bandera = true;
public File archivoSalida;
public File archivoError;
private RandomAccessFile raf;
private RandomAccessFile rafi; 
public void Abrir() throws FileNotFoundException{
    raf = new RandomAccessFile(archivoSalida,"rw");
}
public void AbrirError() throws FileNotFoundException{
    rafi = new RandomAccessFile(archivoError,"rw");
}
public void Cerrar() throws IOException{
    raf.close();
}
public void CerrarError() throws IOException{
    rafi.close();
}
%}
%function nextToken
%line
%column
%ignorecase
//Abecedario
a = [aA]
b = [bB]
c = [cC]
d = [dD]
e = [eE]
f = [fF]
g = [gG]
h = [hH]
i = [iI]
j = [jJ]
k = [kK]
l = [lL]
m = [mM]
n = [nN]
o = [oO]
p = [pP]
q = [qQ]
r = [rR]
s = [sS]
t = [tT]
u = [uU]
v = [vV]
w = [wW]
x = [xX]
y = [yY]
z = [zZ]
//Palabras reservadas & constantes en tiempo de compilación
__halt_compiler= ("__halt_compiler")
break = ("break")
clone = ("clone")
die = ("die")
empty = ("empty")
endswitch = ("endswitch")
final = ("final")
global = ("global")
include_once = ("include_once")
list = ("list")
private = ("private")
return = ("return")
try = ("try")
xor = ("xor")
__CLASS__ = ("__CLASS__")
__NAMESPACE__ = ("__NAMESPACE__")
abstract = ("abstract")
callable = ("callable")
const = ("const")
do = ("do")
enddeclare = ("enddeclare")
endwhile = ("endwhile")
finally = ("finally")
goto = ("goto")
instanceof = ("instanceof")
namespace = ("namespace")
protected = ("protected")
static = ("static")
unset = ("unset")
yield = ("yield")
__DIR__ = ("__DIR__")
__TRAIT__ = ("__TRAIT__")
and = ("and")
case = ("case")
continue = ("continue")
echo = ("echo")
endfor = ("endfor")
eval = ("eval")
for = ("for")
if = ("if")
insteadof = ("insteadof")
new = ("new")
public = ("public")
switch = ("switch")
use = ("use")
array = ("array")
catch = ("catch")
declare = ("declare")
else = ("else")
endforeach = ("endforeach")
exit = ("exit")
foreach = ("foreach")
implements = ("implements")
interface = ("interface")
or = ("or")
require = ("require")
throw = ("throw")
var = ("var")
while = ("while")
trait = ("trait")
require_once = ("require_once")
print = ("print")
isset = ("isset")
include = ("include")
function = ("function")
extends = ("extends")
endif = ("endif")
elseif = ("elseif")
default = ("default")
class = ("class")
as = ("as")
__FILE__ = ("__FILE__")
__FUNCTION__ = ("__FUNCTION__")
__LINE__ = ("__LINE__")
__METHOD__ = ("__METHOD__")
etiqueta = ("<?php" | "?>")
//Tipos
decimal = [1-9][0-9]* | 0
hexadecimal = 0[xX][0-9a-fA-F]+
octal = 0[0-7]+
binary = 0[bB][01]+
integer = [+-]?decimal| [+-]?hexadecimal| [+-]?octal| [+-]?binary
LNUM = [0-9]+
DNUM = ([0-9]*[\.]{LNUM}) | ({LNUM}[\.][0-9]*)
EXPONENT_DNUM = [+-]?(({LNUM} | {DNUM}) [eE][+-]? {LNUM})
double = {LNUM}|{DNUM}|{EXPONENT_DNUM}
boolean = {t}{r}{u}{e}|{f}{a}{l}{s}{e}
string = ('([^'\\]|\\.)*')|(\"([^\"\\]|\\.)*\")|"/*"~"*/"
//Operadores
And = {a}{n}{d}|"&&"
Or = {o}{r}|"||"
Xor = {x}{o}{r}
Not = "!"
operadoreslogicos = {And}|{Or}|{Xor}|{Not}
operadoresAritmeticos = "+"|"-"|"/"|"*"|"**"
operadoresComparativo = "=="|"==="|"!="|"<>"|"!=="|"<"|">"|"<="|">="|"<=>"|"??"
operadoresAsignacion = "="|"+="|"-="|"*="|"/="|"++"|"--" 
//Caracteres
Punto = "."
DosPuntos = ":"
Coma = ","
PuntoyComa =";"
Parentesis = "("|")"
Llaves = "{"|"}"
Corchetes = "["|"]"
Barra = "|"
Pregunta = "?"
//Comentarios
ComentarioSimple = ("//"|"#")(.)*
ComentarioMultiple = "/*"~"*/"
//Variables predeterminadas
Predeterminado = "$"(GLOBALS|_(SERVER|GET|POST|FILES|COOKIE|SESSION|REQUEST|ENV))
MasPredeterminado = "$"(php_errormsg|HTTP_RAW_POST_DATA|http_response_header|argc|argv|args)
//Entidades que devolverán un texto
variablesPredeterminadas = {Predeterminado}|{MasPredeterminado}
Operador = {operadoreslogicos}|{operadoresAritmeticos}|{operadoresComparativo}|{operadoresAsignacion}
Comentario = {ComentarioSimple}|{ComentarioMultiple}
TipoDato = {integer}|{double}|{boolean}
ConstanteCompilacion = {__CLASS__}|{__DIR__}|{__FILE__}|{__FUNCTION__}|{__LINE__}|{__METHOD__}|{__NAMESPACE__}|{__TRAIT__}
PalabrasReservadas = {abstract}|{and}|{array}|{as}|{break}|{callable}|{case}|{catch}|{class}|{clone}|{const}|{continue}|{declare}|{default}|{die}|{do}|{echo}|{else}|{elseif}|{empty}|{enddeclare}|{endfor}|{endforeach}|{endif}|{endswitch}|{endwhile}|{eval}|{exit}|{extends}|{final}|{finally}|{for}|{foreach}|{function}|{global}|{goto}|{__halt_compiler}|{if}|{implements}|{include}|{include_once}|{instanceof}|{insteadof}|{interface}|{isset}|{list}|{namespace}|{new}|{or}|{print}|{private}|{protected}|{public}|{require}|{require_once}|{return}|{static}|{switch}|{throw}|{trait}|{try}|{unset}|{use}|{var}|{while}|{xor}|{yield}
Caracter = {Punto}|{Coma}|{PuntoyComa}|{Parentesis}|{Llaves}|{Corchetes}|{Barra}|{DosPuntos}|{Pregunta}
//Acceso a base de datos
AccesoBD = "$"recordset"["{string}"]"
//Estructuras de control
Control = ({if}|{else}|{elseif}|{endif}|{while}|{do}|{for}|{foreach}|{break}|{switch}|{case}|{continue}|{return}|{include})
//Variables
Variables = "$"{Identificador}
//Constantes
Constante = {Identificador}
//Identificador
Identificador = [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*
//salto de linea
EXP_ESPACIO = \n|\r\n|" "|\r|\t|\s
//Error especial
ErrorEspecial =  "$"{LNUM}{Variables}|"$"{LNUM}{Constante}|"=!="|"1a"|(("/*")~(\n))
%%
{string} {try{raf.writeBytes(yytext());} catch(IOException ex){}}
{PalabrasReservadas} {try{raf.writeBytes(yytext().toLowerCase());} catch(IOException ex){}}
{ConstanteCompilacion} { try{raf.writeBytes(yytext().toUpperCase());} catch(IOException ex){} }
{etiqueta} { try{raf.writeBytes(yytext().toLowerCase());} catch(IOException ex){}}
{variablesPredeterminadas} {try{raf.writeBytes(yytext());} catch(IOException ex){} }
{Operador} {try{raf.writeBytes(yytext().toLowerCase());} catch(IOException ex){}}
{Comentario} {try{raf.writeBytes(yytext());} catch(IOException ex){}}
{TipoDato} {try{raf.writeBytes(yytext().toLowerCase());} catch(IOException ex){} }
{Control} { try{raf.writeBytes(yytext().toLowerCase());} catch(IOException ex){} }
{Caracter} { try{raf.writeBytes(yytext());} catch(IOException ex){}}
{AccesoBD} {
    try{
        
        raf.writeBytes(yytext());
        } catch(IOException ex){} }
{Variables} {try{raf.writeBytes(yytext());} catch(IOException ex){}}
{Constante} { try{raf.writeBytes(yytext());} catch(IOException ex){}}
{Identificador} { try{raf.writeBytes(yytext());} catch(IOException ex){} }
{EXP_ESPACIO} {try{raf.writeBytes(yytext());} catch(IOException ex){}}
{ErrorEspecial} {
    bandera = false;
    try{rafi.writeBytes("se encontro un error en la linea: "+ Integer.toString(yyline) + " Expresion: " + yytext() + " \n");}catch(IOException ex){}
}
    //ERRORES
. {
    bandera = false;
    try{rafi.writeBytes("Se encontro un error en la linea: "+ Integer.toString(yyline) + " Expresion: " + yytext() + " \n");} catch(IOException ex){}
}

