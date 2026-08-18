-- Creacion de las tablas de SCOTT

CREATE TABLE DEPT (
        DEPTNO NUMBER(2),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13));
 
CREATE TABLE EMP (
        EMPNO NUMBER(4),
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        MGR NUMBER(4),
        HIREDATE DATE,
        SAL NUMBER(7,2),
        COMM NUMBER(7,2),
        DEPTNO NUMBER(2));
 
CREATE TABLE BONUS (
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        SAL NUMBER,
        COMM NUMBER);
         
CREATE TABLE SALGRADE (
        GRADE NUMBER,
        LOSAL NUMBER,
        HISAL NUMBER);