# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/git/Ember"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "ember"; then

  # Load a defined window layout.
  load_window "programming"

  run_cmd "tmux resize-pane -t 1 -y 8"
  run_cmd "tmux resize-pane -t 2 -y 8"

  select_pane 1
  #run_cmd "tmux select-pane -t 1 -T 'db+frontend'"
  run_cmd "git pull"
  run_cmd "./scripts/sync-deps.sh frontend && cd frontend/ && npm run dev"

  select_pane 2
  #run_cmd "tmux select-pane -t 2 -T 'backend'"
  run_cmd "source backend/.venv/bin/activate && ./scripts/sync-deps.sh backend && cd backend/ && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 --env-file .env"

  select_pane 0
  #run_cmd "tmux select-pane -t 0 -T 'nvim'"
  run_cmd "cd . && source backend/.venv/bin/activate && nvim"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
