# Rails Api Server
## 初回 Setup

```bash
$ git clone git@github.com:yuzuki-aritomo/ReserveTaskBackend.git

$ cd ReserveTaskBackend

$ docker compose build

$ docker compose up -d

$ docker-compose run web rails db:create

$ docker-compose run web rails db:migrate
```

## docker起動

```bash
$ docker compose up -d
```
