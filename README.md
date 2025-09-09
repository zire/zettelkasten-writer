# Zettelkasten Writer

> A unified, interactive workflow for writing and publishing across multiple websites simultaneously

## Overview

Zettelkasten Writer is a centralized writing workflow that manages content creation across multiple Hugo-based websites with a single command-line interface. Inspired by the Zettelkasten method of interconnected knowledge management, it provides a seamless experience for writers who maintain multiple publication channels.

## Features

### 🌐 Multi-Site Management
- Handle multiple websites from one interface
- Currently supports Digital Sovereignty Chronicle (more sites coming soon)
- Centralized configuration and workflow

### 📝 Interactive Menus
- Step-by-step guided workflow
- Direct selection by numbers (drafts) and letters (completed posts)
- Consistent color-coded interface (green for actions, yellow for navigation)

### 🤖 Smart Content Management
- **Create** (`n`) - New posts with frontmatter wizard and sensible defaults
- **Edit** (`1-99`) - Direct draft selection by number for immediate editing
- **Publish** (`a-z`) - Direct completed post selection by letter for publishing
- **Delete** (`d`) - Safe deletion with git history and confirmation

### 📁 Draft Management
- Visual status indicators: 🔴 (< 100 words), 🟡 (100-599 words), 🟢 (600+ words)
- Date-based sorting (newest first)
- Word count tracking and creation date display
- Git-based detection for publish-ready posts (draft: false + uncommitted changes)

### 🚀 One-Click Publishing
- Automated git workflow with descriptive commits
- Automatic deployment via existing CI/CD pipelines
- Post validation and confirmation prompts
- SEO-optimized URLs and metadata

### ✏️ Cursor Integration
- **Session-based theme switching**: Paper theme for writing, code theme for development
- Automated side-by-side markdown preview setup
- AppleScript automation for optimal writing layout
- Auto-save and spell checking integration

### 💾 Version Control
- Git integration for all operations (create, edit, publish, delete)
- Descriptive commit messages with metadata
- Proper handling of tracked and untracked files
- Full history preservation for content lifecycle

## Supported Sites

- **✅ Digital Sovereignty Chronicle** - Crypto, AI, and digital sovereignty insights
- **🔄 The Sunday Blender** - Making news interesting for kids *(coming soon)*
- **🔄 Herbert Yang (Personal)** - Personal blog and thoughts *(coming soon)*
- **🔄 Remnants of Globalization** - Newsletter about global changes *(coming soon)*

## Quick Start

```bash
# Interactive writing session
./zwrite

# Quick commands
./zwrite save "Post Title"     # Save draft progress to git
./zwrite publish "Post Title"  # Publish completed post
./zwrite status               # Show all drafts across sites
./zwrite help                 # Show all available commands
```

## Installation

1. **Clone this repository**
   ```bash
   git clone https://github.com/zire/zettelkasten-writer.git
   cd zettelkasten-writer
   ```

2. **Make scripts executable**
   ```bash
   chmod +x zwrite
   chmod +x lib/*.sh
   ```

3. **Configure your site paths**
   Edit `config/sites.json` with your website repository paths and settings

4. **Install Cursor editor**
   Download from [cursor.sh](https://cursor.sh) and install the Code Spell Checker extension

5. **Start writing**
   ```bash
   ./zwrite
   ```

## Workflow

### Complete Writing Lifecycle

1. **Launch** - Run `./zwrite` from anywhere
2. **Select Site** - Choose from your configured websites (currently DSC)
3. **Choose Action**:
   - **New post** (`n`) - Create with frontmatter wizard
   - **Edit draft** (`1-99`) - Direct number selection
   - **Publish** (`a-z`) - Direct letter selection for completed posts
   - **Delete draft** (`d`) - Safe removal with git history
4. **Write in Cursor** - Automatic theme switching and layout setup
5. **Manage Content** - Save progress, publish when ready
6. **Version Control** - All changes tracked in git with descriptive commits

### Draft Status Flow

```
🔴 New Draft (< 100 words)
    ↓ (continue writing)
🟡 In Progress (100-599 words)
    ↓ (continue writing)
🟢 Substantial Draft (600+ words)
    ↓ (set draft: false)
✅ Ready to Publish (appears in completed section)
    ↓ (press a-z or use 'p' menu)
🚀 Published (committed to git, deployed automatically)
```

### Session-Based Theme Switching

- **Writing Mode**: Quiet Light theme with Georgia font, optimized for prose
- **Coding Mode**: Community Material Theme, optimized for development
- **Automatic**: Switches when opening posts, restores when session ends

## Architecture

### Modular Design
```
zwrite                    # Main orchestrator script
├── lib/
│   ├── menu.sh          # Interactive menus and draft/completion detection
│   ├── frontmatter.sh   # Post creation and metadata management
│   ├── editor.sh        # Cursor integration and theme switching
│   ├── publish.sh       # Git operations and publishing workflow
│   ├── session.sh       # Session management and cleanup
│   └── themes.sh        # Theme switching functionality
└── config/
    └── sites.json       # Multi-site configuration
```

### Git Integration
- **Draft progress**: Commits with word count and WIP status
- **Publishing**: Commits with metadata (word count, images, categories)
- **Deletion**: Proper `git rm` with history preservation
- **All operations**: Descriptive commit messages with Claude Code attribution

## Requirements

- **Hugo-based websites** with standard content structure
- **Git repositories** with CI/CD for automated deployment
- **Cursor editor** with Code Spell Checker extension
- **macOS/Linux** (AppleScript automation requires macOS)
- **jq** for JSON manipulation (usually pre-installed)

## Configuration

### Site Configuration (`config/sites.json`)
```json
{
  "sites": {
    "dsc": {
      "name": "Digital Sovereignty Chronicle",
      "path": "/Users/username/github/digital-sovereignty",
      "description": "Crypto, AI, and digital sovereignty insights",
      "url": "https://digitalsovereignty.herbertyang.xyz",
      "active": true,
      "frontmatter_defaults": {
        "categories": ["Technology"],
        "tags": ["AI", "Crypto", "Digital Sovereignty"],
        "author": "Herbert Yang"
      }
    }
  }
}
```

### Cursor Settings
The theme switching functionality modifies your Cursor `settings.json` temporarily during writing sessions. Your original settings are preserved and restored when sessions end.

## Advanced Usage

### Command Line Interface
```bash
# Interactive mode (recommended)
./zwrite

# Quick draft saving
./zwrite save "My Draft Title"

# Quick publishing
./zwrite publish "Completed Post Title"

# Status overview
./zwrite status

# Help
./zwrite help
```

### Git Workflow Integration
All operations create meaningful git commits:

```bash
# Draft progress commits
"Draft progress: Post Title (250 words)
🚧 Work in progress - not ready for publication"

# Publishing commits  
"Publish: Post Title
📝 1,200 words
🖼️ 3 images
🏷️ Technology"

# Deletion commits
"Delete draft: Post Title
🗑️ Draft removed from version control"
```

## Troubleshooting

### Common Issues

**Theme not switching**
- Ensure Cursor is properly installed and can be launched from command line
- Check that `jq` is available for JSON manipulation

**Posts not found**
- Verify your site path in `config/sites.json`
- Ensure Hugo content structure: `content/posts/YYYY/MM/DD-slug/index.md`

**Git operations failing**
- Check that you're in a git repository
- Ensure you have commit access to the repository
- Verify remote repository is configured

**Cursor automation not working**
- AppleScript automation requires macOS
- Ensure Cursor has necessary accessibility permissions
- Manual layout setup instructions are provided as fallback

## Contributing

This is a personal workflow tool, but contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your own Hugo sites
5. Submit a pull request

## License

MIT License - feel free to adapt for your own writing workflow.

## Acknowledgments

- Inspired by the Zettelkasten method of knowledge management
- Built with the assistance of [Claude Code](https://claude.ai/code)
- Optimized for Hugo static site generators
- Designed for Cursor editor integration

---

*Built for writers who think in networks, not silos.*