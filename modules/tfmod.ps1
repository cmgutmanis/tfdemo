# Scaffolds out a new directory and empty files for a terraform module definition, variables file, and outputs file.
# Create alias and/or add to ps profile for quick scaffolding. 

$module=$args[0]
New-Item -Path "./$module" -ItemType Directory
New-Item -Path "./$module/$module.tf"
New-Item -Path "./$module/$module.variables.tf"
New-Item -Path "./$module/$module.outputs.tf"