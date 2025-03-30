-- Basic tables for Brokkr platform

-- Create profiles table if it doesn't exist
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE,
  updated_at TIMESTAMP WITH TIME ZONE,
  username TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  website TEXT,
  is_maker BOOLEAN DEFAULT FALSE,
  is_designer BOOLEAN DEFAULT FALSE,
  bio TEXT,
  PRIMARY KEY (id)
);

-- Create settings table if it doesn't exist
CREATE TABLE IF NOT EXISTS settings (
  id UUID REFERENCES auth.users ON DELETE CASCADE,
  updated_at TIMESTAMP WITH TIME ZONE,
  email_notifications BOOLEAN DEFAULT TRUE,
  push_notifications BOOLEAN DEFAULT TRUE,
  theme TEXT DEFAULT 'light',
  language TEXT DEFAULT 'en',
  PRIMARY KEY (id)
);

-- Setup RLS policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Settings are viewable by user only." ON settings FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own settings." ON settings FOR UPDATE USING (auth.uid() = id);