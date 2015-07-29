# Specify which components you wish to include when
# the "home" component loads.

# bootstrap css framework
component 'bootstrap'

Opal.use_gem("salama-reader")
Opal.use_gem("salama-object-file")
Opal.append_path "app/main/lib"

css_file "hint.css"
