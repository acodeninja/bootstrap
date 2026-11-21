# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:11.0.100

# The image has a passwd entry for uid 1000 only, so at any other uid $HOME is
# / and NuGet's migration runner dies creating a named mutex under it.
ENV HOME=/cache
ENV NUGET_PACKAGES=/cache/nuget
ENV DOTNET_CLI_HOME=/cache/dotnet-cli
ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# Priming on the real manifest leaves the packages in /cache, which the named
# volume seeds from, so the first `make test` needs no registry.
WORKDIR /prime
COPY global.json Directory.Build.props ./
COPY *.csproj ./
RUN mkdir -p src test \
    && printf 'namespace Prime;\n\npublic static class PrimeModule\n{\n    public static readonly bool Value = true;\n}\n' > src/Prime.cs \
    && printf 'namespace PrimeTests;\n\nusing Xunit;\n\npublic class PrimeTests\n{\n    [Fact]\n    public void PrimeTest() => Assert.True(true);\n}\n' > test/PrimeTests.cs \
    && dotnet test --results-directory /cache/test-results

# The primed obj/ records /prime as the project directory, so it is dropped and
# the first real run rebuilds it from the package cache beside it.
#
# /cache is world-writable so the service runs as any host uid without needing
# a passwd entry or a writable $HOME. See docs/containers.md "File ownership".
WORKDIR /work
RUN rm -rf /prime /cache/build /cache/test-results && chmod -R 777 /cache
