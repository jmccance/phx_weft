# Weft

Initial experimentation with Elixir and Phoenix. A toy API that allows users to create plaintext posts.

## Sample Usage

Create a new user:

```
POST /api/users
Content-Type: application/json

{
  "username": "cooldude70",
  "email": "cooldude70@hotmail.com",
  "password": "5w0rdf!5h"
}
```

"Login" as that user:

```
POST /api/login
Content-Type: application/json

{
  "username": "cooldude70"
}
```

Make a post:

```
POST /api/posts
Content-Type: application/json
Cookie: {the cookie returned from the login call}


{
  "content": "Hello, Weft!"
}
```

Check out your timeline:

```
GET /api/users/:your_user_id/posts
```

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
