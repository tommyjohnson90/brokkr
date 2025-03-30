-- Create equipment specifications system

-- Create table for equipment specs templates
CREATE TABLE IF NOT EXISTS equipment_specs_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subtype_id UUID REFERENCES equipment_subtypes(id),
    name TEXT NOT NULL,
    description TEXT,
    data_type TEXT NOT NULL,
    unit_id UUID REFERENCES units(id),
    is_required BOOLEAN DEFAULT FALSE,
    min_value DECIMAL,
    max_value DECIMAL,
    allowed_values JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create equipment library table
CREATE TABLE IF NOT EXISTS equipment_library (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manufacturer_id UUID REFERENCES manufacturers(id),
    subtype_id UUID REFERENCES equipment_subtypes(id),
    model_name TEXT NOT NULL,
    model_number TEXT,
    description TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create specifications values table
CREATE TABLE IF NOT EXISTS equipment_specifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    equipment_id UUID REFERENCES equipment_library(id),
    template_id UUID REFERENCES equipment_specs_templates(id),
    value_text TEXT,
    value_number DECIMAL,
    value_boolean BOOLEAN,
    value_json JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);