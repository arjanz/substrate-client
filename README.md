# Polkasource Substrate
Polkasource Dockerfile for Substrate Network

## Building blockchain client
Clone blockchain client repository
```bash
git clone https://github.com/polkasource/substrate.git
```

Change directory
```bash
cd substrate
```

Check available releases
```bash
git tag
```

Checkout a particular release (network-v#.#.#)
```bash
git checkout network-v#.#.#
```

Build blockchain client (network-v#.#.#)
```bash
docker build -t 'polkasource/substrate:network-v#.#.#' .
```
