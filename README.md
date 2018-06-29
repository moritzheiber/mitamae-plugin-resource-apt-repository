# MItamae::Plugin::Resource::AptRepository

This mitamae plugin is supposed to handle:

- Adding and removing Debian/Ubuntu repositories, including GPG signing keys, either as GPG key id (which you can also supply a keyserver for) or as a downloadable URL
- Adding and removing PPA repositories on Ubuntu-compatible systems

_Note: This module will install the `gpg` package if it isn't installed yet and you're specifying a key to be imported_

## Usage

The `name` attribute can be used to specify the URL:

```ruby
apt_repository 'https://my.repo/ubuntu bionic main'
```

or you can use the `url` attribute:

```ruby
apt_repository 'my repo' do
  url 'https://my.repo/ubuntu bionic main'
end
```
### with GPG key id

By default, keys are imported using `keyserver.ubuntu.com`.

```ruby
apt_repository 'my repo' do
  url 'https://some.repository/debian stable main'
  gpg_key '1234567890'
end
```

#### Specifying a keyserver

Optionally, you can specify the keyserver to fetch the repository key from.

```ruby
apt_repository 'some repo' do
  url 'https://some.repo/ubuntu bionic universe'
  gpg_key '1234567890'
  keyserver 'https://keyserver.some.url:80'
```

### with a URL to a GPG key

_Note: The key's validity is not verified, I might add this at a later point in time._

```ruby
apt_repository 'something' do
  url 'https://some.repo'
  gpg_key 'https://some.repo/key.asc'
end
```

### Support for PPAs

The plugin also supports adding PPAs:

```ruby
apt_repository 'brightbox' do
  url 'ppa:brightbox/ruby'
end
```

## Actions

Available actions are `:add` and `:remove`.
