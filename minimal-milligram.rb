def add_milligram
  run 'yarn add milligram'
  run append_to_file('app/javascript/packs/application.js', "import 'milligram/dist/milligram'")
end

def update_layout
  run 'rm app/views/layouts/application.html.erb'
  file 'app/views/layouts/application.html.erb', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MYAPP</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
HTML
end

def add_homepage
  generate(:controller, "Pages home")
  
  routes_content = <<-RUBY
Rails.application.routes.draw do
  root to: 'pages#home'
end
RUBY

  file 'config/routes.rb', routes_content, force: true  

  home_content = <<-HTML
<header class="header">
  <a href="" class="logo">My App</a>
  <input class="menu-btn" type="checkbox" id="menu-btn" />
  <label class="menu-icon" for="menu-btn"><span class="navicon"></span></label>
  <ul class="menu">
    <li><a href="#link1">Link1</a></li>
    <li><a href="#link2">Link2</a></li>
    <li><a href="#link3">Link3</a></li>
    <li><a href="#link4">Link4</a></li>
  </ul>
</header>
<div class="container first">
  <h1>Pages#home</h1>
  <p>Find me in app/views/pages/home.html.erb</p>
  <blockquote>
    <p><em>Milligram provides a minimal setup of styles for a fast and clean starting point.</em></p>
  </blockquote>
  <a class="button" href="https://milligram.io/#typography">Docs</a>
  <p>
  </p>
</div>
HTML
    file 'app/views/pages/home.html.erb', home_content, force: true
end

def add_gems
  gem 'simple_form'
end

def run_generate
  generate('simple_form:install')
end

def add_navbarcss
  navbar_content = <<-CSS
  body {
    margin:0;
}
.first {
    top:10vh;
}
a {
    color: #9b4dca;
  }
.header {
    background-color: #f4f5f6;
    box-shadow: 1px 1px 4px 0 rgba(0,0,0,.1);
    position: fixed;
    width: 100%;
    z-index: 3;
  }
   .header ul {
    margin: 0;
    padding: 0;
    list-style: none;
    overflow: hidden;
    background-color: #f4f5f6;
  }
   .header li a {
    display: block;
    padding: 20px 20px;
    border-right: 1px solid #f4f4f4;
    text-decoration: none;
  }
   .header li a:hover,
  .header .menu-btn:hover {
    background-color: #f4f4f4;
  }
   .header .logo {
    display: block;
    float: left;
    font-size: 2em;
    padding: 10px 20px;
    text-decoration: none;
  }
   .header .menu {
    clear: both;
    max-height: 0;
    transition: max-height .2s ease-out;
  }
    .header .menu-icon {
    cursor: pointer;
    display: inline-block;
    float: right;
    padding: 28px 20px;
    position: relative;
    user-select: none;
  }
    .header .menu-icon .navicon {
    background: #333;
    display: block;
    height: 2px;
    position: relative;
    transition: background .2s ease-out;
    width: 18px;
  }
    .header .menu-icon .navicon:before,
  .header .menu-icon .navicon:after {
    background: #333;
    content: '';
    display: block;
    height: 100%;
    position: absolute;
    transition: all .2s ease-out;
    width: 100%;
  }
   .header .menu-icon .navicon:before {
    top: 5px;
  }
    .header .menu-icon .navicon:after {
    top: -5px;
  }
    .header .menu-btn {
    display: none;
  }
    .header .menu-btn:checked ~ .menu {
    max-height: 240px;
  }
    .header .menu-btn:checked ~ .menu-icon .navicon {
    background: transparent;
  }
    .header .menu-btn:checked ~ .menu-icon .navicon:before {
    transform: rotate(-45deg);
  }
    .header .menu-btn:checked ~ .menu-icon .navicon:after {
    transform: rotate(45deg);
  }
    .header .menu-btn:checked ~ .menu-icon:not(.steps) .navicon:before,
  .header .menu-btn:checked ~ .menu-icon:not(.steps) .navicon:after {
    top: 0;
  }
  /* 48em = 768px */
    @media (min-width: 48em) {
    .first {
        top:11vh;
    }
      .header li {
      float: left;
    }
    .header li a {
      padding: 20px 30px;
    }
    .header .menu {
      clear: none;
      float: right;
      max-height: none;
    }
    .header .menu-icon {
      display: none;
    }
  }
CSS
  file 'app/assets/stylesheets/navbar.css', navbar_content
end

def update_readme
  readme_content = <<-MARKDOWN
Rails 6 app generated with milligram minimal css framework (yarn setup)
MARKDOWN
  file 'README.md', readme_content, force: true
end

def git_config
  say 'Creating Git Repo...', :green
  git :init
  git add: '.'
  git commit: %Q{ -m "init new rails 6 project with template from https://github.com/magiknono/rails-templates" }
end

def message_end
  say 'minimal rails app template with milligram created!', :green
  say "cd #{app_name} && rails s", :yellow
end

after_bundle do
  add_milligram
  update_layout
  rails_command 'db:create'
  rails_command 'db:migrate' 
  add_homepage
  add_gems
  run_generate
  add_navbarcss
  update_readme
  git_config
  message_end
end
