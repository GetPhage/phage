# from https://gist.github.com/jtomaszewski/8091945

# Thanks to http://makandracards.com/makandra/1431-resque-+-god-+-capistrano for an idea and v2 version.

namespace :god do
  def god_is_running
    capture(:bundle, "exec god status > /dev/null 2>&1 || echo 'god not running'") != 'god not running'
  end

  # Must be executed within SSHKit context
  def config_file
    "#{release_path}/config/god.rb"
  end

  # Must be executed within SSHKit context
  def start_god
    execute :bundle, "exec god -c #{config_file}"
  end

  desc "Start god and his processes"
  task :start do
    on roles(:web) do
      within release_path do
        with RAILS_ENV: fetch(:rails_env) do
          start_god
        end
      end
    end
  end

  desc "Terminate god and his processes"
  task :stop do
    on roles(:web) do
      within release_path do
        if god_is_running
          execute :bundle, "exec god terminate"
        end
      end
    end
  end

  desc "Restart god's child processes"
  task :restart do
    on roles(:web) do
      within release_path do
        with RAILS_ENV: fetch(:rails_env) do
          if god_is_running
            execute :bundle, "exec god load #{config_file}"
            execute :bundle, "exec god restart"
          else
            start_god
          end
        end
      end
    end
  end
end

after "deploy:updated", "god:restart"
