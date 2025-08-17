DO $$
    DECLARE
capital_name text[] := ARRAY[
            'Under $100,000', '$150,000 - $500,000', '$550,000 - $1,000,000', 'Over $1,000,000'
            ];
BEGIN
FOR i IN 1..30 LOOP

                INSERT INTO capitals (
                    name,created_at, updated_at
                ) VALUES (
                        capital_name[i],
                          now(), now()
                         );
END LOOP;
END
$$;
