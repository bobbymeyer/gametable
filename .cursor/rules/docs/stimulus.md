# Stimulus Documentation

## Overview
Stimulus is a modest JavaScript framework that augments your HTML with just enough behavior to make it shine.

## Controllers

### Basic Structure
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Controller logic here
}
```

### Properties
- `this.application`: Access to the Stimulus Application instance
- `this.element`: The HTML element the controller is attached to
- `this.identifier`: The controller's identifier

### File Organization
- Place controllers in `app/javascript/controllers/`
- Name files as `[identifier]_controller.js`
- Export controller class as default

### Identifiers
- Used in HTML via `data-controller` attribute
- Naming conventions:
  - Single word: `clipboard`
  - Multiple words: `date-picker`
  - Nested: `users--list-item`

### Scopes
- Controller's scope includes its element and children
- Nested controllers maintain separate scopes
- Multiple controllers can be attached to one element

### Naming Conventions
- Method names: camelCase
- Identifiers: kebab-case
- Filenames: snake_case or kebab-case

## Lifecycle Callbacks

### Available Callbacks
- `initialize()`: Called once when controller is instantiated
- `connect()`: Called when controller is connected to DOM
- `disconnect()`: Called when controller is disconnected from DOM

## Actions

### Basic Usage
```html
<button data-action="click->hello#greet">Greet</button>
```

### Action Syntax
- `[event]->[controller]#[method]`
- Multiple events: `click->hello#greet keyup->hello#greet`
- Multiple controllers: `click->hello#greet click->goodbye#farewell`

## Targets

### Definition
```javascript
static targets = ["name", "output"]
```

### Usage
```html
<input data-hello-target="name">
<div data-hello-target="output"></div>
```

### Target Properties
- `this.nameTarget`: First matching target
- `this.nameTargets`: All matching targets
- `this.hasNameTarget`: Boolean check

## Values

### Definition
```javascript
static values = {
  name: String,
  age: Number,
  active: Boolean
}
```

### Usage
```html
<div data-hello-name-value="Alice"
     data-hello-age-value="30"
     data-hello-active-value="true">
```

### Value Properties
- `this.nameValue`: Get/set value
- `this.hasNameValue`: Boolean check

## CSS Classes

### Definition
```javascript
static classes = ["loading", "complete"]
```

### Usage
```html
<div data-hello-loading-class="is-loading"
     data-hello-complete-class="is-complete">
```

### Class Properties
- `this.loadingClass`: Get class name
- `this.hasLoadingClass`: Boolean check

## Best Practices

### Controller Design
- Keep controllers small and focused
- Use meaningful identifiers
- Follow naming conventions
- Use proper lifecycle management
- Handle errors gracefully

### HTML Integration
- Use data attributes consistently
- Keep HTML semantic
- Use proper ARIA attributes
- Follow accessibility guidelines

### Performance
- Minimize DOM queries
- Use proper event delegation
- Clean up event listeners
- Handle memory properly

## Common Patterns

### Form Handling
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  update() {
    this.outputTarget.textContent = this.inputTarget.value
  }
}
```

### Toggle State
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static classes = ["hidden"]

  toggle() {
    this.contentTarget.classList.toggle(this.hiddenClass)
  }
}
```

### Async Operations
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]
  static classes = ["loading", "complete"]

  async fetch() {
    this.element.classList.add(this.loadingClass)
    try {
      const response = await fetch("/data")
      const data = await response.json()
      this.statusTarget.textContent = data.message
    } catch (error) {
      this.statusTarget.textContent = "Error fetching data"
    } finally {
      this.element.classList.remove(this.loadingClass)
    }
  }
}
```

## Security

### Best Practices
- Sanitize user input
- Validate data
- Handle errors properly
- Use proper CSRF protection
- Follow security guidelines

### Common Issues
- XSS vulnerabilities
- CSRF attacks
- Data validation
- Error handling
- Memory leaks 