# Pagy Documentation

## Overview
Pagy is a fast, lightweight, and highly customizable pagination gem for Ruby on Rails applications. It's designed to be simple to use while providing powerful features.

## Installation

1. Add to your Gemfile:
```ruby
gem 'pagy'
```

2. Run bundle install:
```bash
bundle install
```

3. Include Pagy in your application controller:
```ruby
class ApplicationController < ActionController::Base
  include Pagy::Backend
end
```

4. Include Pagy in your application helper:
```ruby
module ApplicationHelper
  include Pagy::Frontend
end
```

## Configuration

### Initial Configuration
Create an initializer file at `config/initializers/pagy.rb`:

```ruby
require 'pagy/extras/bootstrap'
require 'pagy/extras/items'

Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:size]  = [1, 4, 4, 1] # nav bar size
Pagy::DEFAULT[:page_param] = :page
```

## Usage

### Basic Usage in Controllers
```ruby
class PostsController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.all)
  end
end
```

### With Search/Filter
```ruby
def index
  @q = Post.ransack(params[:q])
  @pagy, @posts = pagy(@q.result)
end
```

### With Associations
```ruby
def show
  @user = User.find(params[:id])
  @pagy, @posts = pagy(@user.posts)
end
```

### View Helpers
```erb
<%# Basic navigation %>
<%== pagy_nav(@pagy) %>

<%# Bootstrap navigation %>
<%== pagy_bootstrap_nav(@pagy) %>

<%# Items selector %>
<%== pagy_items_selector_js(@pagy) %>

<%# Info about current page %>
<%== pagy_info(@pagy) %>
```

### Customizing the Navigation
```erb
<%# Custom navigation with Bootstrap %>
<nav aria-label="Page navigation">
  <ul class="pagination">
    <% if @pagy.prev %>
      <li class="page-item">
        <%= link_to 'Previous', url_for(page: @pagy.prev), class: 'page-link' %>
      </li>
    <% end %>
    
    <% @pagy.series.each do |item| %>
      <li class="page-item <%= 'active' if item.is_a?(Integer) && item == @pagy.page %>">
        <%= link_to item, url_for(page: item), class: 'page-link' %>
      </li>
    <% end %>
    
    <% if @pagy.next %>
      <li class="page-item">
        <%= link_to 'Next', url_for(page: @pagy.next), class: 'page-link' %>
      </li>
    <% end %>
  </ul>
</nav>
```

### JavaScript Integration
```javascript
// Example with Turbo/Hotwire
document.addEventListener('turbo:load', function() {
  const paginationLinks = document.querySelectorAll('.pagination a');
  paginationLinks.forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      Turbo.visit(this.href);
    });
  });
});
```

## Best Practices

1. Always set a reasonable default number of items per page
2. Use the items selector for user customization
3. Implement proper caching for paginated queries
4. Consider using infinite scroll for better UX
5. Handle edge cases (empty collections, single page)
6. Use appropriate styling for your UI framework
7. Implement proper error handling for invalid page numbers
8. Consider using AJAX/Turbo for smoother pagination

## Performance Tips

1. Use `includes` to prevent N+1 queries
2. Implement proper database indexes
3. Consider using `select` to limit fields
4. Use `count` instead of `size` for total count
5. Implement caching for frequently accessed pages
6. Use database-level pagination when possible

## Troubleshooting

### Common Issues

1. **Count queries are slow**: 
   - Add proper indexes
   - Consider using approximate counts
   - Cache the count when possible

2. **Pagination not working**:
   - Check if Pagy is included in ApplicationController
   - Verify the page parameter name
   - Check for conflicting gems

3. **Styling issues**:
   - Ensure proper CSS is loaded
   - Check Bootstrap version compatibility
   - Verify custom styles are applied correctly

### Debugging Tips

1. Check the generated SQL queries
2. Verify the page parameter in the URL
3. Inspect the @pagy object in the console
4. Check the view helpers output

## Resources

- [Pagy GitHub Repository](https://github.com/ddnexus/pagy)
- [Pagy Documentation](https://ddnexus.github.io/pagy/)
- [Pagy Extras](https://ddnexus.github.io/pagy/extras) 