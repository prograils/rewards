Rewards is a simple app for rewarding your coworkers.

Steps to deploy on heroku (assumes You already have an account with billing information filled):
1. Clone repo (git clone https://github.com/prograils/rewards.git)
2. Change directory to your new app (cd rewards)
3. Run bundle install
4. Create .env file with your own env variables
5. Add a heroku remote to the local git repository (heroku create)
6. Set configuration variables - heroku config:set $(sed '/^[A-Z0-9_]\+=/!d' .env)
7. Deploy an app (git push heroku master)
8. Migrate schema (heroku run rake db:migrate)
9. Populate database (heroku run rake db:seed)
10. Add Heroku Scheduler (add-on for cron job) to app (heroku addons:add scheduler:standard)
11. Open Heroku Scheduler (heroku addons:open scheduler) and put 'rake close_previous_month' as task name, check 'daily' is choosen as frequency
