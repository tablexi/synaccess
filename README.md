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
        Telnet
            RevA
            RevB
```

## New connections

`connection = NetBooter::PROTOCOL::RevX.new('XXX.XXX.XXX.XXX', options)`

Options:

   * username
   * password

## Interface

All classes should implement the following methods:

   * `initialize(host, options)`
   * `status(outlet) => boolean`
   * `statuses => Hash of { outlet => boolean }`
   * `toggle(new_status, outlet) => new status boolean`



