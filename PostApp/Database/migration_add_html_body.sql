-- Migration: Add html_body column for rich text support
-- Run this in your Supabase SQL editor or via migration tools

-- Add html_body column to posts table
ALTER TABLE posts
ADD COLUMN html_body TEXT;

-- Add a comment to document the column purpose
COMMENT ON COLUMN posts.html_body IS 'Stores rich text content as HTML for the post body';

-- Optional: Add an index on html_body for text search if needed
-- CREATE INDEX idx_posts_html_body_fulltext ON posts USING gin(to_tsvector('english', html_body));

-- Verify the migration
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_name = 'posts'
-- ORDER BY ordinal_position;
