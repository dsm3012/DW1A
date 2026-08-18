--listado de fechas alta de empleados
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date ASC;

--1 EMPLEADOS DADOS DE ALTA DESDE 1 DE ENERO DE 2005
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= TO_DATE('01-01-2005', 'DD-MM-YYYY')
ORDER BY HIRE_DATE;

--2 EXTRACCION DE AÑO
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2002
ORDER BY HIRE_DATE;

--3 EXTRACCION DE MES
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(MONTH FROM hire_date) IN (01,02,03)--BETWEEN 01 AND 03
ORDER BY HIRE_DATE;

--4 DATOS DE EMPLEADOS CON FECHA DE ALTA DE 90 DIAS ANTES DE LA FECHA ACTUAL

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date <= SYSDATE - 90;

--5 AÑOS DE SERVICIO EN LA EMPRESA DE LOS EMPLEADOS

SELECT first_name, last_name,hire_date,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date) / 12, 2) AS años_servicio
FROM employees
ORDER BY años_servicio desc;


--6 TOTAL DE EMPLEADOS QUE HAY POR AÑO DE ALTA --AGRUPO Y CUENTO
SELECT EXTRACT(YEAR FROM hire_date) AS año_alta,
       COUNT(*) AS total_empleados_por_año
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY año_alta;

--FUNCIONES RELACIONADAS CON FECHA Y HORA ACTUAL:

--1. SYSDATE
--Devuelve la fecha y hora actual del sistema.
SELECT SYSDATE FROM dual;

--2. CURRENT_DATE
--Devuelve la fecha actual según la zona horaria del usuario.
SELECT CURRENT_DATE FROM dual;


--3. SYSTIMESTAMP
--Incluye fecha, hora y fracción de segundo con zona horaria.

SELECT SYSTIMESTAMP FROM dual;

--CONVERSION DE FECHAS
--TO_DATE
--Convierte una cadena a tipo fecha.

SELECT TO_DATE('31-10-2025', 'DD-MM-YYYY') FROM dual;

-- TO_CHAR
--Convierte una fecha a cadena con formato personalizado.
SELECT TO_CHAR(hire_date, 'DD-Mon-YYYY') FROM employees;


--OTRAS FUNCIONES:
--LAST_DAY
SELECT LAST_DAY('01-02-2024') FROM DUAL;

--NEXT_DAY
SELECT NEXT_DAY(SYSDATE,'Lunes') FROM DUAL;

--add_months
--nombre, fecha alta y fecha de fin de periodo(6 meses) de prácticas
SELECT FIRST_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE,6) AS "FIN PERIODO PRUEBAS" FROM EMPLOYEES;
