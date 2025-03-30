-- Create API integration tables

-- Create API keys table
CREATE TABLE IF NOT EXISTS api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    key_hash TEXT NOT NULL,
    scopes TEXT[] NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    last_used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create API usage logs table
CREATE TABLE IF NOT EXISTS api_usage_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    api_key_id UUID REFERENCES api_keys(id),
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    status_code INTEGER,
    response_time INTEGER,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create webhooks table
CREATE TABLE IF NOT EXISTS webhooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    events TEXT[] NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    secret_hash TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create webhook delivery logs table
CREATE TABLE IF NOT EXISTS webhook_delivery_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    webhook_id UUID REFERENCES webhooks(id),
    event_type TEXT NOT NULL,
    payload JSONB,
    response_status INTEGER,
    response_body TEXT,
    attempt_count INTEGER DEFAULT 0,
    successful BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Setup RLS policies
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own API keys" ON api_keys FOR SELECT USING (
    user_id = auth.uid()
);
CREATE POLICY "Users can manage their own API keys" ON api_keys FOR ALL USING (
    user_id = auth.uid()
);

ALTER TABLE api_usage_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view logs for their API keys" ON api_usage_logs FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM api_keys
        WHERE api_keys.id = api_usage_logs.api_key_id
        AND api_keys.user_id = auth.uid()
    )
);

ALTER TABLE webhooks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own webhooks" ON webhooks FOR SELECT USING (
    user_id = auth.uid()
);
CREATE POLICY "Users can manage their own webhooks" ON webhooks FOR ALL USING (
    user_id = auth.uid()
);

ALTER TABLE webhook_delivery_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view logs for their webhooks" ON webhook_delivery_logs FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM webhooks
        WHERE webhooks.id = webhook_delivery_logs.webhook_id
        AND webhooks.user_id = auth.uid()
    )
);