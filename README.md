## Description

This is the template I use for setting up new Swift projects.

## Usage

- Click use template
- Select `Git content` and `Branch protection`
- Run `./template/bootstrap.sh`, fill in the rest of `README.md`
- Commit & Push
- Settings -> Branches -> Edit -> Disable push
- Settings -> Units -> Manually copy from another repository and modify where needed -> Save

## TimeZone support

This setup supports both passing the `TZ` environment variable and mounting `/etc/localtime` to set the desired default for classes like `DateFormatter`. This needs the full `Foundation` to be imported (as of Swift 6.3.3) or you have to fall back to using locatime_r, like [here](https://codeberg.org/Cyberbeni/CBLogging/src/commit/63d7151f590d9c1195cb4e3c2e0de1ca9a00f17f/Sources/CBLogging/Formatter.swift#L27-L36).

## Locale support

As of Swift 6.3.3, `Locale.current` is hardcoded to be `en_001` on Linux. Manually passing a `Locale` instance to everything that uses it seems to be the only solution for using a custom `Locale` currently.
