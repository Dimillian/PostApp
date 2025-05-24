# Database Setup Guide

This directory contains the database schema and migration files for PostApp with rich text support.

## Files

- `schema.sql` - Complete database schema for fresh installations
- `migration_add_html_body.sql` - Migration script to add rich text support to existing installations

## Setup Instructions

### For New Installations

If you're setting up PostApp for the first time:

1. Open your Supabase project dashboard
2. Go to the SQL Editor
3. Copy and paste the contents of `schema.sql`
4. Click "Run" to create the complete schema

### For Existing Installations

If you already have a PostApp database and want to add rich text support:

1. Open your Supabase project dashboard
2. Go to the SQL Editor
3. Copy and paste the contents of `migration_add_html_body.sql`
4. Click "Run" to add the `html_body` column

## Database Schema

### Posts Table

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key, auto-generated |
| `title` | TEXT | Post title (required) |
| `subtitle` | TEXT | Post subtitle (required) |
| `body` | TEXT | Plain text content (fallback) |
| `html_body` | TEXT | Rich text content as HTML (optional) |
| `created_at` | TIMESTAMP | Creation timestamp |

### Rich Text Storage

The app stores rich text in two formats:

1. **Plain Text (`body`)**: Fallback content for compatibility
2. **HTML (`html_body`)**: Rich text formatting stored as HTML

When displaying posts:
- If `html_body` exists, it's converted to AttributedString for rich display
- If `html_body` is null, falls back to plain text in `body` column

### Security Policies

- **Read**: Everyone can read posts (public access)
- **Create**: Only authenticated users can create posts
- **Update/Delete**: Currently open (future: restrict to post authors)

## Migration Verification

After running the migration, verify it worked:

```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'posts'
ORDER BY ordinal_position;
```

Expected output should include the `html_body` column.

## Performance Considerations

### Indexes

The schema includes these indexes for optimal performance:

- `idx_posts_created_at` - For ordering posts by date
- `idx_posts_title` - For title-based searches

### Optional Full-Text Search

For advanced search capabilities, you can enable full-text search indexes:

```sql
-- Enable full-text search on body content
CREATE INDEX idx_posts_body_fulltext
ON posts USING gin(to_tsvector('english', body));

-- Enable full-text search on HTML content
CREATE INDEX idx_posts_html_body_fulltext
ON posts USING gin(to_tsvector('english', html_body));
```

## Future Enhancements

The schema is designed to support future features:

- **User Authentication**: Add `user_id` column to associate posts with users
- **Categories/Tags**: Add related tables for post organization
- **Comments**: Add comments table for user engagement
- **Media**: Add support for images and attachments

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure you have admin access to your Supabase project
2. **Column Already Exists**: If you see this error, the migration was already applied
3. **RLS Violations**: Check that your app is properly authenticated with Supabase

### Testing the Schema

You can test the schema by creating a sample post:

```sql
INSERT INTO posts (title, subtitle, body, html_body) VALUES (
    'Sample Rich Text Post',
    'Testing the new rich text feature',
    'This is plain text content.',
    '<p>This is <strong>rich text</strong> with <em>formatting</em>!</p>'
);
```
