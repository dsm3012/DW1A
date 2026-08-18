--BLOQUES ANÓNIMOS
--pl/sql
/*
SINTAXIS GENERAL:
DECLARE
--declaración de variables
BEGIN
--Código ejecutable
EXCEPTION
--manejo de errores
END;
/

*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;

--1. IMPRIMIR TEXTO
DECLARE 
    mensaje VARCHAR2(20):='Hola mundo!!';
BEGIN
    DBMS_OUTPUT.PUT_LINE(mensaje);
END;
/

--2. hacer operaciones con números
DECLARE
    n1 NUMBER (2):= 10;
    n2 NUMBER (2):= 24;
    resultado NUMBER (4); --EJECUTARLO EN BLOQUE BEGIN
BEGIN
    resultado := n1*n2;
    DBMS_OUTPUT.PUT_LINE('El producto de ' || n1 || ' * '||n2||' = '||resultado );
END;
/

--.3 VARIABLES DE SUSTITUCIÓN &
DECLARE
    n1 NUMBER (2):= '&n1';
    n2 NUMBER (2):= '&n2';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Números introducidos '|| n1 ||' y '|| n2);
END;
/

--.3 VARIABLES DE SUSTITUCIÓN & --MODIFICAR PARA QUE OFREZCA EL RESULTADO DE SUMAR, MULTIPLICAR, DIVIDIR, RESTAR
DECLARE
    n1 NUMBER (2):= '&n1';
    n2 NUMBER (2):= '&n2';
    su NUMBER (4):= n1+n2;
    re NUMBER (4):= n1-n2;
    pr NUMBER (4):= n1*n2;
    di NUMBER (5,2):= n1/n2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Números introducidos '|| n1 ||' y '|| n2);
    DBMS_OUTPUT.PUT_LINE('Suma: '|| su);
    DBMS_OUTPUT.PUT_LINE('Resta: '|| re);
    DBMS_OUTPUT.PUT_LINE('Producto: '|| pr);
    DBMS_OUTPUT.PUT_LINE('División: '|| di);
END;
/

--.4 EXCEPCIONES
--bloque anónimo para dividir números introducidos por teclado
--con la excepción ZERO_DIVIDE capturamos la excepción que aparecerá, en este caso,
--impresión de mensaje por pantalla indicando que estoy intentando dividir entre cero
DECLARE
    n1 NUMBER (2):= '&n1';
    n2 NUMBER (2):= '&n2';
    di NUMBER (5,2);
BEGIN
    di:= n1/n2;
    DBMS_OUTPUT.PUT_LINE('Números introducidos '|| n1 ||' y '|| n2);
    DBMS_OUTPUT.PUT_LINE('División: '|| di);
EXCEPTION
    WHEN  ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('Has usado divisor igual a cero');
    
END;

/

--CONDICIONALES
--SOLICITAR DOS NÚMEROS
--RESTASR EL MENOR AL MAYOR
--Fernando
DECLARE
    n1 NUMBER (2):= '&n1';
    n2 NUMBER (2):= '&n2';
    res NUMBER (3);
BEGIN
    res:= n1-n2;
    IF 
        res < 0
    THEN
        res:= n2 - n1;    
    ELSIF
        res >= 0
    THEN
        res:= n1-n2;
    END IF;
    DBMS_OUTPUT.PUT_LINE(res);    
END;
/

--SIMPLIFICAR
DECLARE
    n1 NUMBER (2):= '&n1';
    n2 NUMBER (2):= '&n2';
    res NUMBER (3);
BEGIN
    IF 
        n1 < n2
    THEN
        res:= n2 - n1;    
    ELSE
        res:= n1 - n2;
    END IF;
    DBMS_OUTPUT.PUT_LINE(res);    
END;
/

--6. bloque anónimo para sacar datos de EMP cuyo salario sea mayor al introducido por teclado

--%TYPE %ROW declaración de variables

--%TYPE se usa para declarar variables del mismo tipo que una columna en una tabla
--SUPONIENDO QUE UN SELECT NOS OFRECE VARIAS FILAS
--NECESITAMOS UN CURSOR PARA IMPRIMIR EL RESULTADO DE CADA FILA

DECLARE
     salIn EMP.SAL%TYPE:='&SALARIO';
BEGIN
        DBMS_OUTPUT.PUT_LINE(RPAD('ID_EMPL:',10,' ') ||  RPAD('NOMBRE:',10,' ') ||'TIENE SALARIO:');
        DBMS_OUTPUT.PUT_LINE('==================================');
    FOR DE IN(
        SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL >= SALIN
    )
    LOOP 
       
        DBMS_OUTPUT.PUT_LINE(RPAD(DE.EMPNO,10,' ') ||RPAD(DE.ENAME,10,' ')||LPAD(DE.SAL,12,' ')||'€');
        
    END LOOP;
    
END;
/



--.7 SACAR EL NOMBRE y LOC DEL DEPARTAMENTO QUE CORRESPONDE AL DEPTNO INTRODUCIDO POR TECLADO
--EL BLOQUE HARÁ UN SELECT PAR BUSCAR EL NOOMBRE DEL DEPARTAMENTO ASOCIADO AL ID DEL DPTO INTRODUCIDO
--NECESITAMOS UNA VARIABLE PARA ALMACENAR EL DATO SELECCIONADO EN ELLA Y LUEGO IMPRIMIRLO
--DESPUÉS AÑADIREMOS UNA EXCEPCIÓN PARA CUANDO NO SE ENCUENTRE EL ID EN LA TABLA DEPT

DECLARE
     IDDEPT DEPT.DEPTNO%TYPE:='&NUMERO_DPTO';
     NOMBRED DEPT.DNAME%TYPE;
     VLOC DEPT.LOC%TYPE;
BEGIN
    SELECT DNAME,LOC INTO NOMBRED,VLOC FROM DEPT WHERE DEPTNO = IDDEPT;
    DBMS_OUTPUT.PUT_LINE('El dpto con id =  ' || IDDEPT || ' es '|| NOMBRED||' y está en '||vloc);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El DPTO con ID = '||IDDEPT ||' no existe ');
END;
/


--LPAD Y RPAD PARA RELLENAR CONTENIDO

SELECT RPAD('XYZ',10,'*') FROM DUAL;

SELECT LPAD('XYZ',10,'-') FROM DUAL;






