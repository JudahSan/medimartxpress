UHM Ordering System - Ruby on Rails Backend
=

Introduction
-

Project Setup
-

Sure, here's a basic guide to help someone set up the Rails project on their local development environment:

1. **Clone the Repository:**
    - If the Rails project is already hosted on a version control system like GitHub, provide the URL of the repository and instruct the user to clone it to their local machine using Git.

2. **Install Ruby:**
    - Instruct the user to install Ruby on their system if they haven't already. They can use a version manager like RVM or rbenv for managing Ruby versions.

3. **Install Rails:**
    - Once Ruby is installed, guide the user to install Rails using the following command:
      ```
      gem install rails
      ```

4. **Navigate to the Project Directory:**
    - Instruct the user to navigate to the directory of the cloned Rails project using the terminal or command prompt.

5. **Install Dependencies:**
    - Inside the project directory, guide the user to install the project dependencies (gems) using Bundler. They can run the following command:
      ```
      bundle install
      ```

6. **Install Postgres and create user**
   - Install Postgres
     ```
     sudo apt-get update
     sudo apt install postgresql postgresql-contrib libpq-dev
     ```
   - `postgresql` is a general database package. 
   - `postgresql-contrib` contains additional utilities and functionality. 
   - `libpq-dev` use for compiling C programs communicate with Postgres.
   - Let’s switch to postgres account to access to psql — terminal-based Postgres front-end program.
     ```
     sudo -i -u postgres
     psql
     ```
   - Now there is postgres=# environment. To create a new role enter the following command.
      ```
      CREATE ROLE <your_username> LOGIN SUPERUSER PASSWORD '<your_password>';
      ```
7. **Create Database:** `bin/rails db:create`
8. **Configure the Database:**
    - Instruct the user to configure the database by updating the `config/database.yml` file with their database credentials. They may need to create the corresponding database in their development environment.

9. **Run Migrations:**
    - After configuring the database, guide the user to run the database migrations using the following command:
      ```
      rails db:migrate
      ```

8. **Start the Rails Server:**
    - Once the migrations are complete, instruct the user to start the Rails server using the following command:
      ```
      ./bin/dev
      ```

9. **Verify Installation:**
    - Finally, provide instructions for verifying the installation by opening a web browser and navigating to `http://localhost:3000`. They should see the default Rails welcome page if the setup was successful.

**Prerequisites**

* Basic Ruby on Rails knowledge and a configured development environment.
* Access to the legacy Microsoft SQL Server database.
* Temporary secure tunneling solution (e.g., Ngrok) for development.

**Project Structure**

* `app/` - Rails application
    * `controllers/` - Handles API endpoints for order processing, etc.
    * `models/` - Customer, Order, Medication models.
    * `config/routes.rb` - Defines API routes.
* `legacy_integration/` TODO
    * `sync_script.rb`  - Script to query Rails database and update legacy database (or instructions for Delphi modifications).

**Getting Started**

1. **Rails Setup:**
    * Create a Rails project and generate models for Customer, Order, Medication, etc.
    * Establish the database connection.
    * Implement logic to bridge inventory checks with the legacy system.
2. **API Endpoints:**
    * Design API endpoints in your controllers for:
        * User authentication
        * Order submission
        * Order status updates
        * Statement retrieval
    * (Optional) API endpoint to receive updates from the legacy system if your integration method permits.

Port to Android using Turbo Native(TODO)
-



Legacy Integration(TODO)
-

[//]: # (* Establish a secure tunnel &#40;development&#41; or production VPN-like solution for data transfer.)

[//]: # (* **Sync Method:** Choose your synchronization strategy:)

[//]: # (    * **API Calls From Legacy System:** Modify your legacy Delphi application to call the Rails API.)

[//]: # (    * **Scheduled Sync:**  Develop a script on a machine within the Utibu network to fetch and push data between systems)

Security(TODO)
-

[//]: # (* Implement HIPAA-compliant security measures, including encryption, secure authentication, and regular audits. &#40;Details TBD&#41;)

**Deployment** (TODO)

* Deploy the app to Render.
