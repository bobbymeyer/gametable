# Importmaps Documentation

## Overview
Importmaps is a modern way to use JavaScript modules in Rails without a build step, using native browser features.

## Basic Usage

### Setup
```ruby
# config/importmap.rb
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
```

### JavaScript Files
```javascript
// app/javascript/application.js
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
```

## Best Practices

### Module Organization
- Keep modules small and focused
- Use clear naming conventions
- Use proper file structure
- Use proper imports
- Use proper exports

### Dependencies
- Use CDN for common libraries
- Use local files for custom code
- Use proper versioning
- Use proper caching
- Use proper error handling

### Performance
- Minimize dependencies
- Use proper caching
- Use proper compression
- Use proper loading
- Use proper error handling

## Common Patterns

### Stimulus Controllers
```javascript
// app/javascript/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name"]

  greet() {
    console.log(`Hello, ${this.nameTarget.value}!`)
  }
}
```

### Custom Modules
```javascript
// app/javascript/utils/helpers.js
export function formatDate(date) {
  return new Date(date).toLocaleDateString()
}
```

### Third-party Libraries
```ruby
# config/importmap.rb
pin "lodash", to: "https://ga.jspm.io/npm:lodash@4.17.21/lodash.js"
```

## Security

### Best Practices
- Use proper CDN sources
- Use proper versioning
- Use proper caching
- Use proper error handling
- Use proper validation

### Common Issues
- XSS attacks
- CSRF attacks
- Insecure sources
- Improper caching
- Improper error handling 