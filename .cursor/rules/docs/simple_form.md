# Simple Form Documentation

## Overview
Simple Form is a Rails form builder that makes it easier to create forms with less code while maintaining flexibility.

## Basic Usage

### Form Setup
```ruby
<%= simple_form_for @user do |f| %>
  <%= f.input :name %>
  <%= f.input :email %>
  <%= f.button :submit %>
<% end %>
```

### Common Input Types
- text
- email
- password
- number
- date
- select
- check_box
- radio_button
- file

## Best Practices

### Form Organization
- Use partials for complex forms
- Use wrappers for custom styling
- Use input groups for related fields
- Use hints for help text
- Use placeholders for examples

### Validation
- Use model validations
- Use client-side validation
- Use error messages
- Use required fields
- Use custom validations

### Customization
- Use custom wrappers
- Use custom inputs
- Use custom components
- Use custom labels
- Use custom hints

## Common Patterns

### Nested Forms
```ruby
<%= simple_form_for @user do |f| %>
  <%= f.simple_fields_for :address do |address_form| %>
    <%= address_form.input :street %>
    <%= address_form.input :city %>
  <% end %>
<% end %>
```

### Collections
```ruby
<%= f.input :category, collection: Category.all, label_method: :name, value_method: :id %>
```

### Associations
```ruby
<%= f.association :category %>
```

### Custom Inputs
```ruby
<%= f.input :price, as: :currency %>
```

## Security

### Best Practices
- Use strong parameters
- Use CSRF protection
- Use proper validation
- Use proper sanitization
- Use proper error handling

### Common Issues
- Mass assignment
- XSS attacks
- CSRF attacks
- SQL injection
- Improper validation 