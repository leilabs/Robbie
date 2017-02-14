# Robbie
Media Information at your Fingertips

## Docs
### `robbie`, the friendly robot

Primarily you'll be using `info`, if you know what you want, but you can also use `search` if you're looking to find something general.

Specify one of the following afterwards (as well as as a title for the media)
- `movie`

  ```bash
  robbie info movie "Hitchhiker's Guide to the Galaxy"
  ```

- `tv`

  ```bash
  robbie info tv "Rick and Morty"
  ```

- `music`
  - `album`

  ```bash
  robbie info album "Pablo Honey" "Radiohead"
  ```

  - `song`

  ```bash
  robbie info song "Runaway" "Kanye West"
  ```

  - `artist`

  ```
  robbie info artist "The Rolling Stones"
  ```

- `book`

  ```bash
  robbie book "The Restaurant at the End of the Universe"
  ```


All commands return information regarding the query, each with their own unique keys and values. For example, movies or TV shows will provide a Rotten Tomatoes rating.

## Development

Clone the repo, built it with `robbie.gemspec`, and install the gem it builds (`robbie-*.gem`). Simple as that.

```bash
git clone https://github.com/BenP51/robbie

cd robbie

gem build robbie.gemspec
gem install robbie-*.gem
```

## LICENSE
This project is licenced under MIT. More information detailed in the [license file](LICENSE).
