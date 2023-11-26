require 'json'

namespace :dev do

  desc "Start jwt token edge function"
  task :jwt do
    system "supabase functions serve jwt_token --env-file ./supabase/.env.local"
  end
end