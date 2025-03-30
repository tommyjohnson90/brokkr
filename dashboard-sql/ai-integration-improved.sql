-- Create AI integration tables

-- Create AI models table
CREATE TABLE IF NOT EXISTS ai_models (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    provider TEXT NOT NULL,
    model_type TEXT NOT NULL,
    version TEXT,
    description TEXT,
    capabilities JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create AI agent types table
CREATE TABLE IF NOT EXISTS ai_agent_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    capabilities JSONB,
    default_model_id UUID REFERENCES ai_models(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create AI agent instances table
CREATE TABLE IF NOT EXISTS ai_agent_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_type_id UUID REFERENCES ai_agent_types(id),
    user_id UUID REFERENCES auth.users(id),
    model_id UUID REFERENCES ai_models(id),
    name TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    configuration JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create AI interactions table
CREATE TABLE IF NOT EXISTS ai_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_instance_id UUID REFERENCES ai_agent_instances(id),
    user_id UUID REFERENCES auth.users(id),
    session_id UUID,
    prompt TEXT NOT NULL,
    response TEXT,
    metadata JSONB,
    rating INTEGER,
    feedback TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Setup RLS policies
ALTER TABLE ai_models ENABLE ROW LEVEL SECURITY;
CREATE POLICY "AI models are viewable by everyone" ON ai_models FOR SELECT USING (true);

ALTER TABLE ai_agent_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "AI agent types are viewable by everyone" ON ai_agent_types FOR SELECT USING (true);

ALTER TABLE ai_agent_instances ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their agent instances" ON ai_agent_instances FOR SELECT USING (
    user_id = auth.uid()
);
CREATE POLICY "Users can update their agent instances" ON ai_agent_instances FOR UPDATE USING (
    user_id = auth.uid()
);

ALTER TABLE ai_interactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their AI interactions" ON ai_interactions FOR SELECT USING (
    user_id = auth.uid()
);
CREATE POLICY "Users can create AI interactions" ON ai_interactions FOR INSERT WITH CHECK (
    user_id = auth.uid()
);