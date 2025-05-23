# PostApp - SwiftUI Blog Application

A modern SwiftUI blog application built with iOS 18 APIs, featuring a clean architecture and ready for Supabase integration.

## Features

- ✅ Display list of blog posts with title, subtitle, and creation date
- ✅ Navigate to detailed post view by tapping on a post
- ✅ Create new posts using a sheet presentation
- ✅ Modern SwiftUI with iOS 18 Observable macro
- ✅ Proper separation of concerns with MVVM architecture
- ✅ Mock data implementation (ready for Supabase integration)

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
│       └── PostRowView.swift      # Reusable post row component
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

The app is designed to work with Supabase but currently uses mock data. To integrate with Supabase:

### 1. Add Supabase SDK

Add the Supabase Swift SDK to your project:

1. In Xcode, go to File → Add Package Dependencies
2. Enter the URL: `https://github.com/supabase/supabase-swift`
3. Choose version 2.0.0 or later
4. Add the `Supabase` product to your app target

### 2. Configure Supabase

Update `SupabaseService.swift` with your Supabase credentials:

```swift
private init() {
    self.supabase = SupabaseClient(
        supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
        supabaseKey: "YOUR_SUPABASE_ANON_KEY"
    )
}
```

### 3. Create Database Table

Create a `posts` table in your Supabase database:

```sql
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    subtitle TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Create a policy to allow all users to read posts
CREATE POLICY "Posts are viewable by everyone"
ON posts FOR SELECT
USING (true);

-- Create a policy to allow authenticated users to create posts
CREATE POLICY "Authenticated users can create posts"
ON posts FOR INSERT
WITH CHECK (auth.role() = 'authenticated');
```

### 4. Update Service Implementation

Replace the mock implementation in `SupabaseService.swift` with the actual Supabase calls (the code is already prepared, just uncomment the Supabase implementation and remove the mock one).

## Usage

### Viewing Posts
- Launch the app to see the list of posts
- Pull down to refresh the posts list
- Tap on any post to view its full content

### Creating Posts
- Tap the "+" button in the navigation bar
- Fill in the title, subtitle, and body
- Tap "Create" to save the post

### Post Details
- Tap on any post in the list to view details
- The detail view shows the full content with proper formatting
- Tap "Done" to dismiss the detail view

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **iOS 18 Observable**: Latest state management with `@Observable` macro
- **Swift Concurrency**: Async/await for network operations
- **MVVM Architecture**: Clean separation of concerns
- **Repository Pattern**: Centralized data management

## Future Enhancements

- [ ] User authentication
- [ ] Edit and delete posts
- [ ] Search functionality
- [ ] Categories/tags for posts
- [ ] Rich text editor
- [ ] Image upload support
- [ ] Comments system
- [ ] Offline support with local caching

## License

This project is available for educational purposes.
