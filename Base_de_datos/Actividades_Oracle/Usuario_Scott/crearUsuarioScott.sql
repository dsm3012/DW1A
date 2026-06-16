DROP USER SCOTT CASCADE;


-- Sentencia para crear un usuario identificado con una contrasenia:
CREATE USER SCOTT IDENTIFIED BY scott
       DEFAULT TABLESPACE users  
       TEMPORARY TABLESPACE temp
       QUOTA UNLIMITED ON users;
       
-- Sentencia para asignar privilegios a un usuario:     
GRANT ALL PRIVILEGES TO SCOTT;