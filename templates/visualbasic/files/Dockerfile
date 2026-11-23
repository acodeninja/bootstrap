# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:10.0.404

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
COPY *.vbproj ./
# The primed obj/ records /prime as the project directory, so it is dropped and
# the first real run rebuilds it from the package cache beside it.
#
# /cache is world-writable so the service runs as any host uid without needing a
# passwd entry or a writable $HOME. See docs/containers.md "File ownership". The
# cleanup and the chmod share this layer deliberately: run separately the chmod
# rewrites the mode of every package NuGet just cached, and overlayfs then copies
# all of it again.
RUN mkdir -p src test \
    && printf 'Namespace Prime\n    Public Module PrimeModule\n        Public ReadOnly Value As Boolean = True\n    End Module\nEnd Namespace\n' > src/Prime.vb \
    && printf 'Imports Xunit\n\nNamespace PrimeTests\n    Public Class PrimeTests\n        <Fact>\n        Public Sub PrimeTest()\n            Assert.True(True)\n        End Sub\n    End Class\nEnd Namespace\n' > test/PrimeTests.vb \
    && dotnet test --results-directory /cache/test-results \
    && rm -rf /prime /cache/build /cache/test-results \
    && chmod -R 777 /cache

WORKDIR /work
