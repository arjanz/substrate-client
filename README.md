# Polkasource Substrate-Client
Polkasource Dockerfile for Substrate Clients

## Building a Substrate Client
Clone substrate-client repository
```bash
git clone https://github.com/polkasource/substrate-client.git
```

Change directory
```bash
cd substrate-client
```

Check available releases
```bash
git tag
```

Checkout a particular release (network-v#.#.#)
```bash
git checkout network-v#.#.#
```

Build the Substrate-Client (network-v#.#.#)
```bash
docker build -t 'polkasource/substrate-client:network-v#.#.#' .
```

