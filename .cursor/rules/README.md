# Rails Omakase Rules

This repository contains rules and configurations for Rails projects following the Omakase approach.

## Structure

```
.cursor/
├── rules/                 # Rule definitions
│   ├── tech_stack.yml    # Technology stack rules
│   ├── coding_style.yml  # Coding style rules
│   └── development_workflow.yml  # Development workflow rules
├── docs/                 # Documentation
│   ├── rails_core.md
│   ├── hotwire.md
│   ├── simple_form.md
│   ├── importmaps.md
│   ├── solid_queue.md
│   └── stimulus.md
└── bin/                  # Enforcement scripts
    └── enforce
```

## Usage

### Initial Setup

1. Add this repository as a git submodule:
```bash
git submodule add https://github.com/your-org/rails-omakase-rules.git .cursor
```

2. Run the setup script:
```bash
bin/setup
```

### Updating Rules

1. Pull the latest rules:
```bash
git submodule update --remote .cursor
```

2. Apply the updates:
```bash
bin/enforce -p all
```

## Rule Categories

1. **Tech Stack Rules**
   - Framework: Rails 8
   - Database: PostgreSQL
   - Authentication: Rails built-in
   - Real-time: Hotwire
   - Background Jobs: Solid Queue
   - Testing: Minitest
   - Asset Pipeline: Propshaft
   - Form Builder: Simple Form

2. **Coding Style Rules**
   - Rails conventions
   - Concise code
   - Minimal JavaScript
   - Code organization

3. **Development Workflow Rules**
   - Test-driven development
   - Git workflow
   - Code quality
   - Security practices

4. **Chatroom Strategy Rules**
   - Realtime architecture guidance for chat-heavy features
   - Authorization and test expectations for room/membership flows

## Enforcement

The rules are enforced through:
- Git hooks
- Rake tasks
- Custom scripts

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License 