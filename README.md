# docker-ecs

Allows developers to test local code changes using docker-compose which orchestrates integration between the app server and both redis and postgres databases. The Dockerfile defined above can then be deployed to AWS ECS once testing has passed to ensure environment consistency between development and production!

# Requirements

You must have `docker` and `docker-compose` setup on your local machine

# Setup
1. Clone repo && `cd dokcer-ecs`
2. Run: `docker-compose up --build` (PS: this step might take a few minutes)
3. Goto `http://localhost:3000` on your browser to access guestbook application
