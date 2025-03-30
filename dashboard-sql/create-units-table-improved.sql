-- Create units table for measurements

CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    abbreviation TEXT NOT NULL,
    category TEXT NOT NULL,
    si_equivalent DECIMAL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, category),
    UNIQUE(abbreviation, category)
);

-- Common measurement units
INSERT INTO units (name, abbreviation, category, si_equivalent)
VALUES
    ('Millimeter', 'mm', 'length', 0.001),
    ('Centimeter', 'cm', 'length', 0.01),
    ('Meter', 'm', 'length', 1),
    ('Inch', 'in', 'length', 0.0254),
    ('Foot', 'ft', 'length', 0.3048),
    ('Gram', 'g', 'mass', 0.001),
    ('Kilogram', 'kg', 'mass', 1),
    ('Pound', 'lb', 'mass', 0.45359237),
    ('Celsius', '°C', 'temperature', 1),
    ('Fahrenheit', '°F', 'temperature', NULL),
    ('Kelvin', 'K', 'temperature', 1),
    ('Cubic centimeter', 'cm³', 'volume', 0.000001),
    ('Cubic meter', 'm³', 'volume', 1),
    ('Liter', 'L', 'volume', 0.001),
    ('Milliliter', 'mL', 'volume', 0.000001),
    ('Cubic inch', 'in³', 'volume', 0.0000163871),
    ('Cubic foot', 'ft³', 'volume', 0.0283168),
    ('Gallon (US)', 'gal', 'volume', 0.00378541),
    ('Square meter', 'm²', 'area', 1),
    ('Square centimeter', 'cm²', 'area', 0.0001),
    ('Square inch', 'in²', 'area', 0.00064516),
    ('Square foot', 'ft²', 'area', 0.092903),
    ('Hertz', 'Hz', 'frequency', 1),
    ('Kilohertz', 'kHz', 'frequency', 1000),
    ('Megahertz', 'MHz', 'frequency', 1000000),
    ('Revolution per minute', 'RPM', 'rotation_speed', 0.0166667),
    ('Newton', 'N', 'force', 1),
    ('Pound-force', 'lbf', 'force', 4.44822),
    ('Pascal', 'Pa', 'pressure', 1),
    ('Bar', 'bar', 'pressure', 100000),
    ('PSI', 'psi', 'pressure', 6894.76),
    ('Watt', 'W', 'power', 1),
    ('Kilowatt', 'kW', 'power', 1000)
ON CONFLICT (name, category) DO NOTHING;