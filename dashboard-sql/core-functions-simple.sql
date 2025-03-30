-- Core database functions for Brokkr platform

-- Function to get current timestamp with timezone
CREATE OR REPLACE FUNCTION get_current_timestamp()
RETURNS TIMESTAMP WITH TIME ZONE AS $$
BEGIN
  RETURN CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Function to check if a table exists
CREATE OR REPLACE FUNCTION table_exists(table_name text) 
RETURNS BOOLEAN AS $$
DECLARE
  exists_bool BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public'
    AND table_name = $1
  ) INTO exists_bool;
  
  RETURN exists_bool;
END;
$$ LANGUAGE plpgsql;