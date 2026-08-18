-- Creacion de usuario y asignacion de privilegios
CREATE USER DAVID_SERRANO_USER IDENTIFIED BY DSM DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON USERS;
GRANT ALL PRIVILEGES TO DAVID_SERRANO_USER;
CONNECT DAVID_SERRANO_USER/DSM;

/*
Contexto:
Pokemon es una de las franquicias mas grandes del mundo del entretenimiento. Se centra en un mundo de fantasia en el que los humanos
conviven con extrañas criaturas llamadas Pokemon que participan en combates para probar su fuerza. 

Esta base de datos almacena informacion relevante de los pokemon utilizando el modelo objeto-relacional para almacenar su informacion 
en una sola tabla. Cada pokemon tiene un nombre, habita en una region y tiene un conjunto de valores numericos (stats) que determinan 
lo fuerte o rapido que es. Ademas, cuenta con un set de 4 movimientos distintos y puede tener afinidad con uno o varios elementos de 
la naturaleza (agua,viento,fuego...).
*/

-- Declaracion de tipos-------------------------------------

-- El tipo elemento almacena el nombre del elemento al que el pokemon es a fin 
-- y su debilidad (el elemento planta es debil contra el elemento fuego)
CREATE OR REPLACE TYPE ELEMENTO_T AS OBJECT (
    NOMBRE  VARCHAR2(35),
    DEBILIDAD VARCHAR2(35)
);
/
/*
El tipo movimiento guarda informacion relevante de los movimientos que usan
los pokemon, cada movimiento tiene un nombre y un tipo (un elemento), ademas
de un valor que indica lo preciso que es (accuracy), el numero de usos (PP)
y cualquier efecto que pueda provocar (quemadura,congelacion...)
*/
CREATE OR REPLACE TYPE MOVIMIENTO_T AS OBJECT(
    NOMBRE VARCHAR2(25),
    TIPO ELEMENTO_T,
    ACCURACY NUMBER(3),
    PP NUMBER(2),
    EFECTO VARCHAR2(65)
);
/
/*
A continuacion se crean las colecciones que usaran despues en la Pokedex
Como un pokemon tiene un numero indefinido de tipos elegi una nested table 
mientras que me decante por un varray para los movimientos que siempre son 4.
*/
CREATE OR REPLACE TYPE ELEMENTO_NT AS TABLE OF ELEMENTO_T;
/

CREATE OR REPLACE TYPE MOVIMIENTO_VA AS VARRAY(4) OF MOVIMIENTO_T;
/
/* 
El tipo Stats representa los valores de las estadisticas de un pokemon 
(fuerza,velocidad,defensa...) cuanto mayores sean mejor.
*/
CREATE OR REPLACE TYPE STATS_T AS OBJECT (
    ATTACK NUMBER(3),
    DEFENSE NUMBER(3),
    SPEED NUMBER(3),
    SPECIAL_ATTACK NUMBER(3),
    SPECIAL_DEFENSE NUMBER(3)
);
/
/*
El tipo pokemon almacena al propio pokemon, cuenta con su nombre, sus estadisticas
su region y varios metodos.
*/
CREATE OR REPLACE TYPE POKEMON_T AS OBJECT(
    NOMBRE VARCHAR2(30),
    STATS STATS_T,
    REGION VARCHAR2(50),
    
    MEMBER FUNCTION EVOLUCIONAR RETURN POKEMON_T,
    MEMBER FUNCTION ATACAR(NUM_MOVIMIENTO NUMBER) RETURN MOVIMIENTO_T,
    MEMBER PROCEDURE BOOST    
);
/
-- Declaracion de metodos-------------------------------------
CREATE OR REPLACE TYPE BODY POKEMON_T AS 
-- Cuando un pokemon madura se convierte en otro y eso ocurre mediante el metodo
-- evolucionar que devuelve el pokemon en el que seleccionado evoluciona.
    MEMBER FUNCTION EVOLUCIONAR RETURN POKEMON_T IS
        P1 POKEMON_T;
            BEGIN 
            SELECT PP.POKEMON INTO P1 FROM POKEDEX WHERE BASE=(SELECT N_POKEDEX FROM POKEDEX PP WHERE PP.POKEMON.NOMBRE=SELF.NOMBRE);
                RETURN P1;
    END;
-- Un pokemon atacar si se lo indicamos, el metodo atacar coge un numero del uno 
-- al cuatro y devuelve el ataque de ese pokemon (su movimiento).
    MEMBER FUNCTION ATACAR(NUM_MOVIMIENTO NUMBER) RETURN MOVIMIENTO_T IS
    MM MOVIMIENTO_VA;
    M1 MOVIMIENTO_T;
    BEGIN
        SELECT PP.MOVIMIENTOS INTO MM FROM POKEDEX PP WHERE PP.POKEMON.NOMBRE=SELF.NOMBRE;
    M1 := MM(NUM_MOVIMIENTO);
    RETURN M1;
    END;
-- EL pocedimiento boost es sencillo aumenta una cualidad de un pokemon a cambio
-- de disminuir otra.
    MEMBER PROCEDURE BOOST IS
        
    BEGIN
        SELF.STATS.ATTACK := SELF.STATS.ATTACK + 35;
        SELF.STATS.DEFENSE := SELF.STATS.DEFENSE - 15;
    END;
    
END;
/
/*
La tabla pokedex almacena todos los tipos declarados anteriormente para mostrar una
vision completa de los atributos del pokemon. 
Cada pokemon cuenta con un ID numerico unico de 4 cifras, los atributos del tipo pokemon
mencionados previamente, sus elementos (de uno a varios), su set de movimientos (siempre 4)
y ademas cuenta con un registro que almacena el ID de su evolucion y en caso de que sea la
evolucion almacena el id del pokemon del que parte.
*/

CREATE TABLE POKEDEX (
    N_POKEDEX NUMBER(4),
    POKEMON POKEMON_T,
    ELEMENTOS ELEMENTO_NT,
    MOVIMIENTOS MOVIMIENTO_VA,
    EVOLUCION NUMBER(4),
    BASE NUMBER(4),
    
    CONSTRAINT POKE_PK PRIMARY KEY  (N_POKEDEX),
    CONSTRAINT FK_EVO_POKE FOREIGN KEY (EVOLUCION) REFERENCES POKEDEX(N_POKEDEX),
    CONSTRAINT FK_BASE_POKE FOREIGN KEY (BASE) REFERENCES POKEDEX(N_POKEDEX)
    
    
)NESTED TABLE ELEMENTOS STORE AS ELEMENTOS_TAB;

-- Insercion de registros-------------------------------------
/*
La pokedex original cuenta con mas de 3000 registros pero en este caso usaremos los primeros
cuatro pokemons que se crearon (dos pokemons basicos y sus evoluciones).
*/
INSERT INTO POKEDEX VALUES (1,
    POKEMON_T('Bulbasaur', STATS_T(49,49,45,65,65), 'Kanto'),
ELEMENTO_NT(
    ELEMENTO_T('Planta','Fuego'),
    ELEMENTO_T('Veneno','Psíquico')
),
MOVIMIENTO_VA(
    MOVIMIENTO_T('Latigazo', ELEMENTO_T('Planta','Fuego'), 100, 25, 'Daño físico'),
    MOVIMIENTO_T('Placaje', ELEMENTO_T('Normal','Lucha'), 100, 35, 'Daño básico')
),
NULL,
NULL
);
-----------------------------
INSERT INTO POKEDEX VALUES (2,
    POKEMON_T('Ivysaur', STATS_T(62,63,60,80,80), 'Kanto'),
ELEMENTO_NT(
    ELEMENTO_T('Planta','Fuego'),
    ELEMENTO_T('Veneno','Psíquico')
),
MOVIMIENTO_VA(
    MOVIMIENTO_T('Rayo Solar', ELEMENTO_T('Planta','Fuego'), 100, 10, 'Ataque fuerte'),
    MOVIMIENTO_T('Drenadoras', ELEMENTO_T('Planta','Fuego'), 90, 15, 'Recupera vida')
),
NULL,
1
);
-------------------------------------
INSERT INTO POKEDEX VALUES (3,
    POKEMON_T('Charmander', STATS_T(52,43,65,60,50), 'Kanto'),
ELEMENTO_NT(
    ELEMENTO_T('Fuego','Agua')
),
MOVIMIENTO_VA(
    MOVIMIENTO_T('Ascuas', ELEMENTO_T('Fuego','Agua'), 95, 25, 'Quemadura'),
    MOVIMIENTO_T('Arañazo', ELEMENTO_T('Normal','Lucha'), 100, 35, 'Daño físico')
),
NULL,
NULL
);
----------------------------------------
INSERT INTO POKEDEX VALUES (4,
    POKEMON_T('Charmeleon', STATS_T(64,58,80,80,65), 'Kanto'),
ELEMENTO_NT(
    ELEMENTO_T('Fuego','Agua')
),
MOVIMIENTO_VA(
    MOVIMIENTO_T('Lanzallamas', ELEMENTO_T('Fuego','Agua'), 100, 15, 'Quemadura'),
    MOVIMIENTO_T('Garra Dragón', ELEMENTO_T('Dragón','Hada'), 95, 15, 'Daño alto')
),
NULL,
3
);
-- Alteracion de registros-------------------------------------
/*
    Al insertar registros lo que ocurre es que Charmander y Bul]basaur son pokemons base 
    que cuentan con evoluciones que no se han podido indicar al no exitir esos campos previamente
    asi que ahora se alteraran los dos registros para que guarden sus evoluciones.
*/
UPDATE POKEDEX SET EVOLUCION = 4 WHERE N_POKEDEX = 3;

--  Ademas el pokemon Bulvasaur ha aumentado en el ultimo mes su defense a 60 y se ahora habita a Mostoles.

UPDATE POKEDEX SET EVOLUCION = 2, POKEMON= POKEMON_T(
    POKEMON.NOMBRE,
    STATS_T(
        POKEMON.STATS.ATTACK,
        60,
        POKEMON.STATS.SPEED,
        POKEMON.STATS.SPECIAL_ATTACK,
        POKEMON.STATS.SPECIAL_DEFENSE
    ),
    'MOSTOLES'
) WHERE N_POKEDEX=1;

-- Consulta de registros-------------------------------------
-- Quiero un listado de las estadisticas de los pokemons con mas 30 puntos de defensa y 40 de ataque.

SELECT P.N_POKEDEX, P.POKEMON.NOMBRE,P.POKEMON.STATS.ATTACK,P.POKEMON.STATS.DEFENSE FROM POKEDEX P WHERE P.POKEMON.STATS.ATTACK > 40 AND P.POKEMON.STATS.DEFENSE > 30;

-- Quiero otro listado de los pokemons que tienen una evolucion pero ademas quiero que me muestre el nombre de su evolucion no su id.
SELECT P.N_POKEDEX,P.POKEMON.NOMBRE,E.POKEMON.NOMBRE,R.NOMBRE FROM POKEDEX P CROSS JOIN TABLE(P.ELEMENTOS) R INNER JOIN POKEDEX E ON E.N_POKEDEX=P.EVOLUCION;

-- Un ultimo listado que me muestre todos los movimientos de los pokemon de tipo fuego.
SELECT P.N_POKEDEX,P.POKEMON.NOMBRE, E.NOMBRE AS TIPO,M.NOMBRE,M.ACCURACY,M.PP,M.EFECTO FROM POKEDEX P,TABLE(P.ELEMENTOS) E,TABLE(P.MOVIMIENTOS) M WHERE E.NOMBRE = 'Fuego';

-- Consulta de Tipos-------------------------------------
-- Los tipos del usuario se almacenan todos en la misma tabla user_types-
-- Catalogo de colecciones
SELECT * FROM USER_TYPES WHERE TYPECODE='COLLECTION';
-- Catalogo de objetos
SELECT * FROM USER_TYPES WHERE TYPECODE='OBJECT';

-- Orden correcto de borrado-------------------------------------
-- ES RECOMENDABLE PRIMERO VACIAR DE REGISTROS LA TABLA A BORRAR
TRUNCATE TABLE POKEDEX;
-- PRIMERO SE ELIMINA LA TABLA QUE CONTIENE TODOS LOS TIPOS
DROP TABLE POKEDEX;
-- LUEGO LAS COLECCIONES QUE CONTIENEN TIPOS
DROP TYPE ELEMENTO_NT;
DROP TYPE MOVIMIENTO_VA;
-- DESPUES LOS TIPOS QUE CONTIENEN EN SU INTERIOR OTROS TIPOS
DROP TYPE POKEMON_T;
DROP TYPE MOVIMIENTO_T;
-- POR ULTIMO SE ELIMINAN LOS TIPOS ATOMICOS QUE NO CONTIENEN NINGUN OTRO TIPO EN SU INTERIOR
DROP TYPE ELEMENTO_T;
DROP TYPE STATS_T;
---------------------------------------------------------------------
DISCONNECT;