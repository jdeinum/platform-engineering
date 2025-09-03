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

If you'd rather just see the Rust workflows in action, I've prepped a
[repo](https://github.com/jdeinum/gha_demo) that you can clone that already
contains all of the workflows we are about to talk about. Playing around with
these things is an excellent way to learn about them.

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
cargo, which is Rusts official package manager and build tool. I choose to use
[nextest](https://nexte.st/) since it has a (seemingly) better performance
model. 

Another useful tool that you can choose to run during CI is
[cargo-mutants](https://mutants.rs/). Mutants gives you a general measure of
test quality through *logic chaos engineering*, which is just a fancy way of
saying that it changes your source code before it runs tests and makes sure
something fails.

If your software consists of a pipeline of several stages, consider using
snapshot testing with [insta](https://docs.rs/insta/1.41.1/insta/).  Snapshot testing
is a form of [data driven
testing](https://matklad.github.io/2021/05/31/how-to-test.html#Data-Driven-Testing).
It requires some extra work to maintain (mostly making sure you check your
snapshot files), but can make for extremely efficient testing.

Finally, test coverage can be a useful metric to help determine if you are
testing appropriately. [Codecov](https://about.codecov.io/) is an excellent tool
for generating test coverage reports. One thing to be careful of is writing poor
quality tests just to get a higher test coverage score. Make sure the tests are
meaninful, and if certain paths are not testable, just make codecov ignore them.


### Correctness

While testing proves correctness in particular code paths, a passing test suite
does not mean that your code doesn't have bugs in it. Typically these bugs are
non-deterministic, and may be very difficult to hit. There are many strategies
and tools you can use to either snuff these bugs out, or prove that they do not
exist. 

#### Property Based Testing 

Property based testing is an extension of
[fuzzing](https://rust-fuzz.github.io/book/introduction.html) that ensures
certain invariants are upheld. You describe the properties that should your
system should always have, and then the fuzzer runs a certain number of test
cases through it to make sure those properties are upheld. There are 2 common
options here, being [quickcheck](https://github.com/BurntSushi/quickcheck) and
[proptest](https://github.com/proptest-rs/proptest). I prefer quickcheck because
it is faster for generating complex types, and I haven't needed the by-value
shrinking for anything.

There isn't a dedicated workflow for fuzzing, because they defined as standard
rust tests. Something to keep in mind is that if you want long running fuzzing,
you should gatekeep those fuzz tests behind a feature or environment variable
like [matklad](https://matklad.github.io/2021/05/31/how-to-test.html) shows:

```rust
#[test]
fn completion_works_with_real_standard_library() {
  if std::env::var("RUN_SLOW_TESTS").is_err() {
    return;
  }
  ...
}
```

#### Verifiers 

I won't be talking in detail about all of these, and instead you should consider
the safety / correctness requirements you need and determine if any of these are
helpful.

- [loom](https://docs.rs/loom/0.7.2/loom/) deterministically explores all of the
  execution paths in multithreaded code. 
- [kani](https://model-checking.github.io/kani/) is a formal verifier for rust
code, helping to catch undefined behavior.
- [shuttle](https://docs.rs/shuttle/0.8.0/shuttle/) is simmilar to loom but
doesn't exhaustively search the problem space. In this way it is similar to
property based testing.
- [turmoil](https://docs.rs/turmoil/0.6.4/turmoil/) let's you build
deterministic simulation tests, a step towards what something like
[antithesis](https://github.com/AntithesisHQ) would do.
- [miri](https://github.com/rust-lang/miri) catches undefined behavior, and is
itself a fornm of deterministic simulation testing.
- Thread santizers, address sanitizers, valgrind, etc are language independent ways
  to catch undesired behavior.

### Benchmarking

If you have any SLAs or SLOs for your software, it's extremely important to
ensure new code changes do not have any regressions. You can choose to run
benchmarks within your test suite (using `--all-targets`), or create a separate
workflow. I prefer a separate workflow file, but it's really up to you. If you
do decide to make it a separate workflow, make sure you require it as a status
check on pull requests.

For creating benchmarks, I'd highly recommend looking at
[criterion](https://docs.rs/criterion/latest/criterion/). Another cool crate is
[tango](https://github.com/bazhenov/tango), which runs the old and new binaries
in an interleaved fashion to help reduce external noise.

One final note: For me, benchmarking takes the crown of the most difficult form
of metrics to reliably use. Not only do you need to understand the kind of
load your system expects (closed, open, semi-open), but you are also at the
mercy of factors outside of your control. It is *really really* easy to get
incorrect results and run with them. Make sure you understand what it is you are
trying to benchmark, and make sure that the way you are capturing it is
accurate. 


### Code Quality

Whether you are working alone, or in a large team, standardized code formatting
and quality are important. Rust is thankful to have really good tooling through
[clippy](https://doc.rust-lang.org/stable/clippy/usage.html) and
[cargo-fmt](https://doc.rust-lang.org/nightly/cargo/commands/cargo-fmt.html),
that can be leveraged to ensure code quality. Tools like these should be run on
every pull request and pushg to master to help maintain code quality.


### Building

Once you're confident that your code behaves in the intended manner, you need to
build it for the platform you intend to either run the binary or distribute it.
For non IoT / embedded code, we're usually building an OCI compliant image, and
it's probably to run on docker.

When building docker images, we have several goals in mind:

1. We want to avoid doing unecessary work 
2. We want our final image to be as small as possible 

The best way (that I know of) to avoid doing unecessary work is to ensure that
we don't compile our dependencies if they haven't changed.
[cargo-chef](https://github.com/LukeMathWalker/cargo-chef/blob/main/README.md)
is a tool made for this purpose. When combined with docker buildx caches, our CI
workflows do not need to rebuild our dependencies when they do not change.
Awesome!

To keep our images as small as possible, we want to use a multistage dockerfile
where the runtime image is the smallest image possible that still contains the
dependencies we need. Personally alpine is great for this, and is what I would
recommend most of the time. If you need packages that aren't available on
alpine, `debian-slim` is the next image I turn to.


### Security

Security is often ignored for the sake of releasing code quickly. Thankfully CI
can add some checks that help maintain your security posture that run really
quickly. [cargo-deny](https://docs.rs/cargo-deny/latest/cargo_deny/) is the
defacto tool for catching security issues, whether it be unmaintained crates,
known vulnerabilities, or license issues. 

`cargo-deny` should be run each time your dependencies are updated, but also
on a weekly basis because CVE databases may be updated during that time.

During build time, I'd highly recommend attaching an SBOM and provenance
attestations to your images. This will help you identify which machines may have
been vulnerable to particular issues during different time frames.

Finally, I find it is a good idea to run something like
[trivy](https://trivy.dev/latest/) on your images. Trivy gets run when an image
gets build, but also on a weekly schedule similar to `cargo-deny`. Trivy will
catch vulnerabilities, misconfigurations, leaked tokens, etc.

> **NOTE:** Static checks aren't a substituion for runtime security like
> [Falco](https://falco.org/).

## Caching

While some actions like Trivy contain their own cache, we have to setup caching
ourselves for our rust actions. Thankfully, there is an action that
[sets](https://github.com/marketplace/actions/rust-cache) up the cache for you.
Caching our dependencies and our cargo binary directory DRASTICALLY reduces the
amount of time your workflows take to run. 

