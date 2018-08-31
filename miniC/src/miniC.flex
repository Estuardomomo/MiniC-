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
    //Metodo que devuelve los datos necesarios que escribiremos en un archivo de salida
    public String toString() {
        return "Token #"+numToken+": "+token+" C.Lexico: "+tipo+" ["+linea
        + "," +columna + "]";
    }
}
%%
%{
public File archivoSalida;
private RandomAccessFile raf;
public void Abrir() throws FileNotFoundException{
    raf = new RandomAccessFile(archivoSalida,"rw");
}

public void Cerrar() throws IOException{
    raf.close();
}

%}
%function nextToken
%line
%column
%ignorecase
//Abecedario
a = [a]
b = [b]
c = [c]
d = [d]
e = [e]
f = [f]
g = [g]
h = [h]
i = [i]
j = [j]
k = [k]
l = [l]
m = [m]
n = [n]
o = [o]
p = [p]
q = [q]
r = [r]
s = [s]
t = [t]
u = [u]
v = [v]
w = [w]
x = [x]
y = [y]
z = [z]
A = [A]
B = [B]
C = [C]
D = [D]
E = [E]
F = [F]
G = [G]
H = [H]
I = [I]
J = [J]
K = [K]
L = [L]
M = [M]
N = [N]
O = [O]
P = [P]
Q = [Q]
R = [R]
S = [S]
T = [T]
U = [U]
V = [V]
W = [W]
X = [X]
Y = [Y]
Z = [Z]
//Palabras reservadas & constantes en tiempo de compilación
void = ("void")
int = ("int")
rwdouble = ("double")
bool = ("bool")
rwstring = ("string")
class = ("class")
interface = ("interface")
null = ("null")
this = ("this")
extends = ("extends")
implements = ("implements")
for = ("for")
while = ("while")
if = ("if")
else = ("else")
return = ("return")
break = ("break")
New = ("New")
NewArray = ("NewArray")
//Identificador
Identificador = [a-zA-Z_][a-zA-Z0-9_\x7f-\xff]{0,30}
//Espacios en blanco
EXP_ESPACIO = \n|\r\n|" "|\r|\t|\s
//Comentarios
ComentarioSimple = ("//")(.)*
ComentarioMultiple = "/*"~"*/"
//constantes
boolean = "true"|"false"
decimal = [1-9][0-9]* | 0
hexadecimal = 0x[0-9a-fA-F]+|0X[0-9a-fA-F]+
integer = [+-]?decimal| [+-]?hexadecimal
LNUM = [0-9]+
DNUM = ({LNUM}[\.][0-9]*)
EXPONENT_DNUM = [+-]?({DNUM} [eE][+-]? {LNUM})
double = {DNUM}|{EXPONENT_DNUM}
string = ('([^'\\]|\\.)*')|(\"([^\"\\]|\\.)*\")|"/*"~"*/"
//Operadores y caracteres de puntuación
operadoreslogicos = "&&"|"||"|"!"
operadoresAritmeticos = "+"|"-"|"/"|"*"|"%"
operadoresComparativo = "=="|"!="|"<"|">"|"<="|">="
operadoresAsignacion = "=" 
Punto = "."
Coma = ","
PuntoyComa =";"
Parentesis = "("|")"
Llaves = "{"|"}"
Corchetes = "["|"]"
Cerrados = "[]"|"{}"|"()"
//Agrupaciones - Entidades que devolverán un texto
Operador = {operadoreslogicos}|{operadoresAritmeticos}|{operadoresComparativo}|{operadoresAsignacion}
Comentario = {ComentarioSimple}|{ComentarioMultiple}
Constante = {integer}|{double}|{boolean}
PalabrasReservadas = {void}|{int}|{rwdouble}|{bool}|{rwstring}|{class}|{interface}|{null}|{this}|{extends}|{implements}|{for}|{while}|{if}|{else}|{return}|{break}|{New}|{NewArray}
Caracter = {Punto}|{Coma}|{PuntoyComa}|{Parentesis}|{Llaves}|{Corchetes}|{Cerrados}
%%
{string} {
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+" Tipo String \r\n");
        } catch(IOException ex){}}
{PalabrasReservadas} {
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+" Palabra reservada \r\n");
    } catch(IOException ex){}}
{Operador} {
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+" Operador \r\n");
        } catch(IOException ex){}}
{Comentario} {
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+" Comentario \r\n");
        } catch(IOException ex){}}
{Caracter} { 
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+" Caracter \r\n");
        } catch(IOException ex){}}
{Constante} {
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+"Constante \r\n");
        } catch(IOException ex){}}
{Identificador} { 
    try{
        raf.writeBytes("Simbolo: " + yytext() + " Fila: " + Integer.toString(yyline) + " Columna: "+ Integer.toString(yycolumn)+"Identificador \r\n");
        } catch(IOException ex){} }
{EXP_ESPACIO} {
    try{ } catch(IOException ex){}}

    //ERRORES
. {
    bandera = false;
    try{raf.writeBytes("*** Error linea " + Integer.toString(yyline) + ". *** Caracter no reconocido: " + yytext() + " \n");} catch(IOException ex){}
}

