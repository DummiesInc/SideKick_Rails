CREATE OR REPLACE FUNCTION insert_disciplines()
    RETURNS void AS $$
DECLARE
    i INT := 1;
    dt_now TIMESTAMP := NOW();
    names TEXT[] := ARRAY[
        'DIAGNOSTIC IMAGING',
        'CARDIOPULMONARY',
        'MEDICAL LABORATORY',
        'ONCOLOGY',
        'REHAB THERAPY',
        'NEURODIAGNOSTIC',
        'RN',
        'PHARMACY',
        'CNA',
        'LPN',
        'MEDICAL ASSISTANT',
        'SURGICAL TECHS',
        'ADMINISTRATION',
        'APPLIED BEHAVIORAL ANALYSIS',
        'MEDICATION AIDE'
        ];

BEGIN
    WHILE i <= count(names) LOOP
            INSERT INTO "disciplines" (
                "abbreviation", "name", "isForProvider", "created_at", "updated_at"
            ) VALUES (
                         '', names[i], false, now(), now()
                     );
            i := i + 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;


SELECT insert_disciplines();