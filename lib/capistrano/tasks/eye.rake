namespace :eye do
  task :load do
    on release_roles(:job) do
      within(release_path) do
        execute :mkdir, "-pv", "$HOME/eye"
        execute :eye, :load,  fetch(:eye_config, "./config/#{fetch(:application)}.eye")
      end
    end
  end

  %w(start stop restart info).each do |cmd|
    task cmd.to_sym do
      on roles(:job) do
        execute :eye, cmd.to_sym, fetch(:eye_application, fetch(:application))
      end
    end
  end

  before :start, :load
  before :restart, :load
end

after 'deploy:publishing', 'eye:restart'
