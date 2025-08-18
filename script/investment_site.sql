DO $$
    DECLARE
i integer;
        franchise_count integer;
        franchise_id integer;
        base_lat float := 41.268;  -- Omaha center-ish
        base_lng float := -96.197;
BEGIN
        -- Get counts
SELECT COUNT(*) INTO franchise_count FROM franchises;

FOR i IN 1..15 LOOP
                -- Pick a random franchise
SELECT id INTO franchise_id
FROM franchises
         OFFSET floor(random() * franchise_count)
                    LIMIT 1;

-- Insert random coordinates near Omaha
INSERT INTO investment_sites (
    latitude, longitude, franchise_id, created_at, updated_at
) VALUES (
             base_lat + (random() - 0.5) * 0.25,  -- ±0.025° ≈ ±2-3km
             base_lng + (random() - 0.5) * 0.25,  -- ±0.025° ≈ ±2-3km
             franchise_id,
             now(),
             now()
         );
END LOOP;
END
$$;
