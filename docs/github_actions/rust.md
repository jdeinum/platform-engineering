# Rust CI/CD

Github actions lays an excellent foundation to build, test, and maintain quality
in your rust applications. Because Rust is a compiled language, we'll get to see
some parts of CI that you may not see with interpreted languages. Before we get
into a (somewhat) standard workflow, I want to explicitly state that I do not
use Github Actions for deploying applications. Tools like ArgoCD integrate very
well with github actions, and are REALLY good at the specific thing they are
supposed to do, which is deploy your software artifacts. With that aside, let's
get into it.

## Seeing Workflows in Action

If you'd rather just see the Rust workflows in action, I've prepped a [repo]()
that you can clone that already contains all of the workflows we are about to
talk about. Playing around with these things is an excellent way to learn about
them, good luck :)

## Stages

Instead of thining of CI as a black box, I think it's much easier to think about
it as a series of steps, which may depend on one-another. These steps may only
need to be run at particular stages of software deployment (am I building a
release? Or just merging code upstream? ). Consider what your needs are and
adapt the scripts to what you see fit.

### Testing

We all knew it was coming. Testing is a cornerstone of building reliable
software. Anytime we move our code somewhere people will access it, we
need to make sure it behaves as we expect it to. Tests are typically run using
cargo, which is Rusts official package manager and build tool. Running the tests
can be done with the following:

```yaml
# ...

name: test
jobs:
  required:
    runs-on: ubuntu-latest

    # ...

    strategy:
      matrix:
        toolchain: [stable]
    steps:
      # checkout our code, and follow submodules
      - uses: actions/checkout@v4
        with:
          submodules: true
        # install the required toolchain
        # in this case, we only install the stable toolchain as seen in the
        # matrix section
      - name: Install ${{ matrix.toolchain }}
        uses: dtolnay/rust-toolchain@master
        with:
          toolchain: ${{ matrix.toolchain }}

        # If our project doesn't already have a lockfile, we generate one
        # lockfiles pin the versions of our dependencies, and include checksums
      - name: cargo generate-lockfile
        if: hashFiles('Cargo.lock') == ''
        run: cargo generate-lockfile

        # run our tests
      - name: cargo test --locked
        run: cargo test --locked --all-features --all-targets

      # run our documentation tests, which for some reason aren't run with
      # --all-targets
      - name: cargo test --doc
        run: cargo test --locked --all-features --doc
```

And just like that, our code has all of its tests run. Cool!

#### Considerations

1. Do you want code coverage metrics? If so, check out [Codecov](https://about.codecov.io/)
2. You can use cargo [nextest](https://nexte.st/) if your testing requirements
   aren't met with cargo test.
3. Use [cargo-mutants](https://mutants.rs/) as a metric of test quality

### Benchmarking

### Correctness

### Code Quality

Whether you are working alone, or in a large team, standardized code formatting
and quality are important. Rust is thankful to have really good tooling through
[clippy](https://doc.rust-lang.org/stable/clippy/usage.html) and
[cargo-fmt](https://doc.rust-lang.org/nightly/cargo/commands/cargo-fmt.html),
that can be leveraged to ensure code quality. Here is a snippet of the workflow
file that runs these checks:

```yaml
name: check
jobs:
  clippy:
    runs-on: ubuntu-latest
    name: ${{ matrix.toolchain }} / clippy
    permissions:
      contents: read
      checks: write
    strategy:
      fail-fast: false
      matrix:
        toolchain: [stable]
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true
      - name: Install ${{ matrix.toolchain }}
        uses: dtolnay/rust-toolchain@master
        with:
          toolchain: ${{ matrix.toolchain }}
          components: clippy
      - name: cargo clippy
        uses: giraffate/clippy-action@v1
        with:
          reporter: "github-pr-check"
          github_token: ${{ secrets.GITHUB_TOKEN }}
  doc:
    runs-on: ubuntu-latest
    name: nightly / doc
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true
      - name: Install nightly
        uses: dtolnay/rust-toolchain@nightly
      - name: Install cargo-docs-rs
        uses: dtolnay/install@cargo-docs-rs
      - name: cargo docs-rs
        run: cargo docs-rs
  fmt:
    runs-on: ubuntu-latest
    name: stable / fmt
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true
      - name: Install stable
        uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt
      - name: cargo fmt --check
        run: cargo fmt --check
```

### Building

### Security

## Caching

## Cross Compiling

## Encapsulating Stages

1. Earthly
2. Nix
3. Dagger

## Considerations

## Resources
