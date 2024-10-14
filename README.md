Here is a well-arranged version of your project README:

---

# UHM Ordering System - Ruby on Rails Backend

## Introduction
This project is a Ruby on Rails backend for an ordering system. It handles the processing of orders, customer management, and integration with legacy systems.

---

## Project Setup

### 1. **Clone the Repository**
If the project is hosted on a version control system like GitHub, clone it using the following command:
```bash
git clone <repository-url>
```

### 2. **Install Ruby**
Make sure Ruby is installed on your system. You can use a version manager like `rvm` or `rbenv` to manage Ruby versions. Install Rails:
```bash
gem install rails
```

### 3. **Navigate to the Project Directory**
```bash
cd <project-directory>
```

### 4. **Install Dependencies**
Install project dependencies using Bundler:
```bash
bundle install
```

### 5. **Install PostgreSQL and Create User**
To install PostgreSQL, run:
```bash
sudo apt-get update
sudo apt install postgresql postgresql-contrib libpq-dev
```
Then, create a PostgreSQL user:
```bash
sudo -i -u postgres
psql
CREATE ROLE <your_username> LOGIN SUPERUSER PASSWORD '<your_password>';
```

### 6. **Create Database**
```bash
bin/rails db:create
```

### 7. **Configure the Database**
Edit `config/database.yml` with your PostgreSQL credentials.

### 8. **Run Migrations**
```bash
rails db:migrate
```

### 9. **Start the Rails Server**
Run the development server:
```bash
./bin/dev
```

### 10. **Verify Installation**
Go to `http://localhost:3000` to verify the setup.

---

## Prerequisites

- Basic Ruby on Rails knowledge and a configured development environment.
- PostgreSQL installed and configured.
- Access to legacy systems (e.g., Microsoft SQL Server).
  
---

## Project Structure

- **`app/`** - Rails application
  - **`controllers/`** - API endpoints for order processing.
  - **`models/`** - Customer, Order, and Medication models.
  - **`config/routes.rb`** - Defines API routes.
  
- **`legacy_integration/`** (TODO)
  - `sync_script.rb` - Queries Rails DB and updates the legacy system.
  
---

## API Endpoints

Design API endpoints in your controllers for:
- User authentication
- Order submission
- Order status updates
- Statement retrieval

---

## Legacy Integration (TODO)

- Establish a secure tunnel or VPN for data transfer.
- Develop a synchronization strategy between systems.
  
---

## Security (TODO)

- Implement HIPAA-compliant security measures (encryption, secure authentication, regular audits).

---

## Deployment (TODO)

Deploy the app to Render or other cloud services.

---

## Adding Secret Keys

Use the following command to add/edit secret keys:
```bash
EDITOR="code --wait" rails credentials:edit --environment=development
```

---

## Rubocop

Run Rubocop for code linting:
```bash
rubocop
```

---

## Docker Local Development Setup

### 1. **Set Up `docker-compose.yml`**

Ensure that PostgreSQL is defined in `docker-compose.yml`:
```yaml
version: '3'

services:
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: utibu_health_development
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  web_dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    command: bash -c "rm -f tmp/pids/server.pid && ./bin/rails server -b 0.0.0.0"
    volumes:
      - .:/rails
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgres://postgres:password@db:5432/utibu_health_development

volumes:
  postgres_data:
```

### 2. **Update `config/database.yml`**

Ensure `config/database.yml` uses the correct host:
```yaml
development:
  database: utibu_health_development
  host: db
  username: postgres
  password: password
```

### 3. **Start Docker Containers**
```bash
docker-compose up
```

### 4. **Create the Database**
```bash
docker-compose run web_dev rails db:create
```

### 5. **Run Migrations**
```bash
docker-compose run web_dev rails db:migrate
```

## Rebuilding docker image: after updating the Dockerfile, rebuilt the Docker image to apply changes:

```bash
docker-compose down
docker-compose build
docker-compose up
```
---


### Image processeing error fix

Some users have experienced this problem `LoadError in Admin::CategoriesController#index - Missing libvips Library` when accessing categories and products after creating them.

- *Fix*: Install the libvips library, which is required for image processing:

```bash
sudo apt-get install libvips42

```

### Summary of Key Steps:
1. Ensure `database.yml` uses `host: db` for development.
2. Configure `docker-compose.yml` for PostgreSQL.
3. Run `docker-compose up` to start the services.
4. Create and migrate the database inside the `web_dev` container.

---

## Future Enhancements
- **Port to Android using Turbo Native** (TODO)
- **Tailwind CSS error fix `The asset "tailwind.css" is not present in the asset pipeline.` ** (TODO)