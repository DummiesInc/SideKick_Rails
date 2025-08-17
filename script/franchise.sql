
-- Generate 30 random franchises
DO $$
    DECLARE
i integer;
        capital_count integer;
        capital_id integer;
        franchise_names text[] := ARRAY[
            'McDonalds', 'Burger King', 'Subway', 'Walmart', 'Lowes',
            '7-Eleven', 'Dominos Pizza', 'Pizza Hut', 'KFC', 'Starbucks',
            'Dunkin Donuts', 'Taco Bell', 'Chipotle', 'Target', 'Whole Foods',
            'Costco', 'Panera Bread', 'FedEx Office', 'UPS Store', 'Circle K',
            'Marriott', 'Hilton', 'InterContinental', 'Holiday Inn', 'Ritz-Carlton',
            'Best Buy', 'GameStop', 'Lowes', 'Home Depot', 'Trader Joes'
        ];
        buy_in_reasons text[] := ARRAY[
            'Replace my full time job',
            'Build a semi-passive income stream',
            'Expand my business portfolio',
            'Pursue a passion or personal interest'
            ];
        visions text[] := ARRAY[
            'Operate a single location successfully',
            'Build multiple locations in my region',
            'Grow and sell the business within 5 - 10 years',
            'Create a family legacy business'
            ];
        involvements text[] := ARRAY[
            'Full time owner-operator',
            'Part time / semi-absentee',
            'Investor only (hire management team)'
            ];
BEGIN
SELECT COUNT(*) INTO capital_count FROM capitals;

FOR i IN 1..30 LOOP
                -- Pick a random capital_id
SELECT id INTO capital_id
FROM capitals
         OFFSET floor(random() * capital_count)
                    LIMIT 1;

-- Insert random franchise
INSERT INTO franchises (
    name,
    buy_in_reason,
    vision,
    involvement,
    capital_id,
    finance_required,
    start_date, created_at, updated_at
) VALUES (
             franchise_names[i],
             buy_in_reasons[floor(random()*array_length(buy_in_reasons,1)+1)],
             visions[floor(random()*array_length(visions,1)+1)],
             involvements[floor(random()*array_length(involvements,1)+1)],
             capital_id,
             (random() < 0.5),
             NOW() - (random()*365)::int * INTERVAL '1 day',
             now(), now()
         );
END LOOP;
END
$$;
