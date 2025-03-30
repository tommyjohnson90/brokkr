-- Create messaging system tables

-- Create message threads table
CREATE TABLE IF NOT EXISTS message_threads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create thread participants table
CREATE TABLE IF NOT EXISTS thread_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    thread_id UUID REFERENCES message_threads(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    is_muted BOOLEAN DEFAULT FALSE,
    last_read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(thread_id, user_id)
);

-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    thread_id UUID REFERENCES message_threads(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES auth.users(id),
    content TEXT NOT NULL,
    is_system_message BOOLEAN DEFAULT FALSE,
    read_by JSONB DEFAULT '[]',
    attachments JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Setup RLS policies
ALTER TABLE message_threads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view threads they participate in" ON message_threads 
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM thread_participants
            WHERE thread_participants.thread_id = message_threads.id
            AND thread_participants.user_id = auth.uid()
        )
    );

ALTER TABLE thread_participants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can see participants in their threads" ON thread_participants
    FOR SELECT USING (
        thread_participants.user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM thread_participants tp
            WHERE tp.thread_id = thread_participants.thread_id
            AND tp.user_id = auth.uid()
        )
    );

ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can see messages in threads they participate in" ON messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM thread_participants
            WHERE thread_participants.thread_id = messages.thread_id
            AND thread_participants.user_id = auth.uid()
        )
    );
CREATE POLICY "Users can send messages to threads they participate in" ON messages
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM thread_participants
            WHERE thread_participants.thread_id = messages.thread_id
            AND thread_participants.user_id = auth.uid()
        )
    );