alias zshconfig="code ~/.zshrc"
alias demobuilder=" ssh-add -K ~/.ssh/google_compute_engine 
gcloud compute ssh --zone us-west1-a  gf-demo-builder  -- -A"

eval $(thefuck --alias)
