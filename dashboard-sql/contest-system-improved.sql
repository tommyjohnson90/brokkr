-- Create contest system tables

-- Create contests table
CREATE TABLE IF NOT EXISTS contests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID REFERENCES auth.users(id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    prize_description TEXT,
    prize_amount DECIMAL,
    royalty_percentage DECIMAL,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'draft',
    max_submissions INTEGER,
    is_featured BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    category TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create contest submissions table
CREATE TABLE IF NOT EXISTS contest_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contest_id UUID REFERENCES contests(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id),
    design_id UUID REFERENCES designs(id),
    title TEXT NOT NULL,
    description TEXT,
    submission_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'submitted',
    score DECIMAL,
    feedback TEXT,
    is_winner BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create contest votes table
CREATE TABLE IF NOT EXISTS contest_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID REFERENCES contest_submissions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(submission_id, user_id)
);

-- Setup RLS policies
ALTER TABLE contests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Contests are viewable by everyone" ON contests FOR SELECT USING (
    status = 'published' OR creator_id = auth.uid()
);
CREATE POLICY "Creators can update their contests" ON contests FOR UPDATE USING (
    creator_id = auth.uid()
);

ALTER TABLE contest_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Submissions visible to everyone for published contests" ON contest_submissions FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM contests 
        WHERE contests.id = contest_submissions.contest_id
        AND (contests.status = 'published' OR contests.creator_id = auth.uid())
    )
);
CREATE POLICY "Users can update their own submissions" ON contest_submissions FOR UPDATE USING (
    user_id = auth.uid()
);

ALTER TABLE contest_votes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can see votes on viewable submissions" ON contest_votes FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM contest_submissions
        JOIN contests ON contests.id = contest_submissions.contest_id
        WHERE contest_submissions.id = contest_votes.submission_id
        AND (contests.status = 'published' OR contests.creator_id = auth.uid())
    )
);
CREATE POLICY "Users can vote once per submission" ON contest_votes FOR INSERT WITH CHECK (
    NOT EXISTS (
        SELECT 1 FROM contest_votes
        WHERE submission_id = contest_votes.submission_id
        AND user_id = auth.uid()
    )
);