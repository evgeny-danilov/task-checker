# TASKS CHECKER

https://ruby-task-checker.herokuapp.com/

### General idea

This project provides a UI for automatic checks of learning tasks. 
The repo contains only specs and descriptions of tasks, 
but not the solution, so as students can't cheating.

To add new tasks, add spec file in the folder `lib/checkers/<your_task_name>/`.
Test file should called `spec.rb`, and basic template for this task called `template.rb`  

Note: Currently it's supported only RSpec framework.

### Further improvements

- apply hotwire to show details of failed specs (accordion) and keep user's inputs
- support saving and sharing the result (keep results in DB and generate unique link)
- support SQL tasks
- add syntax highlighting
- improve interface
