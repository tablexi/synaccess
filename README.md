# Synaccess Connect

Communication wrappers for Synaccess netBooter power relays.

## Supported Firmware:
   * NP-02
   * NP-02B

## Available interfaces
```
    NetBooter
        Http
            RevA
            RevB
```

The Telnet interface was removed in version 0.3.0 because it was unreliable. You
should switch to using the Http interface.

## Usage

* Add `gem "synaccess_connect", "~> 0.3.0"` to your Gemfile.

## Example

```ruby
connection = NetBooter::Http::RevA.new('XXX.XXX.XXX.XXX', username: "admin", password: "admin")
connection.status(1)
=> true
connection.toggle(false, 1)
connection.status(1)
=> false
```

## Interface

All classes should implement the following methods:

   * `initialize(host, options)`
   * `status(outlet) => boolean`
   * `statuses => Hash of { outlet => boolean }`
   * `toggle(new_status, outlet) => new status boolean`



