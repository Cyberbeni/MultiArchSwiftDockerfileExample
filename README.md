## Description

This is an example on how to set up building a multi-architecture docker image using the new Swift Static Linux SDK introduced along with Swift 6.0.

## TimeZone support

Supporting different time zones requires the `tzdata` package. By default this template is using an empty container as the base, the recommended base for only installing a couple smaller packages is `alpine`. This supports both passing the `TZ` environment variable and mounting `/etc/localtime` to set the desired default for classes like `DateFormatter`.

```diff
- FROM scratch AS release
+ FROM alpine AS release
+ RUN apk add --no-cache tzdata
```

## Locale support

As of Swift 6.0.1, `Locale.current` is hardcoded to be `en_001` on Linux. Manually passing a `Locale` instance to everything that uses it seems to be the only solution for using a custom `Locale` currently.

## TODOs

- TODO: Use base docker image that already includes static Linux SDK.
- TODO: Don't depend on `Foundation`, importing `FoundationEssentials` instead would result in a smaller binary size. `RunLoop` and other useful classes, like `Process`, can only be accessed through `Foundation` currently.
