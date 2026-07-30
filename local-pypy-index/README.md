# Local PyPI with Protected `.htpasswd`

## What this repository provides

This repository contains a small local Python package index setup with HTTP basic authentication and examples for creating and managing users in an Apache-style `.htpasswd` file.

Included files:

- `docker-compose.yaml` - runs a local `pypiserver` instance and a browser-based package index UI
- `.htpasswd` - authentication data source for the package index
- `README.md` - documentation and usage examples for Docker Compose and `.htpasswd` management

## Prerequisites

- Docker or Docker Desktop installed on your machine
- Python 3.x installed for `.htpasswd` user management commands
- `passlib==1.7.4` for running the Python examples below

Install the required Python package with pip:

```console
pip install passlib==1.7.4
```

## Docker Compose setup

The repository includes `docker-compose.yaml` to run a private Python package index and a web UI.

### Services

- `pypiserver` (`local-python-index`)
  - image: `pypiserver/pypiserver:latest`
  - published port: `8080`
  - purpose: expose a private PyPI-compatible repository over HTTP
  - auth: uses `./.htpasswd` mounted read-only as `/data/.htpasswd`
  - command: `run -P /data/.htpasswd --disable-fallback`
    - `-P /data/.htpasswd` enables HTTP basic auth using the mounted htpasswd file
    - `--disable-fallback` prevents the server from proxying requests to public PyPI

- `pypi-web-ui` (`pypi-frontend`)
  - image: `python:3.11-slim`
  - published port: `8081`
  - purpose: provide a browser-based repository viewer for the local PyPI index
  - startup: installs `simple-repository-browser` at runtime and launches it against the private index URL
  - authentication: relies on `FRONTEND_USER` and `FRONTEND_PASSWORD` environment variables to authenticate to `pypiserver`

Both services are connected through the `pypi-network` bridge network so the UI container can reach `pypiserver` internally by hostname.

### Environment variables

The `docker-compose.yaml` runtime command reads `FRONTEND_USER` and `FRONTEND_PASSWORD` from the container environment. The easiest way to provide them is with a local `.env` file in the repository root.

A safe example file is provided as `.env.example`.

```env
# .env.example
FRONTEND_USER=your_username
FRONTEND_PASSWORD=your_password
REPOSITORY_URL=http://local-python-index:8080/simple/
```

Copy `.env.example` to `.env`, then replace the placeholder values with your own credentials.

The compose stack also includes `REPOSITORY_URL` for the UI service.

> Keep `.env` and `.htpasswd` out of version control. This repo already ignores both files via `.gitignore`.

### Start the stack

From the repository root, run:

```console
docker compose up -d
```

To stop and remove the containers:

```console
docker compose down
```

### How to use the services

- Visit `http://localhost:8081` in your browser to open the package index UI
- The UI connects internally to `http://local-python-index:8080/simple/`
- Use a valid htpasswd user and password when the browser prompts for authentication

### Important notes

- Make sure `./.htpasswd` exists before starting the stack. If it is missing, `pypiserver` may fail to start because authentication is enabled.
- `pypiserver` is configured to serve only the local index and will not fallback to public PyPI.
- The web UI container installs its UI dependencies on first startup, so the initial launch may take longer.

## User management with `.htpasswd`

This repository also demonstrates how to create and manage users in an Apache-style `.htpasswd` file using Python.

It uses `passlib==1.7.4` and the `HtpasswdFile` API from `passlib.apache`.

### Create a new `.htpasswd` file

Create a new `.htpasswd` file in the current directory:

```console
python -c "from passlib.apache import HtpasswdFile; ht = HtpasswdFile('.htpasswd', new=True); ht.save()"
```

This command:

- creates a new `.htpasswd` file
- initializes it as empty
- saves the file to disk

### Add a new user to an existing `.htpasswd` file

Add or update a user in an existing `.htpasswd` file:

```console
python -c "from passlib.apache import HtpasswdFile; ht = HtpasswdFile('.htpasswd'); ht.set_password('<username>', '<password>'); ht.save()"
```

This command:

- opens `.htpasswd`
- creates or updates the user `<username>`
- stores the password securely using the default hash scheme
- saves the updated file

### Create a new file and add a user in one step

If the file does not exist yet, create it and add a user with one command:

```console
python -c "from passlib.apache import HtpasswdFile; ht = HtpasswdFile('.htpasswd', new=True); ht.set_password('<username>', '<password>'); ht.save()"
```

### Security and usage notes

- Keep `.htpasswd` secure and do not commit it to public version control.
- Use strong passwords for all users.
- To change an existing password, call `ht.set_password(username, new_password)` and save the file again.
- To manage multiple users, call `ht.set_password(...)` for each user before `ht.save()`.
