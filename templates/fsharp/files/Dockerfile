# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:10.0.404

# The image has a passwd entry for uid 1000 only, so at any other uid $HOME is
# / and NuGet's migration runner dies creating a named mutex under it.
ENV HOME=/cache
ENV NUGET_PACKAGES=/cache/nuget
ENV DOTNET_CLI_HOME=/cache/dotnet-cli
ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV PATH=/opt/dotnet-tools:$PATH

ARG FANTOMAS_VERSION=8.1.3

# dotnet format handles C# and Visual Basic only: on an F# project it prints a
# notice and exits 0, so it can never fail lint. Fantomas is the F# formatter.
RUN dotnet tool install fantomas --version "${FANTOMAS_VERSION}" --tool-path /opt/dotnet-tools

# Priming on the real manifest leaves the packages in /cache, which the named
# volume seeds from, so the first `make test` needs no registry.
WORKDIR /prime
COPY global.json Directory.Build.props ./
COPY *.fsproj ./
# The primed obj/ records /prime as the project directory, so it is dropped and
# the first real run rebuilds it from the package cache beside it.
#
# /cache is world-writable so the service runs as any host uid without needing a
# passwd entry or a writable $HOME. See docs/containers.md "File ownership". The
# cleanup and the chmod share this layer deliberately: run separately the chmod
# rewrites the mode of every package NuGet just cached, and overlayfs then copies
# all of it again.
RUN mkdir -p src test \
    && printf 'module Prime\n\nlet prime = ()\n' > src/prime.fs \
    && printf 'module PrimeTests\n\nopen Xunit\n\n[<Fact>]\nlet primeTest () = Assert.True(true)\n' > test/PrimeTests.fs \
    && dotnet test --results-directory /cache/test-results \
    && rm -rf /prime /cache/build /cache/test-results \
    && chmod -R 777 /cache

WORKDIR /work
