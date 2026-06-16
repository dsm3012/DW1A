El producto de 10 * 24 = 240

Procedimiento PL/SQL terminado correctamente.
Antiguo:DECLARE
    n1 NUMBER (2):= '&n1';
    n2 NUMBER (2):= '&n2';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Números introducidos '|| n1 ||' y '|| n2);
END;

Nuevo:DECLARE
    n1 NUMBER (2):= '6';
    n2 NUMBER (2):= '7';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Números introducidos '|| n1 ||' y '|| n2);
END;
Números introducidos 6 y 7

Procedimiento PL/SQL terminado correctamente.
