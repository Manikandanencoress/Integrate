require 'rake'

['sandbox', 'staging', 'production'].each do |env|
  desc "Deploy the given git tag and tag to #{env}"
  task "deploy:#{env}", :tag do |_, args|
    CodePusher.new(env, args[:tag]).deploy!
  end

  desc "Rollback #{env} to tag"
  task "rollback:#{env}", :tag do |_, args|
    CodePusher.new(env,  args[:tag]).rollback!
  end
end


class CodePusher
  HEROKU_APP_PREFIX="sumuru"

  def initialize(environment_name, tag)
    @env = environment_name
    @tag = tag || previous_deploy
    @heroku_app_name = "#{HEROKU_APP_PREFIX}-#{@env}"
  end

  def deploy!
    puts green("DEPLOYING TAG: = #{@tag} = to heroku app #{@heroku_app_name}")
    push! && tag_ref_with(@env) && migrate_and_restart
    puts green("Win!")
  end

  def rollback!
    puts green("Rolling back #{@heroku_app_name} to #{@tag}")

    stop_the_presses!

    enter_maintenance!
    target_migration = `git checkout #{@tag} && ls db/migrate/ | tail -n1`.match(/(\d+)_.*/)[1]
    migrate_down!(target_migration)
    push!(:force => true)

    tag_ref_with(@env)
    tag_ref_with("#{@env}-rollback")
    migrate_and_restart
    exit_maintenance!

    `git checkout master`
    puts yellow("Rollback successful, make sure you are working on the right branch, currently master")
  end

  protected

  def previous_deploy
    last_two_revisions = `autotag list #{@env} | tail -n2 | awk {'print $1'}`
    previous_deploy = last_two_revisions.split(' ').to_a[0]
  end

  def tag_ref_with(env_name)
    timestamp = AutoTagger::Base.new({}).send(:timestamp)
    new_tag = "#{env_name}/#{timestamp}"
    command = [%{git fetch origin refs/tags/*:refs/tags/*},
               %{git update-ref refs/tags/#{new_tag} #{@tag}},
               %{git push origin refs/tags/*:refs/tags/*}].join(" && ")
    system(command) || raise("failed to tag")
  end

  def push!(opts={})
    puts green("Pushing #{@tag} to #{@heroku_app_name}")
    system("git push #{"--force" if opts[:force]} #{@env} +#{@tag}:master") || raise("failed to push to heroku")
  end

  def migrate_and_restart
    system(%{heroku rake db:migrate --app #{@heroku_app_name}}) || raise("migration failed")
    system(%{heroku restart --app #{@heroku_app_name}}) || raise("restarting heroku app failed")
  end

  def stop_the_presses!
    file_name = "stop_the_presses_#{Time.now.to_i}_spec.rb"
    system(%{cp script/support/stop_the_presses_spec.rb spec/lib/#{file_name}}) || raise("couldn't copy stop the presses")
    system(%{git add spec/lib/#{file_name}}) || raise("couldn't git add stop the presses")
    system(%{git ci -m "Stop the presses! ! We are rolling back. Add a failing test to prevent futher auto deploys until reolved." }) || raise("couldn't commit stop the presses")
    system(%{git push origin master}) || raise("couldn't push stop the presses")
  end

  def enter_maintenance!
    puts green('Entering Maintenance Mode on heroku')
    system("heroku maintenance:on --app #{@heroku_app_name}") || raise("failed to turn maintenance mode on")
  end

  def exit_maintenance!
    puts green("Turning the app back on, everything should be happy :)")
    system "heroku maintenance:off --app #{@heroku_app_name}" || raise("failed to turn maintenance mode off")
  end

  def migrate_down!(target_migration)
    puts green("Migrating down to #{target_migration}")
    system("heroku rake db:migrate:down VERSION=#{target_migration} --app #{@heroku_app_name}") || raise("failed to migrate database down")
  end

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def green(text)
    colorize(text, 32)
  end

  def yellow(text)
    colorize(text, 33)
  end
end
