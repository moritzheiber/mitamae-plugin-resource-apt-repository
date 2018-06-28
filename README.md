# MItamae::Plugin::Resource::Ppa

This mitamae plugin is supposed to handle:

- Adding and removing PPA repositories on Ubuntu-compatible systems

## Usage

```ruby
ppa 'ppa:my/ppa'
```

The plugin will automatically add a `ppa:` in front of the name of the resource if it's missing, i.e. `my/ppa` becomes `ppa:my/ppa` automatically.

Available actions are `:add` and `:remove`.
