# [zolidity](https://github.com/z0r0z/zolidity) [![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/license/mit) [![solidity](https://img.shields.io/badge/solidity-%5E0.8.28-black)](https://docs.soliditylang.org/en/v0.8.28/) [![Foundry](https://img.shields.io/badge/Built%20with-Foundry-000000.svg)](https://getfoundry.sh/) ![tests](https://github.com/z0r0z/zzz/actions/workflows/ci.yml/badge.svg)

`Zolidity`: Zero-to-One Solidity with Simplicity-first.

## Getting Started

Run: `curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup`

Build the foundry project with `forge build`. Run tests with `forge test`. Measure gas with `forge snapshot`. Format with `forge fmt`.

## GitHub Actions

Contracts will be tested and gas measured on every push and pull request.

You can edit the CI script in [.github/workflows/ci.yml](./.github/workflows/ci.yml).

## Blueprint

```txt
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
├─ solady — https://github.com/vectorized/solady
src
├─ ERC20 — Standard fungible token.
├─ ERC173 — Standard contract ownership.
├─ ReentrancyGuard — Reentrant call guard.
test
├─ ERC20.t - Test standard fungible token.
├─ ERC173.t — Test standard contract ownership.
└─ ReentrancyGuard.t — Test reentrant call guard.
```

## Inspiration

- [solady](https://github.com/Vectorized/solady)
- [solmate](https://github.com/transmissions11/solmate)
- [snekmate](https://github.com/pcaversaccio/snekmate)

## Disclaimer

*These smart contracts and testing suite are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of anything provided herein or through related user interfaces. This repository and related code have not been audited and as such there can be no assurance anything will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk.*

## License

See [LICENSE](./LICENSE) for more details.
