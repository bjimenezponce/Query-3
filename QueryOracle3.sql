 Funcion para Calculo de los años de trabajo 

--nunca va dimencionado el parametro que se solicita --
CREATE OR REPLACE FUNCTION fn_calculo_anios_trabajo (
   --se crea la variable de rut para que el programa la guarde--
    p_run NUMBER
) RETURN NUMBER AS
    v_anios_trabajo NUMBER(2);
BEGIN
    SELECT
        trunc(months_between(sysdate, fecha_contrato) / 12) 
        --guardamos en la variable de trabajo-- 
    INTO v_anios_trabajo
    FROM
        medico
    WHERE
        med_run = p_run;

 -- retornamos la variable despues de trabajar con ella--

    RETURN v_anios_trabajo;
END fn_calculo_anios_trabajo;
--------------------------------------------------------------------

Procedimiento para tomar los datos de la tabla FN

CREATE OR REPLACE PROCEDURE sp_calculo_de_bono (
-- variable creada para indicar que tomaremos el run de los medicos para obtener sus datos--
    p_run NUMBER
) AS

--creacion de variables a ocupar o almacenar--
    v_anios_trabajo   NUMBER(2);
    v_bono            NUMBER(8);
    v_sueldo_base     NUMBER(8);
    
 -- se crea el bloque "anonimo" parapoder hacer funcionar el programa--    
BEGIN
    SELECT
        fn_calculo_anios_trabajo(p_run),
        sueldo_base
    INTO
        v_anios_trabajo,
        v_sueldo_base
    FROM
        medico
    WHERE
        med_run = p_run;
        
        -- ahora haremos ciclo para poder sumar el bono--

    IF v_anios_trabajo < 1 THEN
        v_bono := 0;
    ELSIF v_anios_trabajo BETWEEN 1 AND 5 THEN
        v_bono := 50000;
    ELSIF v_anios_trabajo BETWEEN 6 AND 10 THEN
        v_bono := 100000;
    ELSIF v_anios_trabajo BETWEEN 11 AND 15 THEN
        v_bono := 150000;
    ELSIF v_anios_trabajo BETWEEN 16 AND 20 THEN
        v_bono := 200000;
    ELSIF v_anios_trabajo > 20 THEN
        v_bono := 250000;
    END IF;
             
        -- actualizamos datos--

    UPDATE medico
    SET
        sueldo_base = sueldo_base + v_bono
    WHERE
        med_run = p_run;


  -- se puede imprimir la INFO tomando los datos de la funcion creada para recolectar los años de trabajo en caso de querer ver resultado-- 

END sp_calculo_de_bono;


----------------------------------------------------------------------

query para obtener todos los datos antes nombrados y ordenados

BEGIN
    sp_calculo_de_bono( x );
END;