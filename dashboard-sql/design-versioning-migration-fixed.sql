-- Create design versioning system

-- Create design versions table
CREATE TABLE IF NOT EXISTS design_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    design_id UUID REFERENCES designs(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    changes_description TEXT,
    files_url JSONB,
    requirements JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES auth.users(id),
    UNIQUE(design_id, version_number)
);

-- Create design change history table
CREATE TABLE IF NOT EXISTS design_change_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    design_id UUID REFERENCES designs(id) ON DELETE CASCADE,
    version_from INTEGER,
    version_to INTEGER NOT NULL,
    change_type TEXT NOT NULL,
    change_description TEXT,
    changed_fields JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES auth.users(id)
);

-- Create trigger function for design version history
CREATE OR REPLACE FUNCTION design_version_history_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO design_change_history (
        design_id, 
        version_from, 
        version_to, 
        change_type, 
        change_description,
        changed_fields,
        created_by
    ) VALUES (
        NEW.design_id,
        (SELECT MAX(version_number) FROM design_versions WHERE design_id = NEW.design_id AND version_number < NEW.version_number),
        NEW.version_number,
        'new_version',
        NEW.changes_description,
        jsonb_build_object(
            'files_url', NEW.files_url,
            'requirements', NEW.requirements
        ),
        NEW.created_by
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for design version history
CREATE TRIGGER design_version_history_insert_trigger
AFTER INSERT ON design_versions
FOR EACH ROW
EXECUTE FUNCTION design_version_history_trigger();

-- Setup RLS policies
ALTER TABLE design_versions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Design versions are viewable by everyone if design is public" ON design_versions FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM designs
        WHERE designs.id = design_versions.design_id
        AND (designs.is_public OR designs.user_id = auth.uid())
    )
);
CREATE POLICY "Designers can manage versions of their designs" ON design_versions FOR ALL USING (
    EXISTS (
        SELECT 1 FROM designs
        WHERE designs.id = design_versions.design_id
        AND designs.user_id = auth.uid()
    )
);

ALTER TABLE design_change_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Design change history is viewable if design is public" ON design_change_history FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM designs
        WHERE designs.id = design_change_history.design_id
        AND (designs.is_public OR designs.user_id = auth.uid())
    )
);