-- PostApp Database Schema
-- Complete schema for all tables with rich text support

-- Create posts table with rich text support
CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    subtitle TEXT NOT NULL,
    body TEXT NOT NULL,
    html_body TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments to document the table and columns
COMMENT ON TABLE posts IS 'Blog posts with rich text support';
COMMENT ON COLUMN posts.id IS 'Unique identifier for the post';
COMMENT ON COLUMN posts.title IS 'Post title (plain text)';
COMMENT ON COLUMN posts.subtitle IS 'Post subtitle (plain text)';
COMMENT ON COLUMN posts.body IS 'Post content as plain text (fallback)';
COMMENT ON COLUMN posts.html_body IS 'Post content as HTML for rich text formatting';
COMMENT ON COLUMN posts.created_at IS 'Timestamp when the post was created';

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_title ON posts(title);

-- Optional: Full-text search indexes
-- CREATE INDEX IF NOT EXISTS idx_posts_body_fulltext ON posts USING gin(to_tsvector('english', body));
-- CREATE INDEX IF NOT EXISTS idx_posts_html_body_fulltext ON posts USING gin(to_tsvector('english', html_body));

-- Enable Row Level Security
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Create policies for posts
-- Allow everyone to read posts
CREATE POLICY IF NOT EXISTS "Posts are viewable by everyone"
ON posts FOR SELECT
USING (true);

-- Allow authenticated users to create posts
CREATE POLICY IF NOT EXISTS "Authenticated users can create posts"
ON posts FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Allow post authors to update their own posts (optional - requires user_id column)
-- CREATE POLICY IF NOT EXISTS "Users can update their own posts"
-- ON posts FOR UPDATE
-- USING (auth.uid() = user_id);

-- Allow post authors to delete their own posts (optional - requires user_id column)
-- CREATE POLICY IF NOT EXISTS "Users can delete their own posts"
-- ON posts FOR DELETE
-- USING (auth.uid() = user_id);

-- Future enhancement: Add user_id column for multi-user support
-- ALTER TABLE posts ADD COLUMN user_id UUID REFERENCES auth.users(id);
