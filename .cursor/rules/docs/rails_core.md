# Rails Core Documentation

## Key Concepts

### Convention over Configuration
- Rails follows the principle of "convention over configuration"
- Default behaviors and settings are based on common practices
- Custom configurations are only needed when deviating from conventions

### Model-View-Controller (MVC)
- Models: Business logic and data rules
- Views: Presentation layer
- Controllers: Handle requests and coordinate between models and views

### Active Record
- Object-relational mapping (ORM) framework
- Database abstraction layer
- Follows the Active Record pattern

### RESTful Design
- Resources are the core concept
- Standard CRUD operations
- RESTful routing conventions

## Best Practices

### Models
- Keep business logic in models
- Use validations and callbacks
- Use scopes for common queries
- Use associations for relationships
- Use STI for inheritance
- Use concerns for shared behavior

### Controllers
- Keep controllers thin
- Use strong parameters
- Use before_action for shared logic
- Use respond_to blocks
- Use flash messages
- Use proper HTTP status codes

### Views
- Use partials for reusable components
- Use layouts for shared structure
- Use helpers for view logic
- Use content_for for layout customization
- Use form builders
- Use I18n for text

## Common Patterns

### Authentication
- Use Rails built-in authentication
- Use has_secure_password
- Use sessions for state management
- Use before_action for authentication

### Authorization
- Use before_action for authorization
- Use role-based access control
- Use policy objects for complex rules

### Background Jobs
- Use Active Job
- Use Solid Queue for processing
- Use proper error handling
- Use retry mechanisms

### Caching
- Use fragment caching
- Use Russian doll caching
- Use low-level caching
- Use cache keys properly

## Security

### Best Practices
- Use strong parameters
- Use CSRF protection
- Use secure cookies
- Use proper authentication
- Use proper authorization
- Use secure headers
- Use content security policy

### Common Vulnerabilities
- SQL injection
- XSS attacks
- CSRF attacks
- Mass assignment
- Insecure direct object references 