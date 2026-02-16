# Hotwire Documentation

## Overview
Hotwire is an alternative approach to building modern web applications without using much JavaScript by sending HTML instead of JSON over the wire.

## Components

### Turbo Drive
- Handles navigation between pages
- Makes navigation feel faster
- Preserves scroll position
- Handles form submissions
- Works with browser history

### Turbo Frames
- Updates parts of a page
- Handles form submissions within frames
- Maintains state between updates
- Works with browser history
- Supports lazy loading

### Turbo Streams
- Real-time updates
- Broadcast changes to multiple clients
- Works with WebSocket
- Supports multiple actions (append, prepend, replace, etc.)
- Handles form submissions

### Stimulus
- Minimal JavaScript framework
- Works with HTML data attributes
- Handles user interactions
- Manages state
- Works with Turbo

## Best Practices

### When to Use
- Use Turbo Drive for page navigation
- Use Turbo Frames for partial updates
- Use Turbo Streams for real-time updates
- Use Stimulus only for interactive elements

### When Not to Use
- Don't use for complex client-side state
- Don't use for heavy client-side processing
- Don't use for complex animations
- Don't use for complex form validation

## Common Patterns

### Form Handling
- Use Turbo Drive for form submissions
- Use Turbo Frames for form updates
- Use Turbo Streams for form broadcasts
- Use Stimulus for form interactions

### Real-time Updates
- Use Turbo Streams for updates
- Use WebSocket for connections
- Use Action Cable for broadcasting
- Use proper error handling

### User Interactions
- Use Stimulus for interactions
- Use data attributes for configuration
- Use targets for element selection
- Use actions for event handling
- Use values for state management

## Security

### Best Practices
- Use CSRF protection
- Use proper authentication
- Use proper authorization
- Use secure WebSocket connections
- Use proper error handling

### Common Issues
- CSRF attacks
- XSS attacks
- Insecure WebSocket connections
- Improper error handling 