# Drop All Databases

Super useful, production ready, tool(s) to drop all* those pesky mysql databases.

Note: *all databases besides the ones MySQL wouldn't let you delete. Or at least probably wouldn't. I dunno, I've never tried to drop any of those. I'm not a monster.

## Configuration

You can either set the values in `.env` to whatever you want, or copy it to `.env.local` to be whatever you want.

## Usage

### Ruby

```!shell
ruby drop-all-databases.rb
```

### Rust

```!shell
cd rust
cargo run
```
