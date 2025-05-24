# PostApp - SwiftUI Blog Application

A modern SwiftUI blog application built with iOS 18 APIs, featuring a clean architecture and ready for Supabase integration.

## Features

- ✅ Display list of blog posts with title, subtitle, and creation date
- ✅ Navigate to detailed post view by tapping on a post
- ✅ Create new posts using a sheet presentation
- ✅ **Rich Text Editor** with formatting toolbar (Bold, Italic, Underline, Colors, Text Sizes)
- ✅ **HTML Storage** for rich text content with AttributedString display
- ✅ Modern SwiftUI with iOS 18 Observable macro
- ✅ Proper separation of concerns with MVVM architecture
- ✅ Full Supabase integration for data persistence

## Architecture

The app follows a clean architecture pattern with proper separation of concerns:

```
PostApp/
├── Models/
│   └── Post.swift              # Post data model
├── Services/
│   └── SupabaseService.swift   # Service layer for data operations
├── Repositories/
│   └── PostsRepository.swift   # Repository pattern for state management
├── Views/
│   ├── Posts/
│   │   ├── PostsListView.swift    # Main posts list
│   │   ├── PostDetailView.swift   # Post detail view
│   │   └── CreatePostView.swift   # Create new post sheet
│   └── Components/
│       ├── PostRowView.swift      # Reusable post row component
│       ├── RichTextEditor.swift   # Rich text editing component
│       └── RichTextToolbar.swift  # Formatting toolbar
└── PostAppApp.swift            # App entry point
```

## Requirements

- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

## Getting Started

1. Open `PostApp.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (⌘+R)

## Supabase Integration

The app includes full Supabase integration with rich text support. Follow these steps to set up your database:

### 1. Prerequisites

The Supabase Swift SDK is already included in the project (version 2.29.0).

### 2. Configure Supabase

Create a `Secret.plist` file in your project with your Supabase credentials:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>supabaseUrl</key>
    <string>YOUR_SUPABASE_URL</string>
    <key>supabaseKey</key>
    <string>YOUR_SUPABASE_ANON_KEY</string>
</dict>
</plist>
```

### 3. Database Setup

Choose one of the following options:

#### Option A: New Installation
If setting up for the first time, run the complete schema:
1. Open your Supabase project → SQL Editor
2. Copy and paste the contents of `PostApp/Database/schema.sql`
3. Click "Run"

#### Option B: Existing Installation
If you already have the basic posts table, run the migration:
1. Open your Supabase project → SQL Editor
2. Copy and paste the contents of `PostApp/Database/migration_add_html_body.sql`
3. Click "Run"

### 4. Database Schema

The posts table includes rich text support:

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key |
| `title` | TEXT | Post title |
| `subtitle` | TEXT | Post subtitle |
| `body` | TEXT | Plain text (fallback) |
| `html_body` | TEXT | Rich text as HTML |
| `created_at` | TIMESTAMP | Creation date |

See `PostApp/Database/README.md` for complete setup instructions.

## Usage

### Viewing Posts
- Launch the app to see the list of posts
- Pull down to refresh the posts list
- Tap on any post to view its full content with rich text formatting

### Creating Posts with Rich Text
- Tap the "+" button in the navigation bar
- Fill in the title and subtitle
- Use the rich text editor for the body content:
  - **Select text** to apply formatting
  - **Bold/Italic/Underline**: Tap the respective buttons
  - **Text Size**: Use the size menu (Small, Normal, Large, Extra Large)
  - **Text Color**: Choose from color palette (Default, Red, Blue, Green, Orange, Purple)
  - **Clear Formatting**: Remove all styling from selected text
- Tap "Create" to save the post

### Rich Text Formatting
- Select any text in the editor
- Use the toolbar at the bottom of the screen
- Multiple formats can be combined (e.g., bold + italic + colored)
- The toolbar shows which formats are currently active

### Post Details
- Tap on any post in the list to view details
- Rich text formatting is preserved and displayed
- Text remains selectable for copying
- Tap "Done" to dismiss the detail view

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **iOS 18 Observable**: Latest state management with `@Observable` macro
- **Rich Text Editing**: Custom UITextView integration with formatting toolbar
- **AttributedString**: SwiftUI native rich text display
- **HTML Storage**: Cross-platform rich text format
- **Swift Concurrency**: Async/await for network operations
- **MVVM Architecture**: Clean separation of concerns
- **Repository Pattern**: Centralized data management
- **Supabase**: Full-featured backend with PostgreSQL

## Future Enhancements

### Rich Text Features
- [ ] Lists (bullet points, numbered lists)
- [ ] Text alignment (left, center, right, justify)
- [ ] Link insertion and editing
- [ ] Image embedding in posts
- [ ] Code blocks with syntax highlighting
- [ ] Undo/redo functionality
- [ ] Markdown import/export

### General Features
- [ ] User authentication
- [ ] Edit and delete posts
- [ ] Search functionality (including rich text search)
- [ ] Categories/tags for posts
- [ ] Comments system
- [ ] Offline support with local caching
- [ ] Export posts as PDF/HTML
- [ ] Post drafts and auto-save

## License

This project is available for educational purposes.
